import 'package:e_chat_app/features/chats/domain/entities/document_attachment.dart';
import 'package:e_chat_app/features/chats/domain/entities/link_attachment.dart';
import 'package:e_chat_app/features/chats/domain/repo/attachments_repository.dart';

// In-memory sample data until the Supabase attachments tables exist.
class AttachmentsRepositoryImpl implements AttachmentsRepository {
  @override
  Future<List<LinkAttachment>> fetchLinks(String chatId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final days = _SampleDays(DateTime.now());
    var count = 0;
    LinkAttachment link(DateTime day, String title, String url) =>
        LinkAttachment(
          id: '$chatId-link-${++count}',
          chatId: chatId,
          url: url,
          title: title,
          thumbnailUrl: 'https://picsum.photos/seed/link$count/200/200',
          createdAt: day,
        );

    return [
      link(
        days.today,
        '160+ FREE Tab Bar Component Types',
        'https://www.figma.com/community/file/1312925322144132345',
      ),
      link(
        days.today,
        'Speedy Chow | Food Delivery App UI Kit',
        'https://www.figma.com/community/file/1343987132290159832',
      ),
      link(
        days.yesterday,
        '150+ FREE Stepper / Wizard Components',
        'https://www.figma.com/community/file/1314040262635033322',
      ),
      link(
        days.yesterday,
        '100+ FREE Search Bar Component Types',
        'https://www.figma.com/community/file/1319871003126158300',
      ),
      link(
        days.yesterday,
        '80+ FREE Skeleton / Shimmer / Loading',
        'https://www.figma.com/community/file/1328394107720324722',
      ),
      link(
        days.lastMonth,
        'Fast VPN | VPN Mobile App UI Kit Design',
        'https://www.figma.com/community/file/1308874400725238178',
      ),
    ];
  }

  @override
  Future<List<DocumentAttachment>> fetchDocuments(String chatId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final days = _SampleDays(DateTime.now());
    var count = 0;
    DocumentAttachment document(DateTime day, String name, int sizeBytes) =>
        DocumentAttachment(
          id: '$chatId-doc-${++count}',
          chatId: chatId,
          name: name,
          sizeBytes: sizeBytes,
          createdAt: day,
        );

    return [
      document(days.today, 'Don Quixote.doc', 24 * _mb),
      document(days.today, 'Design System.cdr', _gb * 15 ~/ 10),
      document(days.today, 'The Lord of the Rings.pdf', _gb * 208 ~/ 10),
      document(days.today, 'War and Peace.pdf', _gb * 142 ~/ 10),
      document(days.yesterday, 'Engineer Character.psd', 100 * _gb),
      document(days.yesterday, 'Tank Character.psd', 120 * _gb),
      document(days.lastMonth, 'The Odyssey by Homer.zip', _gb * 221 ~/ 10),
    ];
  }
}

const _mb = 1024 * 1024;
const _gb = 1024 * _mb;

class _SampleDays {
  final DateTime today;
  final DateTime yesterday;
  final DateTime lastMonth;

  _SampleDays(DateTime now)
      : today = DateTime(now.year, now.month, now.day, 9),
        yesterday = DateTime(now.year, now.month, now.day - 1, 9),
        lastMonth = DateTime(now.year, now.month - 1, 5, 9);
}
