import 'package:bloc_test/bloc_test.dart';
import 'package:e_chat_app/features/auth/domain/repo/auth_repository.dart';
import 'package:e_chat_app/features/auth/shared/logic/auth_email_step/auth_email_cubit.dart';
import 'package:e_chat_app/features/auth/shared/logic/auth_email_step/auth_email_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repo;

  setUp(() => repo = MockAuthRepository());

  blocTest<AuthEmailCubit, AuthEmailState>(
    'loginWithEmailMigicLink emits linkSent on success',
    build: () {
      when(() => repo.emailMagicLink(any())).thenAnswer((_) async {});
      return AuthEmailCubit(repo);
    },
    act: (cubit) => cubit.loginWithEmailMigicLink('user@example.com'),
    expect: () => [
      isA<AuthEmailState>().having((s) => s.isSubmitting, 'isSubmitting', true),
      isA<AuthEmailState>()
          .having((s) => s.isSubmitting, 'isSubmitting', false)
          .having((s) => s.linkSent, 'linkSent', true),
    ],
    verify: (_) {
      verify(() => repo.emailMagicLink('user@example.com')).called(1);
    },
  );

  blocTest<AuthEmailCubit, AuthEmailState>(
    'loginWithEmailMigicLink emits the Supabase message on AuthException',
    build: () {
      when(() => repo.emailMagicLink(any()))
          .thenThrow(AuthException('For security purposes, please retry later.'));
      return AuthEmailCubit(repo);
    },
    act: (cubit) => cubit.loginWithEmailMigicLink('user@example.com'),
    expect: () => [
      isA<AuthEmailState>().having((s) => s.isSubmitting, 'isSubmitting', true),
      isA<AuthEmailState>().having(
        (s) => s.error?.message,
        'error.message',
        'For security purposes, please retry later.',
      ),
    ],
  );

  blocTest<AuthEmailCubit, AuthEmailState>(
    'loginWithEmailMigicLink emits a safe generic message on unknown errors',
    build: () {
      when(() => repo.emailMagicLink(any())).thenThrow(Exception('socket closed'));
      return AuthEmailCubit(repo);
    },
    act: (cubit) => cubit.loginWithEmailMigicLink('user@example.com'),
    expect: () => [
      isA<AuthEmailState>().having((s) => s.isSubmitting, 'isSubmitting', true),
      isA<AuthEmailState>().having(
        (s) => s.error?.message,
        'error.message',
        'Something went wrong. Please try again.',
      ),
    ],
  );
}
