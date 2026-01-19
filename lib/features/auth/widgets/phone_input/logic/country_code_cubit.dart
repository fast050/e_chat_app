import 'package:e_chat_app/core/local/country_code_local_source/domain/repo/countries_code_repository.dart';
import 'package:e_chat_app/features/auth/widgets/phone_input/logic/country_code_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountryCodeCubit extends Cubit<CountryCodeState> {
  final CountriesCodeRepository repository;
  CountryCodeCubit(this.repository) : super(CountryCodeState.initialState()){
    getCountries();
    getCountryByDialCode("+971"); // initial set to UAE
  }

  void getCountryByDialCode(String dialCode) async {
    emit(state.copyWith(status: CountryStatus.loading , error: null));
    try {
      final country = await repository.getCountryByDialCode(dialCode: dialCode);
      emit(state.copyWith(countryCode: country , status: CountryStatus.success , error: null));
    } catch (error) {
      emit(state.copyWith(error: error.toString() , status: CountryStatus.error));
    }
  }

   void getCountryByCode(String code) async {
    emit(state.copyWith(status: CountryStatus.loading , error: null));
    try {
      final country = await repository.getCountryByCode(code: code);
      emit(state.copyWith(countryCode: country , status: CountryStatus.success , error: null));
    } catch (error) {
      emit(state.copyWith(error: error.toString() , status: CountryStatus.error));
    }
  }

  void getCountries() async{
    emit(state.copyWith(status: CountryStatus.loading , error: null));
    try{
      final countries = await repository.getCountriesCodes();
      emit(state.copyWith(countries: countries , status: CountryStatus.success , error: null));
    }catch(error){
      emit(state.copyWith(status: CountryStatus.error , error: error.toString()));
    }
  }
}
