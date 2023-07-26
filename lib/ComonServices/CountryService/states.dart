import 'package:orghub/ComonServices/CountryService/model.dart';

class GetAllCountriesStates {}

class GetAllCountriesStateStart extends GetAllCountriesStates {}

class GetAllCountriesStateSucess extends GetAllCountriesStates {
  AllCountriesModel allCountriesModel;
  GetAllCountriesStateSucess({
    this.allCountriesModel,
  });
}

class GetAllCountriesStateFaild extends GetAllCountriesStates {
  String msg;
  int errType;
  GetAllCountriesStateFaild({this.msg, this.errType});
}
