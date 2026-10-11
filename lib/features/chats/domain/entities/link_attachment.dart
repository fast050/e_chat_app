class LinkAttachment {
  final String id;
  final String chatId;
  final String url;
  final String title;
  final String? thumbnailUrl;
  final DateTime createdAt;

  const LinkAttachment({
    required this.id,
    required this.chatId,
    required this.url,
    required this.title,
    required this.createdAt,
    this.thumbnailUrl,
  });

  factory LinkAttachment.fromJson(Map<String, dynamic> json) => LinkAttachment(
        id: json['id'] as String,
        chatId: json['chat_id'] as String,
        url: json['url'] as String,
        title: json['title'] as String? ?? '',
        thumbnailUrl: json['thumbnail_url'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'chat_id': chatId,
        'url': url,
        'title': title,
        if (thumbnailUrl != null) 'thumbnail_url': thumbnailUrl,
      };
}
