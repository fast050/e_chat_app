/// "10:25" — the time shown inside a message bubble.
String formatMessageTime(DateTime at) =>
    '${_twoDigits(at.hour)}:${_twoDigits(at.minute)}';

/// "10:25" for today, "22:20  09/05" (two spaces) for any other day.
String formatChatTime(DateTime at, {required DateTime now}) {
  final time = formatMessageTime(at);
  if (_isSameDay(at, now)) return time;
  return '$time  ${_twoDigits(at.day)}/${_twoDigits(at.month)}';
}

/// Heading for date-grouped lists (media, links, documents).
String formatDateSection(DateTime at, {required DateTime now}) {
  if (_isSameDay(at, now)) return 'Today';
  // Checked before the month so the 1st still calls the 31st "Yesterday".
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  if (_isSameDay(at, yesterday)) return 'Yesterday';
  if (at.year == now.year && at.month == now.month) return 'This Month';
  final lastMonth = DateTime(now.year, now.month - 1);
  if (at.year == lastMonth.year && at.month == lastMonth.month) {
    return 'Last Month';
  }
  return 'Older';
}

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String _twoDigits(int value) => value.toString().padLeft(2, '0');
