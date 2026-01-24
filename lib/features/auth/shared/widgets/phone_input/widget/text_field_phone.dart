import 'package:e_chat_app/features/auth/shared/widgets/phone_input/logic/share_function.dart';
import 'package:e_chat_app/features/auth/shared/widgets/phone_input/widget/phone_number_base_text_field.dart';
import 'package:e_chat_app/features/auth/shared/widgets/phone_input/widget/phone_number_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart'
    show PhoneNumber, PhoneNumberType;

class TextFieldPhone extends StatefulWidget {
  final FocusNode _phoneNumberFocusNode;
  final TextEditingController _phoneNumberController;
  final String dialCode;
  final String countryCode;
  final bool isDialCodeApply;
  final void Function(bool) onPhoneNumberValidationChange;
  final void Function() onPhoneNumberRemoved;
  final void Function(String) onSubmitPhoneNumber;
  final void Function(String)? onSubmitFormatedPhoneNumber;

  const TextFieldPhone({
    super.key,
    required FocusNode phoneNumberFocusNode,
    required TextEditingController phoneNumberController,
    required this.dialCode,
    required this.countryCode,
    required this.onPhoneNumberValidationChange,
    required this.isDialCodeApply,
    required this.onPhoneNumberRemoved,
    required this.onSubmitPhoneNumber,
    this.onSubmitFormatedPhoneNumber,
  })  : _phoneNumberFocusNode = phoneNumberFocusNode,
        _phoneNumberController = phoneNumberController;

  @override
  State<TextFieldPhone> createState() => TextFieldPhoneState();
}

class TextFieldPhoneState extends State<TextFieldPhone> {
  static const _maxLenghtPhoneNumber = 15;
  static const _defalutHint = "00 0000 000";
  bool _isValidPhoneNumber = false;
  int maxPhoneLenght = _maxLenghtPhoneNumber;
  // at start will be 15 and then will change to limit as country
  bool get shouldUpdateMaxPhoneLenght =>
      _isValidPhoneNumber && widget.isDialCodeApply;

  /// {@template updateMaxPhoneNumberLenght}
  /// Parses a phone number given caller or destination information.
  /// - valid number for +971 509433350 so the length of the phoneNumber without dialCode(+971) is 9
  /// - so will set the max length to 9 for dial code (+971)
  /// {@endtemplate}
  void updateMaxPhoneNumberLenght(String phoneText) {
    if (shouldUpdateMaxPhoneLenght) {
      setState(() {
        maxPhoneLenght =
            getOnlyDigits(widget._phoneNumberController.text).length;
      });
    }
  }

  void updatePhoneNumberValidation(String phoneText) {
    _isValidPhoneNumber = isPhoneNumberValid(phoneText);
  }

  void resetMaxPhoneNumberLenght() {
    maxPhoneLenght = _maxLenghtPhoneNumber;
  }

  bool isPhoneNumberValid(String phoneText) {
    final frPhone =
        PhoneNumber.parse(widget.dialCode + getOnlyDigits(phoneText));
    return frPhone.isValidLength(type: PhoneNumberType.mobile);
  }

  void clearPhoneNumber() {
    widget._phoneNumberController.clear();
    widget.onPhoneNumberValidationChange(false);
    resetMaxPhoneNumberLenght();
    submitPhoneNumberValidation();
  }

  void submitPhoneNumberValidation() {
    widget.onPhoneNumberValidationChange(_isValidPhoneNumber);
  }

  String getFullPhoneNumber() {
    final dial = widget.dialCode;
    final phone = widget._phoneNumberController.text;
    return "$dial$phone";
  }

  String getFullFormatedPhoneNumber() {
    final dial = widget.dialCode;
    final phone = widget._phoneNumberController.text;
    return "($dial) $phone";
  }

  void handlePhoneChange(String value) {
    updatePhoneNumberValidation(value);
    updateMaxPhoneNumberLenght(value);
    if (value.isEmpty) widget.onPhoneNumberRemoved();
    if (_isValidPhoneNumber) widget.onSubmitPhoneNumber(getFullPhoneNumber());
    if (_isValidPhoneNumber && widget.onSubmitFormatedPhoneNumber != null) {
      widget.onSubmitFormatedPhoneNumber!(getFullFormatedPhoneNumber());
    }
    submitPhoneNumberValidation();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: PhoneNumberBaseTextField(
        focusNode: widget._phoneNumberFocusNode,
        // key: ValueKey(widget.countryName),
        controller: widget._phoneNumberController,
        hintText: _defalutHint,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(maxPhoneLenght),
          PhoneNumberFormatter(
              dialCode: widget.dialCode, code: widget.countryCode),
        ],
        onChange: handlePhoneChange,
      ),
    );
  }
}
