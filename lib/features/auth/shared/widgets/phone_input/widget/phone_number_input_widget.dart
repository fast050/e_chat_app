
import 'package:e_chat_app/features/auth/shared/widgets/phone_input/logic/country_code_cubit.dart';
import 'package:e_chat_app/features/auth/shared/widgets/phone_input/logic/country_code_state.dart';
import 'package:e_chat_app/features/auth/shared/widgets/phone_input/widget/phone_number_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// {@template PhoneNumberInputWidget}
///
///  Overview:
/// - Currently it use the Cubit with CountryCode Model to Provide Country Code data
///   via countries.json in this project
///
///  Usage (IMPORTANT):
/// - It need to add Bloc Provider at top level of the tree widgets in order to work
///
///
///  {@endtemplate}

class PhoneNumberInputWidget extends StatelessWidget {
  const PhoneNumberInputWidget({
    super.key,
    required this.onSubmitPhoneNumber,
    required this.onPhoneNumberValidationChange,
    this.onSubmitFormatedPhoneNumber,
  });

  final void Function(String) onSubmitPhoneNumber;
  final void Function(String)? onSubmitFormatedPhoneNumber;
  final void Function(bool) onPhoneNumberValidationChange;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountryCodeCubit, CountryCodeState>(builder: (_, state) {
      if (state.status == CountryStatus.loading) {
        return const CircularProgressIndicator();
      }

      if (state.status == CountryStatus.error) {
        return RefreshIndicator(
            child: Text("Retry"),
            onRefresh: () async {
              context
                  .read<CountryCodeCubit>()
                  .getCountryByDialCode(state.countryCode!.dialCode);
            });
      }

      return PhoneNumberInput(
        countryCode: state.countryCode!.code.toLowerCase(),
        dialCode: state.countryCode!.dialCode,
        countryName: state.countryCode!.name,
        countries: state.countries,
        onCountryCodeChange: (code) {
          context.read<CountryCodeCubit>().getCountryByCode(code);
        },
        onCountryDialCodeChange: (dialCode) {
          context.read<CountryCodeCubit>().getCountryByDialCode(dialCode);
        },
        onSubmitPhoneNumber: onSubmitPhoneNumber,
        onPhoneNumberValidationChange: onPhoneNumberValidationChange,
        onSubmitFormatedPhoneNumber: onSubmitFormatedPhoneNumber,
      );
    });
  }
}
