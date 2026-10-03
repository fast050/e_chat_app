import 'package:e_chat_app/features/chats/ui/chats_list/widgets/chats_add_menu.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('calls the matching callback for each item', (tester) async {
    var addFriendTaps = 0;
    var createGroupTaps = 0;

    await tester.pumpApp(ChatsAddMenu(
      onAddFriend: () => addFriendTaps++,
      onCreateGroup: () => createGroupTaps++,
    ));

    await tester.tap(find.text('Add Friend'));
    await tester.tap(find.text('Create Group'));

    expect(addFriendTaps, 1);
    expect(createGroupTaps, 1);
  });
}
