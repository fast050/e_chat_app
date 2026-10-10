import 'package:e_chat_app/features/chats/ui/shared/helper/file_format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formatFileSize picks the largest unit that fits', () {
    expect(formatFileSize(512), '512 B');
    expect(formatFileSize(2048), '2 KB');
    expect(formatFileSize(24 * 1024 * 1024), '24 MB');
    expect(formatFileSize(100 * 1024 * 1024 * 1024), '100 GB');
  });

  test('formatFileSize keeps one decimal unless it is zero', () {
    expect(formatFileSize(1536), '1.5 KB');
    expect(formatFileSize(1024 * 1024 * 1024 * 3 ~/ 2), '1.5 GB');
  });

  test('formatFileSize stays in GB above a terabyte', () {
    expect(formatFileSize(2048 * 1024 * 1024 * 1024), '2048 GB');
  });

  test('fileExtension returns the lowercase extension', () {
    expect(fileExtension('War and Peace.pdf'), 'pdf');
    expect(fileExtension('Design.System.CDR'), 'cdr');
  });

  test('fileExtension is empty without a real extension', () {
    expect(fileExtension('README'), '');
    expect(fileExtension('.env'), '');
    expect(fileExtension('notes.'), '');
  });

  test('fileNameWithoutExtension drops only the extension', () {
    expect(fileNameWithoutExtension('War and Peace.pdf'), 'War and Peace');
    expect(fileNameWithoutExtension('Design.System.cdr'), 'Design.System');
    expect(fileNameWithoutExtension('README'), 'README');
  });
}
