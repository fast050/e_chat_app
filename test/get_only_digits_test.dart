import 'package:flutter_test/flutter_test.dart';
import 'package:e_chat_app/features/auth/shared/widgets/phone_input/logic/share_function.dart';

void main() {
  test('getOnlyDigits strips non-digit characters', () {
    expect(getOnlyDigits('abc123def45'), '12345');
    expect(getOnlyDigits('+1 (234) 567-8900'), '12345678900');
    expect(getOnlyDigits('no digits'), '');
    expect(getOnlyDigits('098-765'), '098765');
  });
}
