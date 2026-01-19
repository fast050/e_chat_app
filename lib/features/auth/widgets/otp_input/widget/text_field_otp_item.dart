import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/colors.dart';
import 'package:e_chat_app/core/theme/semantic_color.dart';
import 'package:e_chat_app/features/auth/widgets/otp_input/logic/otp_input_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldOtpItem extends StatefulWidget {
  final FocusNode? focusNode;
  final TextEditingController controller;
  final void Function()? onEditingComplete;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final OtpStatus otpStatus;

  const TextFieldOtpItem({
    super.key,
    this.focusNode,
    required this.controller,
    this.onEditingComplete,
    this.onSubmitted,
    this.onChanged,
    required this.otpStatus,
  });

  @override
  State<TextFieldOtpItem> createState() => _TextFieldOtpItemState();
}

class _TextFieldOtpItemState extends State<TextFieldOtpItem> {
  void enforceSingleDigitOtpInput(
    String value,
    TextEditingController controller,
  ) {
    if (value.length > 1) {
      // overwrite previous value, example value = 37 will take only the 7 and show it
      controller.text = value.substring(value.length - 1);
      moveCurorToEnd(controller);
    }
  }

  void moveCurorToEnd(TextEditingController controller) {
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).extension<AppTextTheme>()!;
    final colorThemeExt = Theme.of(context).extension<AppSemanticColors>()!;

    // Determine border colors based on OTP state
    // - Initial/Sending/Received: normal color (textPrimary)
    // - Failed: red error color
    // - Verify/AutoVerify: success color (textPrimary)
    final enableBorderColor = widget.otpStatus == OtpStatus.failed
        ? colorThemeExt.error
        : colorThemeExt.textPrimary;

    final focusedBorderColor = widget.otpStatus == OtpStatus.failed
        ? colorThemeExt.error
        : AppColors.lightBlue500;

    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      textAlign: TextAlign.center,
      onEditingComplete: widget.onEditingComplete,
      onSubmitted: widget.onSubmitted,
      style: textStyle.font39Bold.copyWith(color: colorThemeExt.textPrimary),
      decoration: InputDecoration(
        //contentPadding: EdgeInsetsDirectional.only(top: 18 , bottom: 18),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 4, color: enableBorderColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 4, color: focusedBorderColor),
        ),
      ),
      onTap: () {
        moveCurorToEnd(widget.controller);
      },
      onChanged: (value) {
        enforceSingleDigitOtpInput(value, widget.controller);
        if (widget.onChanged != null) widget.onChanged!(widget.controller.text);
      },
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }
}
