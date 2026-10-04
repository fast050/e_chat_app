class Chat {
  final String id;
  final String name;
  final String? avatarUrl;
  // Null for chats without a single other user (groups).
  final String? phoneNumber;
  final String lastMessage;
  final DateTime lastMessageAt;
  final int unreadCount;

  const Chat({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.lastMessageAt,
    this.avatarUrl,
    this.phoneNumber,
    this.unreadCount = 0,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json['id'] as String,
        name: json['name'] as String,
        avatarUrl: json['avatar_url'] as String?,
        phoneNumber: json['phone_number'] as String?,
        lastMessage: json['last_message'] as String? ?? '',
        lastMessageAt: DateTime.parse(json['last_message_at'] as String),
        unreadCount: json['unread_count'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        if (phoneNumber != null) 'phone_number': phoneNumber,
        'last_message': lastMessage,
        'last_message_at': lastMessageAt.toIso8601String(),
        'unread_count': unreadCount,
      };
}
