import 'package:e_chat_app/core/local/country_code_local_source/domain/entities/country_code.dart';

enum CountryStatus { initial, loading, success, error }

class CountryCodeState {
  final CountryCode? countryCode;
  final List<CountryCode>? countries;
  final String? error;
  final CountryStatus status;

  const CountryCodeState({
    required this.countryCode,
    required this.countries,
    required this.status,
    required this.error,
  });

  //init class no state are done
  CountryCodeState.initialState()
      : countryCode = null,
        countries = null,
        status = CountryStatus.initial,
        error = null;

  CountryCodeState copyWith(
      {CountryCode? countryCode,
      List<CountryCode>? countries,
      String? error,
      required CountryStatus status}) {
    return CountryCodeState(
        countries: countries ?? this.countries,
        countryCode: countryCode ?? this.countryCode,
        error: error,
        status: status);
  }
}
