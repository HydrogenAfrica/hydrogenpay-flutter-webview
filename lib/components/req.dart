import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hydrogenpay_flutter_webview/components/payload.dart';
import 'package:hydrogenpay_flutter_webview/components/state.dart';

String paymentMethods = "card";

///Creates an HTML string with information from that parsed Payload model
String initRequest(
    PayloadModel model, String reportLink, String x, WebViewState state) {
  return """
<!DOCTYPE html>
  <html>
  <head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hydrogen Pay</title>
  </head>
  <body>
  <script src="${model.mode == 'LIVE' ? 'https://hydrogenshared.blob.core.windows.net/paymentgateway/paymentGatewayIntegration_v1PROD.js' : 'https://hydrogenshared.blob.core.windows.net/paymentgateway/paymentGatewayIntegration_v1.js'}" module>
  </script>
  <script>
    let paymentResponse;
    let paymentObject = {
      "amount": "${model.amount}",
      "email": "${model.email}",
      "currency": "${model.currency}",
      "description": "${model.description}",
      "meta": "${model.meta}",
      "isAPI": false,
      "isRecurring":${model.isRecurring},
      "frequency":${model.frequency},
      "CustomerName":"${model.customerName}"
    }

    function onClose(e) {
      var response = {event:'close', e};
      window.flutter_inappwebview.callHandler(JSON.stringify(response))
    }

    function onSuccess(e) {
      var response = {event:'success', e};
      window.flutter_inappwebview.callHandler(JSON.stringify(response))
    }

    function callback(response) {
       window.flutter_inappwebview.callHandler('success', JSON.stringify(response));
    }

    async function openDialogModal(token) {
      paymentResponse =  handlePgData(paymentObject, token, onClose);
      paymentResponse = await paymentResponse
      callback(paymentResponse)
    }

    openDialogModal("${model.token}")


    let checkStatus = setInterval(async function() {
      const checkPaymentStatus = await handlePaymentStatus(paymentResponse, "${model.token}");
        if(checkPaymentStatus.status === "Paid"){
            onSuccess(checkPaymentStatus)
            callback(checkPaymentStatus)
            clearInterval(checkStatus)
         }
      }, 2000)

  </script>
  </body>
  </html>
   """;
}

///Generates A Uri from a raw HtML string
Uri createUri(PayloadModel payload, WebViewState webViewState) {
  return Uri.dataFromString(initRequest(payload, "==", '', webViewState),
      encoding: Encoding.getByName('utf-8'), mimeType: 'text/html');
}

///Creates a simple snackbr
void displaySnack(BuildContext context,
    {String? text,
    Color? color,
    Function()? onPressed,
    Color textColor = Colors.white}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    elevation: 40,
    content: Text(
      text!,
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.yellow,
    duration: Duration(seconds: 2),
  ));
}
