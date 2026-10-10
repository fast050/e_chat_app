import 'package:e_chat_app/features/chats/domain/entities/chat_settings.dart';
import 'package:e_chat_app/features/chats/domain/entities/document_attachment.dart';
import 'package:e_chat_app/features/chats/domain/entities/link_attachment.dart';
import 'package:e_chat_app/features/chats/ui/shared/helper/conversation_args.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_media_cubit.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_settings_cubit.dart';
import 'package:e_chat_app/features/chats/ui/shared/widgets/settings_switch.dart';
import 'package:e_chat_app/features/chats/ui/user_info/user_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  late MockChatSettingsRepository settingsRepo;
  late MockMessagesRepository messagesRepo;
  late MockAttachmentsRepository attachmentsRepo;
  final sharedAt = DateTime(2026, 9, 27, 10);

  setUpAll(() => registerFallbackValue(const ChatSettings(chatId: '')));

  setUp(() {
    settingsRepo = MockChatSettingsRepository();
    messagesRepo = MockMessagesRepository();
    attachmentsRepo = MockAttachmentsRepository();

    when(() => settingsRepo.fetchSettings('1'))
        .thenAnswer((_) async => const ChatSettings(chatId: '1'));
    when(() => settingsRepo.saveSettings(any())).thenAnswer((_) async {});
    when(() => messagesRepo.fetchMessages('1')).thenAnswer((_) async => []);
    when(() => attachmentsRepo.fetchLinks('1')).thenAnswer((_) async => [
          LinkAttachment(
            id: 'l1',
            chatId: '1',
            url: 'https://example.com/a',
            title: 'A',
            createdAt: sharedAt,
          ),
          LinkAttachment(
            id: 'l2',
            chatId: '1',
            url: 'https://example.com/b',
            title: 'B',
            createdAt: sharedAt,
          ),
        ]);
    when(() => attachmentsRepo.fetchDocuments('1')).thenAnswer((_) async => [
          DocumentAttachment(
            id: 'd1',
            chatId: '1',
            name: 'War and Peace.pdf',
            sizeBytes: 2048,
            createdAt: sharedAt,
          ),
        ]);
  });

  Future<void> pumpUserInfo(WidgetTester tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final settingsCubit = ChatSettingsCubit(settingsRepo);
    final mediaCubit = ChatMediaCubit(messagesRepo, attachmentsRepo);
    addTearDown(settingsCubit.close);
    addTearDown(mediaCubit.close);
    settingsCubit.load('1');
    mediaCubit.load('1');

    await tester.pumpApp(MultiBlocProvider(
      providers: [
        BlocProvider.value(value: settingsCubit),
        BlocProvider.value(value: mediaCubit),
      ],
      child: const UserInfoScreen(
        args: ConversationArgs(
          chatId: '1',
          name: 'David Wayne',
          phoneNumber: '+445092853022',
        ),
      ),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('shows the user, the shared item count and the settings rows',
      (tester) async {
    await pumpUserInfo(tester);

    expect(find.text('David Wayne'), findsOneWidget);
    expect(find.text('+445092853022'), findsOneWidget);
    expect(find.text('Media, Links & Documents'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('Mute Notification'), findsOneWidget);
    expect(find.text('Protected Chat'), findsOneWidget);
    expect(find.text('Hide Chat'), findsOneWidget);
    expect(find.text('Hide Chat History'), findsOneWidget);
    expect(find.text('Add To Group'), findsOneWidget);
    expect(find.text('Custom Color Chat'), findsOneWidget);
    expect(find.text('Custom Background Chat'), findsOneWidget);
  });

  testWidgets('saves the mute switch', (tester) async {
    await pumpUserInfo(tester);

    await tester.tap(find.byType(SettingsSwitch).first);
    await tester.pumpAndSettle();

    final saved = verify(() => settingsRepo.saveSettings(captureAny()))
        .captured
        .single as ChatSettings;
    expect(saved.isMuted, isTrue);
    expect(saved.isProtected, isFalse);
  });

  testWidgets('saves the color picked in the color sheet', (tester) async {
    await pumpUserInfo(tester);

    await tester.tap(find.text('Custom Color Chat'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(GestureDetector).last);
    await tester.pumpAndSettle();

    final saved = verify(() => settingsRepo.saveSettings(captureAny()))
        .captured
        .single as ChatSettings;
    expect(saved.bubbleColor, isNotNull);
  });

  testWidgets('copies the phone number', (tester) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String?;
        }
        return null;
      },
    );
    addTearDown(() => tester.binding.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null));

    await pumpUserInfo(tester);
    await tester.tap(find.byIcon(Icons.copy_outlined));
    await tester.pump();

    expect(copied, '+445092853022');
    expect(find.text('Phone number copied'), findsOneWidget);
  });
}
