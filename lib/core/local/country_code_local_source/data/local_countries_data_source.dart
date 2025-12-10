import 'dart:convert';
import 'package:flutter/services.dart';

class LocalCountriesDataSource{

  List<CountryCodeJSon> list = [];

  LocalCountriesDataSource();

  void getCountriesCodes() async{
       
    final String response = await rootBundle.loadString('assets/countries.json');
    final data = await json.decode(response);
 
    print(data);
  }


}


class CountryCodeJSon{



}