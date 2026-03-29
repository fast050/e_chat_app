import 'package:e_chat_app/features/auth/register/ui/Register_otp_step_view.dart';
import 'package:e_chat_app/features/auth/register/ui/Register_phone_step_view.dart';
import 'package:e_chat_app/features/auth/register/ui/register_user_information_view.dart';
import 'package:e_chat_app/features/auth/shared/widgets/animated_background/auth_animated_background.dart';
import 'package:e_chat_app/features/auth/shared/widgets/animated_background/stack_background_with_shape_auth.dart';
import 'package:e_chat_app/features/auth/ui/logic/auth_flow_cubit.dart';
import 'package:e_chat_app/features/auth/ui/logic/auth_flow_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  Widget getCurrentView(RegisterStepView current) {
    switch (current) {
      case RegisterStepView.phone:
        return const RegisterPhoneStepView();
      case RegisterStepView.otp:
        return const RegisterOTPStepView();
      case RegisterStepView.userInformation:
        return const RegisterUserInformationView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthFlowCubit, AuthFlowState>(
      buildWhen: (previous, current) =>
          previous.registerStepView != current.registerStepView,
      builder: (context, state) {
        final currentView = state.registerStepView;
        return PopScope(
          canPop: currentView == RegisterStepView.phone,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) {
              context.read<AuthFlowCubit>().backRegisterStep();
            }
          },
          child: Scaffold(
            body: StackBackgroundWithShapeAuth(
              shouldAnimate: true,
              curveSidePosition: currentView == RegisterStepView.userInformation
                  ? CurveSidePosition.center
                  : CurveSidePosition.end,
              child: SingleChildScrollView(
                child: getCurrentView(currentView),
              ),
            ),
          ),
        );
      },
    );
  }
}
