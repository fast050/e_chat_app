import 'package:flutter/services.dart';
/*
  this class to Make "00 0000 000" format when type in the TextField    
 */
class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r"\D"), '');
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      if ((i == 1 || i == 5) && i != digits.length - 1) buffer.write(" ");
    }

    final formatedText = buffer.toString();

    return TextEditingValue(
      text: formatedText,
      selection: TextSelection.collapsed(offset: formatedText.length),
    );
  }
}
