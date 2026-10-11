import 'package:bloc_test/bloc_test.dart';
import 'package:e_chat_app/features/chats/domain/entities/document_attachment.dart';
import 'package:e_chat_app/features/chats/domain/entities/link_attachment.dart';
import 'package:e_chat_app/features/chats/domain/entities/message.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_media_cubit.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_media_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../helpers/mock_repositories.dart';

void main() {
  late MockMessagesRepository messages;
  late MockAttachmentsRepository attachments;
  final now = DateTime(2026, 9, 27, 18, 0);
  final today = DateTime(2026, 9, 27, 10);
  final yesterday = DateTime(2026, 9, 26, 10);
  final lastMonth = DateTime(2026, 8, 5, 10);

  setUp(() {
    messages = MockMessagesRepository();
    attachments = MockAttachmentsRepository();
  });

  ChatMediaCubit buildCubit() =>
      ChatMediaCubit(messages, attachments, now: () => now);

  Message message(String id, DateTime at, {String? imageUrl}) => Message(
        id: id,
        chatId: 'c1',
        senderId: 'david',
        text: imageUrl == null ? 'Hello!' : '',
        createdAt: at,
        imageUrl: imageUrl,
      );

  LinkAttachment link(String id, DateTime at) => LinkAttachment(
        id: id,
        chatId: 'c1',
        url: 'https://example.com/$id',
        title: 'Link $id',
        createdAt: at,
      );

  DocumentAttachment document(String id, String name, int size, DateTime at) =>
      DocumentAttachment(
        id: id,
        chatId: 'c1',
        name: name,
        sizeBytes: size,
        createdAt: at,
      );

  void stubAll() {
    when(() => messages.fetchMessages('c1')).thenAnswer((_) async => [
          message('m1', lastMonth, imageUrl: 'https://example.com/1.png'),
          message('m2', today),
          message('m3', today, imageUrl: 'https://example.com/3.png'),
          message('m4', yesterday, imageUrl: 'https://example.com/4.png'),
          message(
            'm5',
            today.add(const Duration(hours: 1)),
            imageUrl: 'https://example.com/5.png',
          ),
        ]);
    when(() => attachments.fetchLinks('c1')).thenAnswer((_) async => [
          link('l1', yesterday),
          link('l2', today),
        ]);
    when(() => attachments.fetchDocuments('c1')).thenAnswer((_) async => [
          document('d1', 'War and Peace.pdf', 24 * 1024 * 1024, today),
          document('d2', 'README', 512, lastMonth),
        ]);
  }

  group('load', () {
    blocTest<ChatMediaCubit, ChatMediaState>(
      'keeps only image messages as media, newest first under date headings',
      build: () {
        stubAll();
        return buildCubit();
      },
      act: (cubit) => cubit.load('c1'),
      expect: () => [
        isA<ChatMediaState>()
            .having((s) => s.status, 'status', ChatMediaStatus.success)
            .having(
              (s) => s.media.map((section) => section.label).toList(),
              'media headings',
              ['Today', 'Yesterday', 'Last Month'],
            )
            .having(
              (s) => s.media.first.items.map((item) => item.id).toList(),
              "today's media",
              ['m5', 'm3'],
            )
            .having(
              (s) => s.media.first.items.first.imageUrl,
              'image url',
              'https://example.com/5.png',
            ),
      ],
    );

    blocTest<ChatMediaCubit, ChatMediaState>(
      'groups links and documents and formats the document labels',
      build: () {
        stubAll();
        return buildCubit();
      },
      act: (cubit) => cubit.load('c1'),
      expect: () => [
        isA<ChatMediaState>()
            .having(
              (s) => s.links.map((section) => section.label).toList(),
              'link headings',
              ['Today', 'Yesterday'],
            )
            .having((s) => s.links.first.items.single.id, 'first link', 'l2')
            .having(
              (s) => s.documents.map((section) => section.label).toList(),
              'document headings',
              ['Today', 'Last Month'],
            )
            .having(
              (s) => s.documents.first.items.single.name,
              'name',
              'War and Peace',
            )
            .having(
              (s) => s.documents.first.items.single.extension,
              'extension',
              'pdf',
            )
            .having(
              (s) => s.documents.first.items.single.sizeLabel,
              'size',
              '24 MB',
            )
            .having(
              (s) => s.documents.last.items.single.extension,
              'no extension',
              '',
            )
            .having((s) => s.totalCount, 'totalCount', 8),
      ],
    );

    blocTest<ChatMediaCubit, ChatMediaState>(
      'emits the Supabase message on PostgrestException',
      build: () {
        when(() => messages.fetchMessages('c1')).thenThrow(
            const PostgrestException(message: 'permission denied'));
        return buildCubit();
      },
      act: (cubit) => cubit.load('c1'),
      expect: () => [
        isA<ChatMediaState>()
            .having((s) => s.status, 'status', ChatMediaStatus.failure)
            .having((s) => s.error?.message, 'error', 'permission denied'),
      ],
    );

    blocTest<ChatMediaCubit, ChatMediaState>(
      'emits a safe generic message when the attachments fail',
      build: () {
        when(() => messages.fetchMessages('c1')).thenAnswer((_) async => []);
        when(() => attachments.fetchLinks('c1'))
            .thenThrow(Exception('socket closed'));
        return buildCubit();
      },
      act: (cubit) => cubit.load('c1'),
      expect: () => [
        isA<ChatMediaState>()
            .having((s) => s.status, 'status', ChatMediaStatus.failure)
            .having(
              (s) => s.error?.message,
              'error',
              'Something went wrong. Please try again.',
            ),
      ],
    );
  });

  blocTest<ChatMediaCubit, ChatMediaState>(
    'markDownloaded remembers every downloaded document',
    build: buildCubit,
    act: (cubit) => cubit
      ..markDownloaded('d1')
      ..markDownloaded('d2'),
    expect: () => [
      isA<ChatMediaState>()
          .having((s) => s.downloadedIds, 'downloadedIds', {'d1'}),
      isA<ChatMediaState>()
          .having((s) => s.downloadedIds, 'downloadedIds', {'d1', 'd2'}),
    ],
  );
}
