///Model for the Payload  that takes in all the needed payment data

class PayloadModel {
  final String? currency,
      email,
      description,
      amount,
      apiKey,
      meta,
      isRecurring,
      frequency,
      callbackUrl,
      customerName;

  PayloadModel({
    required this.currency,
    required this.email,
    this.description,
    required this.amount,
    this.callbackUrl,
    required this.customerName,
    this.isRecurring,
    this.frequency,
    this.meta,
    required this.apiKey,
  });

  factory PayloadModel.fromJson(Map json) => PayloadModel(
        currency: json["Currency"],
        email: json["Email"],
        description: json["Description"],
        amount: json["Amount"],
        callbackUrl: json["CallbackUrl"],
        customerName: json['CustomerName'],
        meta: json['Meta'],
        isRecurring: json['IsRecurring'],
        frequency: json['Frequency'],
        apiKey: json['ApiKey'],
      );
}
