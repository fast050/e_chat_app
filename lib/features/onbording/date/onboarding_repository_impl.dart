import 'package:e_chat_app/core/local/local_storage/local_store.dart';
import 'package:e_chat_app/features/onbording/domain/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  static const _keyHasSeenOnboarding = 'has_seen_onboarding';

  final LocalStore _localStore;

  OnboardingRepositoryImpl(this._localStore);

  @override
  Future<bool> hasSeenOnboarding() async {
    return _localStore.getBool(_keyHasSeenOnboarding) ?? false;
  }

  @override
  Future<bool> setHasSeenOnboarding() async {
    return await _localStore.setBool(_keyHasSeenOnboarding, true);
  }
}
