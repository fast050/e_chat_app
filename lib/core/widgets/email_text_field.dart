import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/features/auth/shared/widgets/app_base_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmailTextField extends StatelessWidget {
  final void Function({
    required String email,
    required bool isEmailValid,
  }) onChanged;
  
  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  const EmailTextField({super.key , required this.onChanged});

  void _onValueChanged(String value) {
    final email = value.trim();
    onChanged(
      email: email,
      isEmailValid: _emailRegex.hasMatch(email),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorStyleExt = Theme.of(context).extension<AppSemanticColors>()!;

    return TextFieldWithIcon(
      hintText: "Email address",
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Icon(
        Icons.email_outlined,
        size: 30.w,
        color: colorStyleExt.textSecondary,
      ),
      onChanged: _onValueChanged,
      onSubmitted: _onValueChanged,
    );
  }
}