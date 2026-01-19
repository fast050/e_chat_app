import 'package:e_chat_app/features/auth/widgets/otp_input/logic/otp_input_state.dart';
import 'package:e_chat_app/features/auth/widgets/otp_input/widget/text_field_otp_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OTPInput extends StatefulWidget {
  final void Function(String) onSubmitOTP;
  final OtpStatus status;
  final int numberOfFields;

  const OTPInput({
    super.key,
    required this.onSubmitOTP,
    required this.status, 
    this.numberOfFields = 4,
  });

  @override
  State<OTPInput> createState() => _OTPInputState();
}

class _OTPInputState extends State<OTPInput> {
  final FocusNode focusNode = FocusNode();
  late List<TextEditingController> controllers;

  void handleOTPInput(String value) {
    if (value.isNotEmpty) FocusScope.of(context).nextFocus();
    if (value.isEmpty) FocusScope.of(context).previousFocus();
    if (isFinishInputFullOTP()) widget.onSubmitOTP(getFullOTPText());
  }

  @override
  void initState() {
    super.initState();
    
    controllers = List.generate(widget.numberOfFields, (i) => TextEditingController());    
 
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        focusNode.requestFocus(); // to gain focus for the first otp item
      }
    });
  }

  bool isFinishInputFullOTP() {
    for (final controller in controllers) {
      if (controller.text.isEmpty) return false;
    }

    return true;
  }

  String getFullOTPText() {
    String resultText = "";

    for (final controller in controllers) {
      resultText += controller.text;
    }

    return resultText;
  }

  @override
  void dispose() {
    focusNode.dispose();
    controllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 24.w,
      children: List.generate(widget.numberOfFields, (i) {
        return Expanded(
          child: TextFieldOtpItem(
            controller: controllers[i],
            focusNode: i == 0 ? focusNode : null,
            otpStatus: widget.status,
            onChanged: handleOTPInput,
          ),
        );
      }),
    );
  }
}
