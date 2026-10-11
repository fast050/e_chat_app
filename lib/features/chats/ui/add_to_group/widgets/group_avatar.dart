import 'package:e_chat_app/features/chats/ui/shared/widgets/chat_avatar.dart';
import 'package:flutter/material.dart';

/// A group's avatar: two overlapping member pictures, or a single one (or the
/// group's initials) when fewer are known.
class GroupAvatar extends StatelessWidget {
  final String name;
  final List<String> avatarUrls;
  final double size;

  const GroupAvatar({
    super.key,
    required this.name,
    required this.avatarUrls,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    if (avatarUrls.length < 2) {
      return ChatAvatar(
        name: name,
        imageUrl: avatarUrls.isEmpty ? null : avatarUrls.first,
        size: size,
      );
    }

    final memberSize = size * 0.7;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: ChatAvatar(
              name: name,
              imageUrl: avatarUrls[0],
              size: memberSize,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ChatAvatar(
              name: name,
              imageUrl: avatarUrls[1],
              size: memberSize,
            ),
          ),
        ],
      ),
    );
  }
}
