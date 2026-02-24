import 'package:e_chat_app/features/auth/domain/repo/auth_repository.dart';
import 'package:e_chat_app/features/onbording/domain/onboarding_repository.dart';
import 'package:e_chat_app/features/splash/logic/splash_done_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashDoneCubit extends Cubit<SplashDoneState> {
  final OnboardingRepository _onboardingRepository;
  final AuthRepository _authRepository;

  SplashDoneCubit(this._onboardingRepository, this._authRepository)
      : super(SplashDoneState.initialState());

  Future<void> decideStartupRoute() async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    final hasSeenOnboarding = await _onboardingRepository.hasSeenOnboarding();
    final isUserLogin = _authRepository.isSignedIn;

    if (isUserLogin) {
      emit(state.copyWith(navgiateTo: NavgiateTo.home));
    } else if (hasSeenOnboarding) {
      emit(state.copyWith(navgiateTo: NavgiateTo.auth));
    } else {
      emit(state.copyWith(navgiateTo: NavgiateTo.onboarding));
    }
  }
}
