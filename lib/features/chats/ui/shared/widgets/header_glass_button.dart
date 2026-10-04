import 'package:e_chat_app/core/theme/colors.dart';
import 'package:flutter/material.dart';

/// Round header button; [isHighlighted] adds the translucent fill + glow the
/// design uses for "active" buttons (open add menu, search close).
class HeaderGlassButton extends StatelessWidget {
  final double size;
  final bool isHighlighted;
  // Fill when highlighted; defaults to the translucent white used on the blue
  // header. Light headers pass their own surface color.
  final Color highlightColor;
  final VoidCallback? onTap;
  final Widget child;

  const HeaderGlassButton({
    super.key,
    required this.size,
    required this.child,
    this.isHighlighted = true,
    this.highlightColor = AppColors.white20,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isHighlighted ? highlightColor : Colors.transparent,
          boxShadow: isHighlighted
              ? const [BoxShadow(color: Color(0x26000000), blurRadius: 20)]
              : const [],
        ),
        child: child,
      ),
    );
  }
}
