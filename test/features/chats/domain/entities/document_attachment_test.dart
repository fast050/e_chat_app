import 'package:e_chat_app/features/chats/domain/entities/document_attachment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromJson reads all fields', () {
    final document = DocumentAttachment.fromJson({
      'id': 'd1',
      'chat_id': 'c1',
      'name': 'War and Peace.pdf',
      'size_bytes': 2048,
      'created_at': '2026-09-27T10:10:00.000',
    });

    expect(document.id, 'd1');
    expect(document.chatId, 'c1');
    expect(document.name, 'War and Peace.pdf');
    expect(document.sizeBytes, 2048);
    expect(document.createdAt, DateTime(2026, 9, 27, 10, 10));
  });

  test('toJson leaves out the server-generated id and created_at', () {
    final document = DocumentAttachment(
      id: 'd1',
      chatId: 'c1',
      name: 'War and Peace.pdf',
      sizeBytes: 2048,
      createdAt: DateTime(2026, 9, 27, 10, 10),
    );

    expect(document.toJson(), {
      'chat_id': 'c1',
      'name': 'War and Peace.pdf',
      'size_bytes': 2048,
    });
  });
}
