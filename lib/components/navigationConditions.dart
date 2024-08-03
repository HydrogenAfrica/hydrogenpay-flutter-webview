import 'package:hydrogenpay_flutter_webview/components/payload.dart';

///Method that checks if a payment confirmation link has been sent
bool shouldSwitchView(String url, PayloadModel model) {
  if ((url.contains("vers%3Done") || url.contains("vers%3Dtwo")) &
      url.toLowerCase().contains('pubk')) {
    return true;
  } else {
    return false;
  }
}
