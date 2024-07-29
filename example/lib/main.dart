import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hydrogenpay_flutter_webview/components/methods.dart';
import 'package:hydrogenpay_flutter_webview/components/payload.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        amount: "102",
        customerName: "Amos Test",
        mode: "TEST",
        token:
            "E2E411B102072296C73F76339497FB8529FF552F0D6817E0F3B46A243961CA21");
    HydrogenPay.startPayment(context, payload: payload, onSuccess: (_) {
      print(_);

      new Future.delayed(const Duration(milliseconds: 5000),
          HydrogenPayMethod.endPayment(context));
    }, onCancel: (_) {
      print('*' * 400);
    });
  }
}
