import 'package:e_chat_app/features/chats/ui/chats_list/widgets/chat_list_tile.dart';
import 'package:e_chat_app/features/chats/ui/chats_list/widgets/unread_badge.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('shows name, last message, time and unread badge',
      (tester) async {
    await tester.pumpApp(const ChatListTile(
      name: 'David Wayne',
      lastMessage: 'Thanks a bunch!',
      timeLabel: '10:25',
      unreadCount: 5,
    ));

    expect(find.text('David Wayne'), findsOneWidget);
    expect(find.text('Thanks a bunch!'), findsOneWidget);
    expect(find.text('10:25'), findsOneWidget);
    expect(find.byType(UnreadBadge), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
  });

  testWidgets('hides unread badge when count is 0', (tester) async {
    await tester.pumpApp(const ChatListTile(
      name: 'Jean Dare',
      lastMessage: 'Hooray!',
      timeLabel: '20:10  05/05',
      unreadCount: 0,
    ));

    expect(find.byType(UnreadBadge), findsNothing);
  });

  testWidgets('shows initials when there is no avatar url', (tester) async {
    await tester.pumpApp(const ChatListTile(
      name: 'Jean Dare',
      lastMessage: 'Hooray!',
      timeLabel: '20:10',
      unreadCount: 0,
    ));

    expect(find.text('JD'), findsOneWidget);
  });
}
