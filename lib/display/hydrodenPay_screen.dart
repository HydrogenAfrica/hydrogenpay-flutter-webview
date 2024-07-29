import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hydrogenpay_flutter_webview/components/payload.dart';
import 'package:hydrogenpay_flutter_webview/components/state.dart';
import 'package:hydrogenpay_flutter_webview/components/webViewScreen.dart';

class HydrogenPay extends StatefulWidget {
  const HydrogenPay(
      {Key? key,
      required this.payload,
      required this.onSuccess,
      required this.onCancel})
      : super(key: key);
  final PayloadModel payload;
  final ValueSetter<Map> onSuccess;
  final ValueSetter<dynamic> onCancel;
  @override
  _HydrogenPayState createState() => _HydrogenPayState();
}

class _HydrogenPayState extends State<HydrogenPay> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<WebViewState>(
              create: (context) => WebViewState()),
        ],
        child: WebViewScreen(
            payload: widget.payload,
            onSuccess: widget.onSuccess,
            onCancel: widget.onCancel));
  }
}
