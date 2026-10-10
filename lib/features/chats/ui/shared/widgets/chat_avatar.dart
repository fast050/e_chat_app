import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:flutter/material.dart';

class ChatAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double size;
  // Defaults to the list-size style; large avatars pass a bigger one.
  final TextStyle? initialsStyle;

  const ChatAvatar({
    super.key,
    required this.name,
    required this.size,
    this.imageUrl,
    this.initialsStyle,
  });

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    final fallback = _InitialsAvatar(
      name: name,
      size: size,
      style: initialsStyle,
    );
    if (url == null) return fallback;

    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (_, __) => fallback,
        errorWidget: (_, __, ___) => fallback,
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  final String name;
  final double size;
  final TextStyle? style;

  const _InitialsAvatar({required this.name, required this.size, this.style});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .take(2)
        .map((word) => word.isEmpty ? '' : word[0].toUpperCase())
        .join();

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.badgeBackground,
        shape: BoxShape.circle,
      ),
      child: Text(
        initials,
        style: (style ?? textStyle.font16Bold)
            .copyWith(color: colors.textOnAccent),
      ),
    );
  }
}
