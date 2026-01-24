import 'package:e_chat_app/features/auth/shared/logic/auth_phone_step/auth_phone_step_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPhoneStepCubit extends Cubit<AuthPhoneStepState> {
  AuthPhoneStepCubit() : super(AuthPhoneStepState.initialState());
  
   void onUpdatePhoneNumberValidation(bool isValid){
     emit(state.copyWith(isPhoneNumberValid: isValid));
   }

}
