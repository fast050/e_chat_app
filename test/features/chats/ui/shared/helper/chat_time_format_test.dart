import 'package:e_chat_app/features/chats/ui/shared/helper/chat_time_format.dart';
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

  test('formatMessageTime shows only the padded time, whatever the day', () {
    expect(formatMessageTime(DateTime(2026, 5, 1, 7, 5)), '07:05');
    expect(formatMessageTime(DateTime(2026, 9, 27, 22, 20)), '22:20');
  });

  group('formatDateSection', () {
    test('labels today and yesterday', () {
      expect(formatDateSection(DateTime(2026, 9, 27, 1), now: now), 'Today');
      expect(
        formatDateSection(DateTime(2026, 9, 26, 23), now: now),
        'Yesterday',
      );
    });

    test('labels earlier days of this month, last month and anything older',
        () {
      expect(formatDateSection(DateTime(2026, 9, 3), now: now), 'This Month');
      expect(formatDateSection(DateTime(2026, 8, 30), now: now), 'Last Month');
      expect(formatDateSection(DateTime(2026, 7, 31), now: now), 'Older');
      expect(formatDateSection(DateTime(2025, 9, 27), now: now), 'Older');
    });

    test('calls the last day of the previous month "Yesterday" on the 1st',
        () {
      expect(
        formatDateSection(DateTime(2026, 8, 31), now: DateTime(2026, 9, 1)),
        'Yesterday',
      );
    });

    test('finds last month across the new year', () {
      expect(
        formatDateSection(DateTime(2025, 12, 5), now: DateTime(2026, 1, 20)),
        'Last Month',
      );
    });
  });
}
