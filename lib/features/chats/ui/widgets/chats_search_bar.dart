import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/features/chats/ui/widgets/header_glass_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatsSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onClose;

  const ChatsSearchBar({
    super.key,
    required this.onChanged,
    required this.onClose,
  });

  @override
  State<ChatsSearchBar> createState() => _ChatsSearchBarState();
}

class _ChatsSearchBarState extends State<ChatsSearchBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colors = Theme.of(context).extension<AppSemanticColors>()!;
    final inputStyle =
        textStyle.font16Regular.copyWith(color: colors.textPrimary);

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: widget.onChanged,
            textInputAction: TextInputAction.search,
            style: inputStyle,
            cursorColor: colors.textPrimaryBrand,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              hintText: 'Search',
              hintStyle: inputStyle.copyWith(
                color: colors.textPrimary.withValues(alpha: .3),
              ),
              contentPadding: EdgeInsets.fromLTRB(24.w, 12.h, 16.w, 12.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        HeaderGlassButton(
          size: 42.r,
          onTap: widget.onClose,
          child: SvgPicture.asset(
            'assets/svgs/close.svg',
            width: 24.r,
            height: 24.r,
          ),
        ),
      ],
    );
  }
}
