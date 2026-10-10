import 'package:e_chat_app/features/chats/domain/entities/chat_settings.dart';
import 'package:e_chat_app/features/chats/ui/protected_chat/protected_chat_screen.dart';
import 'package:e_chat_app/features/chats/ui/shared/helper/conversation_args.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_settings_cubit.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/settings_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  setUpAll(() => registerFallbackValue(const ChatSettings(chatId: '')));

  testWidgets('shows the four security switches and saves a change',
      (tester) async {
    final repo = MockChatSettingsRepository();
    when(() => repo.fetchSettings('1'))
        .thenAnswer((_) async => const ChatSettings(chatId: '1'));
    when(() => repo.saveSettings(any())).thenAnswer((_) async {});

    final cubit = ChatSettingsCubit(repo);
    addTearDown(cubit.close);
    cubit.load('1');

    await tester.pumpApp(BlocProvider.value(
      value: cubit,
      child: const ProtectedChatScreen(
        args: ConversationArgs(chatId: '1', name: 'David Wayne'),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('David Wayne'), findsOneWidget);
    expect(find.text('Protected Chat'), findsOneWidget);
    expect(find.text('PIN Security'), findsOneWidget);
    expect(find.text('Face Recognition'), findsOneWidget);
    expect(find.text('Fingerprint Security'), findsOneWidget);

    await tester.tap(find.byType(SettingsSwitch).first);
    await tester.pumpAndSettle();

    final savedSettings =
        verify(() => repo.saveSettings(captureAny())).captured.single
            as ChatSettings;
    expect(savedSettings.isProtected, isTrue);
    expect(savedSettings.isPinEnabled, isFalse);
    expect(
      tester.widget<SettingsSwitch>(find.byType(SettingsSwitch).first).value,
      isTrue,
    );
  });
}
