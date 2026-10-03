class Friend {
  final String id;
  final String name;
  final String phoneNumber;
  final String? avatarUrl;

  const Friend({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.avatarUrl,
  });

  factory Friend.fromJson(Map<String, dynamic> json) => Friend(
        id: json['id'] as String,
        name: json['name'] as String,
        phoneNumber: json['phone_number'] as String,
        avatarUrl: json['avatar_url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone_number': phoneNumber,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
      };
}
