import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/outlined_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// "Search" input with the magnifier icon, used by the member and group
/// pickers.
class SearchTextField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const SearchTextField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppSemanticColors>()!;

    return OutlinedTextField(
      hintText: 'Search',
      onChanged: onChanged,
      prefix: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 12.w),
        child: SvgPicture.asset(
          'assets/svgs/search.svg',
          width: 24.r,
          height: 24.r,
          colorFilter: ColorFilter.mode(colors.textSecondary, BlendMode.srcIn),
        ),
      ),
    );
  }
}
