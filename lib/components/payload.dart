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
      customerName,
      transactionRef;

  final num? frequency;
  final bool? isRecurring;
  final bool? legacy;
  final List<MetadataField>? metaData; // Ensure MetadataField is defined below

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
    this.transactionRef,
    this.metaData,
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
        transactionRef: json['TransactionRef'],
        endDate: json['EndDate'],
        metaData: json['MetaData'] != null
            ? (json['MetaData'] as List)
                .map((item) => MetadataField.fromJson(item))
                .toList()
            : null,
      );
}

/// Represents a metadata field for the payload
class MetadataField {
  final String fieldName;
  final String fieldDefaultValue;
  final String fieldKey;
  final num fieldType;

  MetadataField({required this.fieldName, required this.fieldDefaultValue, required this.fieldKey, required this.fieldType});

  factory MetadataField.fromJson(Map<String, dynamic> json) {
    return MetadataField(
      fieldName: json['fieldName'] ?? '',
      fieldDefaultValue: json['fieldDefaultValue'] ?? '',
      fieldKey: json['fieldKey'] ?? '',
      fieldType: json['fieldType'] ?? 1, // Default to 1 if not provided
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fieldName': fieldName,
      'fieldDefaultValue': fieldDefaultValue,
      'fieldKey': fieldKey,
      'fieldType': fieldType,
    };
  }
}
