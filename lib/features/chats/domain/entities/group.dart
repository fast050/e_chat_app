class Group {
  final String id;
  final String name;
  final List<String> memberIds;
  final String lastMessage;
  final List<String> avatarUrls;

  const Group({
    required this.id,
    required this.name,
    required this.memberIds,
    this.lastMessage = '',
    this.avatarUrls = const [],
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        id: json['id'] as String,
        name: json['name'] as String,
        memberIds:
            (json['member_ids'] as List).map((e) => e as String).toList(),
        lastMessage: json['last_message'] as String? ?? '',
        avatarUrls: (json['avatar_urls'] as List? ?? const [])
            .map((e) => e as String)
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'member_ids': memberIds,
      };
}
