import 'package:e_chat_app/features/chats/domain/entities/chat.dart';
import 'package:e_chat_app/features/chats/domain/repo/chats_repository.dart';

// In-memory sample data until the Supabase chats tables exist.
class ChatsRepositoryImpl implements ChatsRepository {
  @override
  Future<List<Chat>> fetchChats() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final now = DateTime.now();
    DateTime daysAgo(int days, int hour, int minute) =>
        DateTime(now.year, now.month, now.day - days, hour, minute);

    return [
      Chat(
        id: '1',
        name: 'David Wayne',
        avatarUrl: 'https://i.pravatar.cc/150?img=12',
        phoneNumber: '+445092853022',
        lastMessage: 'Thanks a bunch! Have a great day! 😊',
        lastMessageAt: daysAgo(0, 10, 25),
        unreadCount: 5,
      ),
      Chat(
        id: '2',
        name: 'Edward Davidson',
        avatarUrl: 'https://i.pravatar.cc/150?img=13',
        phoneNumber: '+445092851177',
        lastMessage: 'Great, thanks so much! 💫',
        lastMessageAt: daysAgo(1, 22, 20),
        unreadCount: 12,
      ),
      Chat(
        id: '3',
        name: 'Angela Kelly',
        avatarUrl: 'https://i.pravatar.cc/150?img=5',
        phoneNumber: '+445092854410',
        lastMessage: 'Appreciate it! See you soon! 🚀',
        lastMessageAt: daysAgo(2, 10, 45),
        unreadCount: 1,
      ),
      Chat(
        id: '4',
        name: 'Jean Dare',
        avatarUrl: 'https://i.pravatar.cc/150?img=9',
        phoneNumber: '+445092856093',
        lastMessage: 'Hooray! 🎉',
        lastMessageAt: daysAgo(5, 20, 10),
      ),
      Chat(
        id: '5',
        name: 'Dennis Borer',
        avatarUrl: 'https://i.pravatar.cc/150?img=15',
        phoneNumber: '+445092858256',
        lastMessage: 'Your order has been successfully delivered',
        lastMessageAt: daysAgo(5, 17, 2),
      ),
      Chat(
        id: '6',
        name: 'Cayla Rath',
        avatarUrl: 'https://i.pravatar.cc/150?img=20',
        phoneNumber: '+445092852731',
        lastMessage: 'See you soon!',
        lastMessageAt: daysAgo(5, 11, 20),
      ),
      Chat(
        id: '7',
        name: 'Erin Turcotte',
        avatarUrl: 'https://i.pravatar.cc/150?img=25',
        phoneNumber: '+445092859904',
        lastMessage: "I'm ready to drop off your delivery. 👍",
        lastMessageAt: daysAgo(8, 19, 35),
      ),
      Chat(
        id: '8',
        name: 'Rodolfo Walter',
        avatarUrl: 'https://i.pravatar.cc/150?img=33',
        phoneNumber: '+445092857348',
        lastMessage: 'Appreciate it! Hope you enjoy it!',
        lastMessageAt: daysAgo(9, 7, 55),
      ),
    ];
  }
}
