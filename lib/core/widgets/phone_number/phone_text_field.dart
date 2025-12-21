import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/colors.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneTextField extends StatelessWidget {
  const PhoneTextField({
    super.key,
    this.prefixText,
    this.controller,
    this.maxLen,
    this.prefixIcon,
    this.hintText,
    this.inputFormatters,
    required this.onChange,
    this.onComplete,
    this.contentPadding,
    this.readOnly = false,
    this.focusNode,
    this.onTap,
    this.bottomText,
  });

  final int? maxLen;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final String? hintText;
  final void Function(String) onChange;
  final void Function()? onComplete;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry? contentPadding;
  final String? prefixText;
  final String? bottomText;

  final bool readOnly;
  final FocusNode? focusNode;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colorTheme = Theme.of(context).extension<AppSemanticColors>()!;

    return TextField(
      focusNode: focusNode,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: TextInputType.number,
      onEditingComplete: onComplete,
      onChanged: onChange,
      maxLength: maxLen,
      style: textStyle.font24Regular.copyWith(color: colorTheme.textPrimary),
      controller: controller,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        prefixIconConstraints: const BoxConstraints(
          minHeight: 24,
          minWidth: 33,
        ),
        helper: SizedBox(
          height: 18,
          child: bottomText == null
              ? null
              : Text(bottomText!, style: textStyle.font16Medium),
        ),
        prefixText: prefixText,
        contentPadding: EdgeInsetsDirectional.only(top: 18 , bottom: 18),
        prefixIcon: prefixIcon,
        hintText: hintText,
        hintStyle: textStyle.font24Regular
                    .copyWith(color: colorTheme.textSecondary),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 4, color: colorTheme.textPrimary),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 4, color: AppColors.lightBlue500),
        ),
      ),
    );
  }
}
