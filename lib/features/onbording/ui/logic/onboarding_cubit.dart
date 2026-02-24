import 'package:e_chat_app/features/onbording/domain/onboarding_repository.dart';
import 'package:e_chat_app/features/onbording/ui/logic/onboarding_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final OnboardingRepository _repo;

  OnboardingCubit(this._repo) : super(const OnboardingState.initialState());

  Future<void> setHasSeenOnboarding() async {

    final isSeen = await _repo.setHasSeenOnboarding();

    if(isSeen){
      emit(state.copyWith(
        hasSeen: true,
        status: OnboardingStatus.success
      ));
    }else{
     emit(state.copyWith(
        hasSeen: false,
        status: OnboardingStatus.error
      ));
    }
  
  }
}
