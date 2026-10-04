import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/gradients.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageInputBar extends StatefulWidget {
  /// Called with the trimmed text; never called for a blank message.
  final ValueChanged<String> onSend;
  final VoidCallback? onAttach;

  const MessageInputBar({super.key, required this.onSend, this.onAttach});

  @override
  State<MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<MessageInputBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;
    final inputStyle =
        textStyle.font14Regular.copyWith(color: colors.textPrimary);

    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        top: false,
        minimum: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
        child: Row(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onAttach,
              child: Icon(Icons.add, size: 28.r, color: colors.badgeBackground),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                style: inputStyle,
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: colors.inputBackground,
                  hintText: 'Type a message ...',
                  hintStyle: inputStyle.copyWith(color: colors.textSecondary),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            _SendButton(onTap: _send),
          ],
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SendButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 42.r,
        height: 42.r,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppGradients.lightBlueGradient,
        ),
        child: Icon(Icons.send, size: 20.r, color: colors.textOnAccent),
      ),
    );
  }
}
