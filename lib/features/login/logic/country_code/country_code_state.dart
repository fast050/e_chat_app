import 'package:e_chat_app/core/local/country_code_local_source/domain/entities/country_code.dart';

enum CountryStatus{ initial, loading, success , error}


class CountryCodeState {
  final CountryCode? countryCode;
  final String? error;
  final CountryStatus status;

  const CountryCodeState(
      {required this.countryCode,
       required this.status,
       required this.error});

  //init class no state are done
  CountryCodeState.initialState()
      : countryCode = null,
        status = CountryStatus.initial,
        error = null;

  CountryCodeState copyWith(
      {CountryCode? countryCode, String? error, required CountryStatus status}) {
    return CountryCodeState(
      countryCode: countryCode ?? this.countryCode,
      error: error,
      status: status
    );
  }

}
