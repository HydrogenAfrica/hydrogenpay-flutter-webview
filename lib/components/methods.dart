import 'package:flutter/material.dart';
import 'package:hydrogenpay_flutter_webview/display/hydrodenPay_screen.dart';
import 'package:hydrogenpay_flutter_webview/components/payload.dart';

class HydrogenPayMethod {
  ///Begins the payment by triggering the overlay of the Hydrogen Checkout Modal
  startPayment(context,
      {required PayloadModel payload,
      required Function(Map) onSuccess,
      required Function(dynamic) onCancel}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return HydrogenPay(
              payload: payload, onSuccess: onSuccess, onCancel: onCancel);
        });
  }

  ///A simple pop context.
  ///It removes the Hydrogen Checkout Modal from the current view
  static endPayment(context) {
    Navigator.pop(context);
  }
}
