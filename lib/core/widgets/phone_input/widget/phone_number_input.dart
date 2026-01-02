import 'package:e_chat_app/core/local/country_code_local_source/domain/entities/country_code.dart';
import 'package:e_chat_app/core/widgets/phone_input/widget/text_field_dial_code.dart';
import 'package:e_chat_app/core/widgets/phone_input/widget/text_field_phone.dart';
import 'package:flutter/material.dart';

/// {@template PhoneNumberInput}
/// typing behavior :
///   In CountryCode Text etc (+971):
///  - should not show the prefix + (when it Empty, When it CountryCode Applyed) otherwise show prefix
///  - if C
///should type the code number in TextFeildCode and then
///  - change the country flag
///  - Show enable Text with the countryName
///  - format the TextFeildCode Text with like (+971)
///  - jump to the TextFeildPhone
///  {@endtemplate}
///
class PhoneNumberInput extends StatefulWidget {
  final String dialCode;
  final String countryCode;
  final String countryName;
  final List<CountryCode>? countries;
  final void Function(String) onCountryDialCodeChange;
  final void Function(String) onCountryCodeChange;
  final void Function(String) onSubmitPhoneNumber;
  final void Function(bool) onPhoneNumberValidationChange;

  const PhoneNumberInput(
      {super.key,
      required this.dialCode,
      required this.countryCode,
      required this.countryName,
      required this.onCountryDialCodeChange,
      required this.onCountryCodeChange,
      required this.onSubmitPhoneNumber,
      required this.onPhoneNumberValidationChange,
      this.countries});

  @override
  State<PhoneNumberInput> createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  final TextEditingController _dialCodeController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final FocusNode _dialFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  bool _isDialCodeApply = false;

  @override
  void dispose() {
    _dialCodeController.dispose();
    _phoneNumberController.dispose();
    _dialFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<TextFieldPhoneState> phoneTextFieldKey = GlobalKey();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldDialCode(
          countryName: widget.countryName,
          dialCodeController: _dialCodeController,
          dialFocusNode: _dialFocusNode,
          dialCode: widget.dialCode,
          onApplyDialCodeDone: (isDone) {
            if (isDone) {
              phoneTextFieldKey.currentState?.clearPhoneNumber();
              setState(() {
                _isDialCodeApply = isDone;
              });

              WidgetsBinding.instance.addPostFrameCallback((_) {
                _phoneNumberFocusNode.requestFocus();
              });
            }
          },
          countryCode: widget.countryCode,
          onCountryCodeChange: widget.onCountryCodeChange,
          onCountryDialCodeChange: widget.onCountryDialCodeChange,
          countries: widget.countries,
        ),
        TextFieldPhone(
          key: phoneTextFieldKey,
          dialCode: widget.dialCode,
          countryCode: widget.countryCode,
          isDialCodeApply: _isDialCodeApply,
          onPhoneNumberRemoved: () {
            _dialFocusNode.requestFocus();
          },
          onPhoneNumberValidationChange: widget.onPhoneNumberValidationChange,
          onSubmitPhoneNumber: widget.onSubmitPhoneNumber,
          phoneNumberController: _phoneNumberController,
          phoneNumberFocusNode: _phoneNumberFocusNode,
        ),
      ],
    );
  }
}
