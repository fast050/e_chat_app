import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:flutter/material.dart';

/// Cached remote picture with rounded corners (message images, media grid,
/// link thumbnails).
class ChatImage extends StatelessWidget {
  final String url;
  final double radius;
  final double? width;
  final double? height;

  const ChatImage({
    super.key,
    required this.url,
    required this.radius,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppSemanticColors>()!;
    final placeholder = ColoredBox(color: colors.cardBackground);

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (_, __) => placeholder,
        errorWidget: (_, __, ___) => placeholder,
      ),
    );
  }
}
