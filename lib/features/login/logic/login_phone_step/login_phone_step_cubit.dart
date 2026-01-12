import 'package:e_chat_app/features/login/logic/login_phone_step/login_phone_step_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPhoneStepCubit extends Cubit<LoginPhoneStepState> {
  LoginPhoneStepCubit() : super(LoginPhoneStepState.initialState());

   void onSubmitPhoneNumber(String phoneNumber){
     emit(state.copyWith(phoneNumber: phoneNumber));
   }

   void onSubmitFormatedPhoneNumber(String formatedPhoneNumber){
     emit(state.copyWith(formatedPhoneNumber: formatedPhoneNumber));
   }

   void onUpdatePhoneNumberValidation(bool isValid){
     emit(state.copyWith(isPhoneNumberValid: isValid));
   }

}
