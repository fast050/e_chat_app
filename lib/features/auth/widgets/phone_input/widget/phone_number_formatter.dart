import 'package:flutter/services.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

/*
  this class to Make "00 0000 000" format when type in the TextField    
 */
class PhoneNumberFormatter extends TextInputFormatter {
  final String dialCode;
  final String code;

  const PhoneNumberFormatter({required this.dialCode, required this.code});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final phone = getOnlyNumber(newValue.text); 
    final buffer = StringBuffer();

    formatLogic(phone, buffer);

    final formatedText = buffer.toString();

    return TextEditingValue(
      text: formatedText,
      selection: TextSelection.collapsed(offset: formatedText.length),
    );
  }

  void formatLogic(String digits, StringBuffer buffer) {
    final format = getPhoneFormat(digits);

    for (int i = 0; i < digits.length; i++) {
      if (!isNumeric(format[i])) buffer.write(" ");
      buffer.write(digits[i]);
    }
  }

  String getPhoneFormat(String phone){
       final frPhone = PhoneNumber.parse(dialCode + phone,
        callerCountry: isoCodeConversionMap[code.toUpperCase()]);
     return frPhone.formatNsn(format: NsnFormat.international);
  }

  bool isNumeric(String str) {
    return double.tryParse(str) != null;
  }

  String getOnlyNumber(String value) => 
  value.replaceAll(RegExp(r"\D"), '');
}
