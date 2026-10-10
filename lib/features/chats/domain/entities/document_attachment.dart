class DocumentAttachment {
  final String id;
  final String chatId;
  final String name;
  final int sizeBytes;
  final DateTime createdAt;

  const DocumentAttachment({
    required this.id,
    required this.chatId,
    required this.name,
    required this.sizeBytes,
    required this.createdAt,
  });

  factory DocumentAttachment.fromJson(Map<String, dynamic> json) =>
      DocumentAttachment(
        id: json['id'] as String,
        chatId: json['chat_id'] as String,
        name: json['name'] as String,
        sizeBytes: json['size_bytes'] as int,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'chat_id': chatId,
        'name': name,
        'size_bytes': sizeBytes,
      };
}
