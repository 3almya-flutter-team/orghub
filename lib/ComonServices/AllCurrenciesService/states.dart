import 'package:orghub/ComonServices/AllCurrenciesService/model.dart';

class GetAllCurrenciesStates {}

class GetAllCurrenciesStateStart extends GetAllCurrenciesStates {}

class GetAllCurrenciesStateSucess extends GetAllCurrenciesStates {
  AllCurrenciesModel allCurrenciesModel;
  GetAllCurrenciesStateSucess({
    this.allCurrenciesModel,
  });
}

class GetAllCurrenciesStateFaild extends GetAllCurrenciesStates {
  String msg;
  int errType;
  dynamic statusCode;
  GetAllCurrenciesStateFaild({this.msg, this.errType,this.statusCode});
}
