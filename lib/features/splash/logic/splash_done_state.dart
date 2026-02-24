enum NavgiateTo { initial, onboarding, auth, home }

class SplashDoneState {
  final NavgiateTo navgiateTo;
  const SplashDoneState({required this.navgiateTo});

  SplashDoneState.initialState() : navgiateTo = NavgiateTo.initial;

  SplashDoneState copyWith({NavgiateTo? navgiateTo}) {
    return SplashDoneState(navgiateTo: navgiateTo ?? this.navgiateTo);
  }
}
