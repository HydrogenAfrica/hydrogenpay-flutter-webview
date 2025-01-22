<p align="center">
<img width="400" valign="top" src="https://hydrogenshared.blob.core.windows.net/shared/hydrogen-logo.png" data-canonical-src="https://hydrogenshared.blob.core.windows.net/shared/hydrogen-logo.png" style="max-width:100%; ">
</p>
 
# Hydrogen Flutter Webview SDK
 
Hydrogen Flutter SDK can be used to integrate the Hydrogen payment gateway into your flutter application.
 
## Requirements
 
Register for a merchant account on [https://dashboard.hydrogenpay.com](https://dashboard.hydrogenpay.com) to get started.
 
```
   Dart sdk: ">=3.4.3 <4.0.0"
   Flutter: ">=1.17.0"
   Android: minSdkVersion 17 and add support for androidx (see AndroidX Migration to migrate an existing app)
   iOS: --ios-language swift, Xcode version >= 12
```
 
 ## Installation

```bash
flutter pub get hydrogenpay_flutter_webview
```
 
## API Documentation
 
https://docs.hydrogenpay.com

 
## Support

If you have any problems, questions or suggestions, create an issue here or send your inquiry to support@hydrogenpay.com
 
## Implementation

You should already have your token, If not, go to [https://dashboard.hydrogenpay.com](https://dashboard.hydrogenpay.com).
 
## Options Type

| Name         | Type       | Required | Desc                                                                        |
| ------------ | ---------- | -------- | --------------------------------------------------------------------------- |
| currency     | `String`   | Required | The currency for the transaction e.g NGN, USD                               |
| email        | `String`   | Required | The email of the user to be charged                                         |
| description  | `String`   | Optional | The transaction description                                                 |
| customerName | `String`   | Required | The fullname of the user to be charged                                      |
| amount       | `Number`   | Required | The transaction amount                                                      |
| token        | `String`   | Required | Your token or see above step to get yours                                   |
| onSuccess    | `Function` | Required | Callback when transaction is successful                                     |
| onCancel     | `Function` | Required | Callback when transaction is closed of cancel                               |
| isRecurring  | `boolean`  | Optional | Recurring Payment                                                           |
| frequency    | `String`   | Optional | Recurring Payment frequency                                                 |
| mode         | `String`   | Required | Payment Mode e.g LIVE, TEST (default: TEST)                                 |
| endDate      | `String`   | Optional | Recurring Payment End Date. OPTIONAL but (REQUIRED when isRecurring = true) |

 
## Usage
 
```dart
import 'package:flutter/material.dart';
import 'package:hydrogenpay_flutter_webview/hydrogenpay_flutter_webview.dart';

class PaymentTest extends StatelessWidget {
const PaymentTest({Key? key}) : super(key: key);
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
            "Hydrogen Pay",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

paymentStart(context){
 PayloadModel payload = PayloadModel(
  currency: 'NGN', // REQUIRED
  email: "test@gmailinator.com", // REQUIRED
  description: "Test Payment", // OPTIONAL
  amount: "105", // REQUIRED
  apiKey: "Your API KEY", // REQUIRED
  CustomerName: "John Doe", // REQUIRED
  mode: "TEST", // REQUIRED
  meta: "ewr34we4w", // OPTIONAL
  isRecurring: false // OPTIONAL
  fequency: 1, // OPTIONAL
  endDate: "2025-10-02", // OPTIONAL but (REQUIRED when isRecurring: true)
);

HydrogenPay.startPayment(
  context, 
  payload: payload,
  onSuccess: (#) { print(#);}, 
  onCancel: (_) { print('_' _ 200);}
);

}
}

````

You can simply end the process by calling

```dart
HydrogenPayMethod.endPayment(context);
````

This removes the checkout view from the screen.


