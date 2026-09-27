import 'package:e_chat_app/core/helper/api_logger.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('maskEmail', () {
    test('keeps first character and domain', () {
      expect(maskEmail('khalid@example.com'), 'k***@example.com');
    });

    test('masks fully when local part is a single character', () {
      expect(maskEmail('a@b.com'), '*******');
    });
  });

  group('maskPhone', () {
    test('keeps only the last 4 digits', () {
      expect(maskPhone('+971509433350'), '*********3350');
    });

    test('masks fully when 4 characters or fewer', () {
      expect(maskPhone('1234'), '****');
    });
  });
}
