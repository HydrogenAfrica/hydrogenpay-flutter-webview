import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:hydrogenpay_flutter_webview/components/payload.dart';
import 'package:hydrogenpay_flutter_webview/components/req.dart';

import 'state.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen(
      {Key? key,
      required this.payload,
      required this.onSuccess,
      required this.onCancel})
      : super(key: key);
  final PayloadModel payload;
  final ValueSetter<Map> onSuccess;
  final ValueSetter<dynamic> onCancel;

  @override
  _WebViewScreenState createState() => new _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewSettings options = InAppWebViewSettings(
    useShouldOverrideUrlLoading: false,
    mediaPlaybackRequiresUserGesture: false,
    javaScriptEnabled: true,
    userAgent: "*",
    useHybridComposition: true, // Android-specific
    allowsInlineMediaPlayback: true, // iOS-specific
    javaScriptCanOpenWindowsAutomatically: true,
    transparentBackground: true,
    useOnLoadResource: true,
    supportMultipleWindows: true,
    domStorageEnabled: true,
    databaseEnabled: true,
    clearCache: true,
    thirdPartyCookiesEnabled: true,
    mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
  );

  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();
  bool loader = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WebViewState webViewState = Provider.of<WebViewState>(context);

    return WillPopScope(
        onWillPop: () async {
          webViewController?.goBack();
          return false;
        },
        child: SafeArea(
            top: true,
            child: Column(children: <Widget>[
              WillPopScope(
                onWillPop: () async {
                  webViewController!.goBack();
                  return false;
                },
                child: Expanded(
                  child: Stack(
                    children: [
                      InAppWebView(
                        key: webViewKey,
                        gestureRecognizers:
                            {Factory(() => EagerGestureRecognizer())},
                        initialUrlRequest: URLRequest(
                            url: WebUri(createUri(widget.payload, webViewState)
                                .toString())),
                        initialSettings: options,
                        onWebViewCreated: (controller) async {
                          webViewController = controller;
                          webViewState.setControllerOne(controller);

                          // Clear cache to ensure fresh SSL certificate is fetched
                          await InAppWebViewController.clearAllCache();
                          controller.addJavaScriptHandler(
                              handlerName: 'success',
                              callback: (_) {
                                // print(_[0]);
                                webViewState.setResponse(_);
                                widget.onSuccess(jsonDecode(_[0]));
                              });
                          controller.addJavaScriptHandler(
                              handlerName: 'close',
                              callback: (_) {
                                widget.onCancel(jsonDecode(_[0]));
                                Navigator.pop(context);
                              });
                        },
                        onReceivedServerTrustAuthRequest: (controller, challenge) async {
                          // Only bypass SSL for payment-v1.hydrogenpay.com domain
                          if (challenge.protectionSpace.host == "payment-v1.hydrogenpay.com") {
                            return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
                          }
                          // For other domains, use default certificate validation
                          return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.CANCEL);
                        },
                        onLoadStart: (controller, url) {
                          webViewState.setProgress(true);
                        },
                        onLoadStop: (controller, url) async {
                          webViewState.setProgress(false);
                        },
                        onReceivedError: (controller, request, error) {
                          webViewState.setProgress(false);
                          Navigator.pop(context);
                        },
                        onProgressChanged: (controller, progress) {
                          setState(() {
                            this.progress = progress / 100;
                            urlController.text = this.url;
                          });
                        },
                        onUpdateVisitedHistory:
                            (controller, url, androidIsReload) {
                          setState(() {
                            this.url = url.toString();
                            urlController.text = this.url;
                          });
                          webViewState.setReportLink('about:blank');
                        },
                      ),
                      progress < 1.0
                          ? LinearProgressIndicator(value: progress)
                          : Container(),
                    ],
                  ),
                ),
              ),
            ])));
  }
}
