import 'package:e_chat_app/features/chats/domain/entities/message.dart';
import 'package:e_chat_app/features/chats/ui/conversation/conversation_screen.dart';
import 'package:e_chat_app/features/chats/ui/conversation/logic/conversation_cubit.dart';
import 'package:e_chat_app/features/chats/ui/conversation/widgets/message_bubble.dart';
import 'package:e_chat_app/features/chats/ui/shared/helper/conversation_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('shows the other user and the messages, and sends a new one',
      (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final repo = MockMessagesRepository();
    when(() => repo.currentUserId).thenReturn('me');
    when(() => repo.fetchMessages('1')).thenAnswer((_) async => [
          Message(
            id: 'm1',
            chatId: '1',
            senderId: '1',
            text: "I'll text you when I arrive.",
            createdAt: DateTime(2026, 9, 27, 10, 11),
          ),
        ]);
    when(() => repo.sendMessage(chatId: '1', text: 'Great!'))
        .thenAnswer((_) async => Message(
              id: 'm2',
              chatId: '1',
              senderId: 'me',
              text: 'Great!',
              createdAt: DateTime(2026, 9, 27, 10, 12),
            ));

    final cubit = ConversationCubit(repo);
    addTearDown(cubit.close);
    cubit.loadMessages('1');

    await tester.pumpApp(BlocProvider.value(
      value: cubit,
      child: const ConversationScreen(
        args: ConversationArgs(
          chatId: '1',
          name: 'David Wayne',
          phoneNumber: '+445092853022',
        ),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Message'), findsOneWidget);
    expect(find.text('David Wayne'), findsOneWidget);
    expect(find.text('+445092853022'), findsOneWidget);
    expect(find.text("I'll text you when I arrive."), findsOneWidget);
    expect(find.byType(MessageBubble), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Great!');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    verify(() => repo.sendMessage(chatId: '1', text: 'Great!')).called(1);
    expect(find.byType(MessageBubble), findsNWidgets(2));
    expect(
      find.descendant(
        of: find.byType(MessageBubble),
        matching: find.text('Great!'),
      ),
      findsOneWidget,
    );
  });
}
