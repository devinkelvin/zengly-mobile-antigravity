class SprayRecipientType {
  final String id;
  final String title;

  SprayRecipientType({required this.id, required this.title});

  static final List<SprayRecipientType> _sprayRecipientTypes = [
    SprayRecipientType(id: "singleRecipient", title: "Single Recipient"),
    SprayRecipientType(id: "multipleRecipient", title: "Multiple Recipients"),
    SprayRecipientType(id: "publicEventPool", title: "Public Event Pool"),
  ];

  static List<SprayRecipientType> get sprayRecipientTypes =>
      _sprayRecipientTypes;
}
