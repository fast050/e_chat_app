import 'package:e_chat_app/features/auth/widgets/otp_input/logic/otp_input_cubit.dart';
import 'package:e_chat_app/features/auth/widgets/otp_input/logic/otp_input_state.dart';
import 'package:e_chat_app/features/auth/widgets/otp_input/widget/otp_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OTPInputWidget extends StatelessWidget {
  final int numberOfFields;
  final void Function(bool) onVerfiyOTP;

  const OTPInputWidget({
    super.key,
    required this.onVerfiyOTP,
    this.numberOfFields = 4, 
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OTPInputCubit, OTPInputState>(
      builder: (context, state) {
 
      onVerfiyOTP(state.isVerifyOTP);
        
      return OTPInput(
        onSubmitOTP: (otp) => context.read<OTPInputCubit>().onVoid(),
        isVerifyOTP: state.isVerifyOTP,
        numberOfFields: numberOfFields,
      );
      } ,
    );
  }
}
