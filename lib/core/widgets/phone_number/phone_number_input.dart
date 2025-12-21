import 'package:e_chat_app/core/widgets/phone_number/phone_number_formatter.dart';
import 'package:e_chat_app/core/widgets/phone_number/phone_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_flags_pro/country_flags_pro.dart';

/*
 typing behavior :
   - should show the prefix + before the number and when it empty hide the prefix

 should type the code number in TextFeildCode and then 
    - change the country flag  
    - Show enable Text with the countryName
    - format the TextFeildCode Text with like (+971)
    - jump to the TextFeildPhone 

*/

// to track user action to the feild is it edit or lock(value set from out side)
enum EditState { edit, lock }

class PhoneNumberInput extends StatefulWidget {
  final String dialCode;
  final String countryCode;
  final String countryName;
  final void Function(String) onCountryCodeChange;

  const PhoneNumberInput(
      {super.key,
      required this.dialCode,
      required this.countryCode,
      required this.countryName,
      required this.onCountryCodeChange});

  @override
  State<PhoneNumberInput> createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  final TextEditingController controller = TextEditingController();

  EditState editState = EditState.edit;
  bool get isStateEdit => editState == EditState.edit;
  bool get isStateEditLock => editState == EditState.lock;
  bool get shouldShowPrefix =>
      editState == EditState.edit && controller.text.isNotEmpty;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        applyDialCodeToField();
      }
    });
  }

  String getOnlyDigits(String value) => value.replaceAll(RegExp(r"\D"), "");

  void applyDialCodeToField() {
    if (widget.dialCode.isEmpty) return;
    setState(() {
      editState = EditState.lock;
    });
    controller.text = "(${widget.dialCode})";
    FocusScope.of(context).nextFocus();
  }

  void handleDialCodeChanges(String value) {
    // to fix behavior of the edit value was delete and then write the same value
    if (value == getOnlyDigits(widget.dialCode)) {
      applyDialCodeToField();
      return;
    }

    //to make the text only number
    controller.text = getOnlyDigits(controller.text);

    setState(() {
      editState = EditState.edit;
    });

    if (value.isNotEmpty) widget.onCountryCodeChange("+$value");
  }

  @override
  void didUpdateWidget(covariant PhoneNumberInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.countryCode != widget.countryCode) applyDialCodeToField();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: PhoneTextField(
            controller: controller,
            bottomText: widget.countryName,
            inputFormatters: isStateEditLock
                ? null
                : [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3)
                  ],
            prefixText: shouldShowPrefix 
            ? "+" 
            : null,
            prefixIcon: SizedBox(
              height: 34,
              width: 43,
              child: CountryFlagsPro.getFlag(
                widget.countryCode, // Country code
                width: double.infinity, // Flag width
                height: double.infinity, // Flag height
                fit: BoxFit.fill, // Flag fit
                borderRadius: BorderRadius.circular(6), //Flag border radius
              ),
            ),
            hintText: "(+971)",
            onChange: (value) {
              handleDialCodeChanges(value);
            },
          ),
        ),
        Expanded(
          flex: 4,
          child: PhoneTextField(
            hintText: "00 0000 000",
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(9),
              PhoneNumberFormatter()
            ],
            onChange: (value) {
              if (value.isEmpty) FocusScope.of(context).previousFocus();
            },
          ),
        ),
      ],
    );
  }
}
