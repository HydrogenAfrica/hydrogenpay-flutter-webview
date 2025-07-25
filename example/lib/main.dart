import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hydrogenpay_flutter_webview/components/methods.dart';
import 'package:hydrogenpay_flutter_webview/components/payload.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //   if (Platform.isAndroid) {
  //   InAppWebViewController.setWebContentsDebuggingEnabled(true);
  // }

  runApp(MaterialApp(home: PaymentTest()));
}

class PaymentTest extends StatelessWidget {
  PaymentTest({Key? key}) : super(key: key);
  HydrogenPayMethod HydrogenPay = new HydrogenPayMethod();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 1000,
      width: 500,
      child: Center(
        child: TextButton(
          onPressed: () => paymentStart(context),
          child: Text(
            "Checkout",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  paymentStart(context) {
    PayloadModel payload = PayloadModel(
        currency: 'NGN',
        email: "test@gmailinator.com",
        description: "Sneakers",
        amount: "50",
        customerName: "Amos Test",
        apiKey: "PK_TEST_cca53e0b3bc7847aff94502b8a585f84",
        transactionRef: "TRX-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(1000)}",
        // metaData: [
        //   MetadataField(
        //     fieldName: "uniqueId",
        //     fieldDefaultValue: "DevStore14",
        //     fieldKey: "uniqueId",
        //     fieldType: 1,
        //   ),
        // ],
        legacy: false
        );

    HydrogenPay.startPayment(context, payload: payload, onSuccess: (_) {
      print(_);

      new Future.delayed(const Duration(milliseconds: 5000),
          HydrogenPayMethod.endPayment(context));
    }, onCancel: (_) {
      print('*' * 400);
    });
  }
}
