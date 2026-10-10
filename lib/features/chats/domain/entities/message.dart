class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String text;
  final DateTime createdAt;
  final String? imageUrl;

  const Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.text,
    required this.createdAt,
    this.imageUrl,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'] as String,
        chatId: json['chat_id'] as String,
        senderId: json['sender_id'] as String,
        text: json['text'] as String? ?? '',
        createdAt: DateTime.parse(json['created_at'] as String),
        imageUrl: json['image_url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'chat_id': chatId,
        'sender_id': senderId,
        'text': text,
        if (imageUrl != null) 'image_url': imageUrl,
      };
}
