import 'package:e_chat_app/features/chats/ui/helper/chat_time_format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 9, 27, 18, 0);

  test('shows only the time for messages from today', () {
    expect(formatChatTime(DateTime(2026, 9, 27, 10, 25), now: now), '10:25');
  });

  test('shows time and day/month for older messages', () {
    expect(
      formatChatTime(DateTime(2026, 5, 9, 22, 20), now: now),
      '22:20  09/05',
    );
  });

  test('pads single digits', () {
    expect(
        formatChatTime(DateTime(2026, 5, 1, 7, 5), now: now), '07:05  01/05');
  });
}
