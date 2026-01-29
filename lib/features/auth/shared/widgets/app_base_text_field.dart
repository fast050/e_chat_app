import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/colors.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:flutter/material.dart';

class AuthBaseTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Icon? prefixIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final void Function(String)? onChanged;

  const AuthBaseTextField({
    super.key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
  });

  @override
  State<AuthBaseTextField> createState() => _AuthBaseTextFieldState();
}

class _AuthBaseTextFieldState extends State<AuthBaseTextField> {
  String? _errorText; 
  
  void _validation(String value){
    setState(() {
       if(value.trim().isEmpty) {
         _errorText = "This Feild Should not be Empty";
       } else {
         _errorText = null;
       }
    });
   
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colorTheme = Theme.of(context).extension<AppSemanticColors>()!;

    return TextField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      onChanged: widget.onChanged,
      style: textStyle.font24Regular
          .copyWith(color: colorTheme.textPrimary),
      onSubmitted: (value) {
        _validation(value);
      },    
      decoration: InputDecoration(
        errorText: _errorText,
        errorStyle: textStyle.font16Medium.copyWith(
          color: colorTheme.error
        ),
        prefixIconConstraints: const BoxConstraints(
          minHeight: 24,
          minWidth: 33,
        ),
        contentPadding:
            const EdgeInsetsDirectional.only(top: 18, bottom: 18),
        prefixIcon: widget.prefixIcon,
        hintText: widget.hintText,
        hintStyle: textStyle.font24Regular
            .copyWith(color: colorTheme.textSecondary),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 4,
            color: colorTheme.textPrimary,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            width: 4,
            color: AppColors.lightBlue500,
          ),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 4,
            color: colorTheme.error,
          ),
        ),
      ),
    );
  }
}