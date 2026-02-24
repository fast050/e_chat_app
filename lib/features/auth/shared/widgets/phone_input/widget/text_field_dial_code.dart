import 'package:country_flags_pro/country_flags_pro.dart';
import 'package:e_chat_app/core/local/country_code_local_source/domain/entities/country_code.dart';
import 'package:e_chat_app/features/auth/shared/widgets/phone_input/logic/share_function.dart';
import 'package:e_chat_app/features/auth/shared/widgets/phone_input/widget/country_picker.dart';
import 'package:e_chat_app/features/auth/shared/widgets/phone_input/widget/phone_number_base_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldDialCode extends StatefulWidget {
  final FocusNode _dialFocusNode;
  final TextEditingController _dialCodeController;
  final String countryName;
  final String dialCode;
  final String countryCode;
  final List<CountryCode>? countries;
  final void Function(String) onCountryDialCodeChange;
  final void Function(String) onCountryCodeChange;
  final void Function(bool) onApplyDialCodeDone;

  const TextFieldDialCode({
    super.key,
    required this.countryName,
    required FocusNode dialFocusNode,
    required TextEditingController dialCodeController,
    required this.dialCode,
    required this.countryCode,
    this.countries,
    required this.onCountryDialCodeChange,
    required this.onCountryCodeChange,
    required this.onApplyDialCodeDone,
  })  : _dialFocusNode = dialFocusNode,
        _dialCodeController = dialCodeController;

  @override
  State<TextFieldDialCode> createState() => _TextFieldDialCodeState();
}

class _TextFieldDialCodeState extends State<TextFieldDialCode> {
  String _previousDialText = "";
  bool get _isOrWillDeleteDialText =>
      _previousDialText.length >= widget._dialCodeController.text.length;
  bool _isDialCodeApply = false;
  bool get shouldDialCodeShowPrefix =>
      !(_isDialCodeApply || widget._dialCodeController.text.isEmpty);
  //is user try to type pass the dialCode for example (+971)1 will not allow it
  bool isEditTextPassTheLimitInDialText(String value) =>
      value.length > 4 && value[value.length - 2] == ")";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      applyDialCodeToField();
    });
  }

  @override
  void didUpdateWidget(covariant TextFieldDialCode oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.countryName != widget.countryName) applyDialCodeToField();
  }

  void handleDialCodeChanges(String value) {
    widget.onApplyDialCodeDone(false);
    //if text is (+971) will be 97
    if (_isDialCodeApply && _isOrWillDeleteDialText) {
      setState(() {
        widget._dialCodeController.text =
            getOnlyDigits(value.substring(0, value.length - 1));
        _isDialCodeApply = false;
      });
      return;
    }

    //if u enter the same Dial Code again
    if (getOnlyDigits(value) == getOnlyDigits(widget.dialCode) ||
        isEditTextPassTheLimitInDialText(value)) {
      applyDialCodeToField();
      return;
    }

    setState(() {
      _isDialCodeApply = false;
    });

    if (value.isNotEmpty) widget.onCountryDialCodeChange("+$value");

    _previousDialText = value;
  }

  void applyDialCodeToField() {
    setState(() {
      widget._dialCodeController.text = "(${widget.dialCode})";
      _isDialCodeApply = true;
      _previousDialText = widget._dialCodeController.text;
    });

    // Call the parent's callback after this frame to avoid nested setState during rebuilds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onApplyDialCodeDone(true);
    });
  }

  void showCountryPickerDialog() async {
    final result = await showDialog<CountryCode>(
      context: context,
      builder: (_) => CountryPickerDialog(countries: widget.countries ?? []),
    );

    if (result != null) {
      // if user picked the same country, apply the dial code (this sets state internally)
      if (result.name == widget.countryName) {
        applyDialCodeToField();
        return;
      }

      // for a different country, simply notify the parent; parent will update the widget
      // and the child will react in didUpdateWidget by applying the dial code.
      widget.onCountryCodeChange(result.code);
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Expanded(
      flex: 3,
      child: PhoneNumberBaseTextField(
        focusNode: widget._dialFocusNode,
        controller: widget._dialCodeController,
        bottomText: widget.countryName,
        inputFormatters: _isDialCodeApply
            ? null
            : [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3)
              ],
        prefixText: shouldDialCodeShowPrefix ? "+" : null,
        prefixIcon: InkWell(
          onTap: showCountryPickerDialog,
          child: SizedBox(
            height: 34,
            width: 65,
            child: Row(
              children: [
                Expanded(
                  child: CountryFlagsPro.getFlag(
                    widget.countryCode.toLowerCase(),
                    width: 43,
                    height: 34,
                    fit: BoxFit.fill,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                Icon(Icons.keyboard_arrow_down_outlined)
              ],
            ),
          ),
        ),
        hintText: "(+971)",
        onChange: handleDialCodeChanges,
      ),
    );
  }
}
