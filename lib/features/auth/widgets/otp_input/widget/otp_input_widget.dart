import 'package:e_chat_app/features/auth/widgets/otp_input/logic/otp_input_cubit.dart';
import 'package:e_chat_app/features/auth/widgets/otp_input/logic/otp_input_state.dart';
import 'package:e_chat_app/features/auth/widgets/otp_input/widget/otp_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        if (state.status == OtpStatus.verify ||
            state.status == OtpStatus.autoVerify ||
            state.status == OtpStatus.failed) {
          onVerfiyOTP(state.isVerifyOTP);
        }

        return Column(
          children: [
            OTPInput(
              onSubmitOTP: (otp) =>
                  context.read<OTPInputCubit>().verifyOTP(otp),
              status: state.status,
              numberOfFields: numberOfFields,
            ),
            SizedBox(
              height: 20.h,
            ),
            if (state.status == OtpStatus.failed)
              Text(
                "OTP is Not Correct",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.black),
              )
          ],
        );
      },
    );
  }
}
