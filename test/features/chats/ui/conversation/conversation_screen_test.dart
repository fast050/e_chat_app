import 'package:e_chat_app/core/routing/routes.dart';
import 'package:e_chat_app/features/chats/domain/entities/chat_settings.dart';
import 'package:e_chat_app/features/chats/domain/entities/message.dart';
import 'package:e_chat_app/features/chats/ui/conversation/conversation_screen.dart';
import 'package:e_chat_app/features/chats/ui/conversation/logic/conversation_cubit.dart';
import 'package:e_chat_app/features/chats/ui/conversation/widgets/message_bubble.dart';
import 'package:e_chat_app/features/chats/ui/shared/helper/conversation_args.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  late MockMessagesRepository messagesRepo;
  late MockChatSettingsRepository settingsRepo;

  const args = ConversationArgs(
    chatId: '1',
    name: 'David Wayne',
    phoneNumber: '+445092853022',
  );

  setUp(() {
    messagesRepo = MockMessagesRepository();
    settingsRepo = MockChatSettingsRepository();
    when(() => messagesRepo.currentUserId).thenReturn('me');
  });

  Future<void> pumpConversation(
    WidgetTester tester, {
    RouteFactory? onGenerateRoute,
  }) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final conversationCubit = ConversationCubit(messagesRepo);
    final settingsCubit = ChatSettingsCubit(settingsRepo);
    addTearDown(conversationCubit.close);
    addTearDown(settingsCubit.close);
    conversationCubit.loadMessages('1');
    settingsCubit.load('1');

    await tester.pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: conversationCubit),
          BlocProvider.value(value: settingsCubit),
        ],
        child: const ConversationScreen(args: args),
      ),
      onGenerateRoute: onGenerateRoute,
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the other user and the messages, and sends a new one',
      (tester) async {
    when(() => settingsRepo.fetchSettings('1'))
        .thenAnswer((_) async => const ChatSettings(chatId: '1'));
    when(() => messagesRepo.fetchMessages('1')).thenAnswer((_) async => [
          Message(
            id: 'm1',
            chatId: '1',
            senderId: '1',
            text: "I'll text you when I arrive.",
            createdAt: DateTime(2026, 9, 27, 10, 11),
          ),
        ]);
    when(() => messagesRepo.sendMessage(chatId: '1', text: 'Great!'))
        .thenAnswer((_) async => Message(
              id: 'm2',
              chatId: '1',
              senderId: 'me',
              text: 'Great!',
              createdAt: DateTime(2026, 9, 27, 10, 12),
            ));

    await pumpConversation(tester);

    expect(find.text('Message'), findsOneWidget);
    expect(find.text('David Wayne'), findsOneWidget);
    expect(find.text('+445092853022'), findsOneWidget);
    expect(find.text("I'll text you when I arrive."), findsOneWidget);
    expect(find.byType(MessageBubble), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Great!');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    verify(() => messagesRepo.sendMessage(chatId: '1', text: 'Great!'))
        .called(1);
    expect(find.byType(MessageBubble), findsNWidgets(2));
    expect(
      find.descendant(
        of: find.byType(MessageBubble),
        matching: find.text('Great!'),
      ),
      findsOneWidget,
    );
  });

  testWidgets(
      'opens the user information and applies the chat color chosen there',
      (tester) async {
    var settingsFetches = 0;
    when(() => settingsRepo.fetchSettings('1')).thenAnswer((_) async {
      // The second fetch is the reload after the user information closes.
      if (++settingsFetches == 1) return const ChatSettings(chatId: '1');
      return const ChatSettings(chatId: '1', bubbleColor: 0xFF9655FF);
    });
    when(() => messagesRepo.fetchMessages('1')).thenAnswer((_) async => [
          Message(
            id: 'm1',
            chatId: '1',
            senderId: 'me',
            text: 'Hi!',
            createdAt: DateTime(2026, 9, 27, 10, 10),
          ),
          Message(
            id: 'm2',
            chatId: '1',
            senderId: '1',
            text: 'Hello!',
            createdAt: DateTime(2026, 9, 27, 10, 11),
          ),
        ]);

    Object? pushedArguments;
    await pumpConversation(
      tester,
      onGenerateRoute: (settings) {
        if (settings.name != Routes.userInfo) return null;
        pushedArguments = settings.arguments;
        return MaterialPageRoute<void>(
          builder: (_) => const Text('user information'),
        );
      },
    );

    MessageBubble bubble(String text) => tester.widget<MessageBubble>(
          find.ancestor(
            of: find.text(text),
            matching: find.byType(MessageBubble),
          ),
        );

    expect(bubble('Hi!').bubbleColor, isNull);

    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();

    expect(find.text('user information'), findsOneWidget);
    expect(pushedArguments, same(args));

    Navigator.of(tester.element(find.text('user information'))).pop();
    await tester.pumpAndSettle();

    expect(settingsFetches, 2);
    expect(bubble('Hi!').bubbleColor, const Color(0xFF9655FF));
    expect(bubble('Hello!').bubbleColor, isNull);
  });
}
