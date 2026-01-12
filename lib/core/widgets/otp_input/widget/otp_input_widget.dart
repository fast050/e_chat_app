import 'package:e_chat_app/core/widgets/otp_input/widget/text_field_otp_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OTPInputWidget extends StatefulWidget {
  final void Function(String) onSubmitOTP;
  final bool isNotCorrectOTP;
  final int numberOfFields;

  const OTPInputWidget({
    super.key,
    required this.onSubmitOTP,
    required this.isNotCorrectOTP, 
    this.numberOfFields = 4,
  });

  @override
  State<OTPInputWidget> createState() => _OTPInputWidgetState();
}

class _OTPInputWidgetState extends State<OTPInputWidget> {
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
            isNotCorrectOTP: widget.isNotCorrectOTP,
            onChanged: handleOTPInput,
          ),
        );
      }),
    );
  }
}
