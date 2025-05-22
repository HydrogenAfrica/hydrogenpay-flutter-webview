///Model for the Payload  that takes in all the needed payment data

class PayloadModel {
  final String? currency,
      email,
      description,
      amount,
      apiKey,
      meta,
      callbackUrl,
      endDate,
      customerName;

  final num? frequency;
  final bool? isRecurring;
  final bool? legacy;

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
    this.endDate,
    this.legacy,
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
        legacy: json['Legacy'],
      );
}
