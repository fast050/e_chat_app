import 'package:e_chat_app/core/local/country_code_local_source/domain/repo/countries_code_repository.dart';
import 'package:e_chat_app/features/login/logic/country_code/country_code_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountryCodeCubit extends Cubit<CountryCodeState> {
  final CountriesCodeRepository repository;
  CountryCodeCubit(this.repository) : super(CountryCodeState.initialState()){
    getCountryByDialCode("+971"); // initial set to UAE
  }

  void getCountryByDialCode(String dialCode) async {
    emit(state.copyWith(status: CountryStatus.loading , error: null));
    try {
      final countryCode = await repository.getCountryByDialCode(dialCode: dialCode);
      emit(state.copyWith(countryCode: countryCode , status: CountryStatus.success , error: null));
    } catch (error) {
      emit(state.copyWith(error: error.toString() , status: CountryStatus.error));
    }
  }
}
