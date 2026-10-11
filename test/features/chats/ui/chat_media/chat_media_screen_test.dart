import 'package:e_chat_app/features/chats/domain/entities/document_attachment.dart';
import 'package:e_chat_app/features/chats/domain/entities/link_attachment.dart';
import 'package:e_chat_app/features/chats/ui/chat_media/chat_media_screen.dart';
import 'package:e_chat_app/features/chats/ui/shared/helper/conversation_args.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_media_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('switches between the tabs and marks a document as downloaded',
      (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final now = DateTime(2026, 9, 27, 18);
    final messages = MockMessagesRepository();
    final attachments = MockAttachmentsRepository();
    when(() => messages.fetchMessages('1')).thenAnswer((_) async => []);
    when(() => attachments.fetchLinks('1')).thenAnswer((_) async => [
          LinkAttachment(
            id: 'l1',
            chatId: '1',
            url: 'https://example.com/kit',
            title: 'Tab Bar Components',
            createdAt: DateTime(2026, 9, 26, 10),
          ),
        ]);
    when(() => attachments.fetchDocuments('1')).thenAnswer((_) async => [
          DocumentAttachment(
            id: 'd1',
            chatId: '1',
            name: 'War and Peace.pdf',
            sizeBytes: 24 * 1024 * 1024,
            createdAt: DateTime(2026, 9, 27, 10),
          ),
        ]);

    final cubit = ChatMediaCubit(messages, attachments, now: () => now);
    addTearDown(cubit.close);
    cubit.load('1');

    await tester.pumpApp(BlocProvider.value(
      value: cubit,
      child: const ChatMediaScreen(
        args: ConversationArgs(chatId: '1', name: 'David Wayne'),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('David Wayne'), findsOneWidget);
    expect(find.text('No media yet'), findsOneWidget);

    await tester.tap(find.text('Links'));
    await tester.pumpAndSettle();

    expect(find.text('Yesterday'), findsOneWidget);
    expect(find.text('Tab Bar Components'), findsOneWidget);
    expect(find.text('https://example.com/kit'), findsOneWidget);

    await tester.tap(find.text('Documents'));
    await tester.pumpAndSettle();

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('War and Peace'), findsOneWidget);
    expect(find.text('24 MB'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.file_download_outlined));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.file_download_outlined), findsNothing);
    expect(find.byIcon(Icons.check), findsOneWidget);
  });
}
