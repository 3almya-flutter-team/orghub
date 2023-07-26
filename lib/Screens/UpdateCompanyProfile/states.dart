import 'package:flutter/material.dart';
import 'package:orghub/Screens/UpdateCompanyProfile/model.dart';

class GetCompanyProfileState {}

class GetCompanyProfileStateStart extends GetCompanyProfileState {}

class GetCompanyProfileStateSuccess extends GetCompanyProfileState {
  CompanyProfileModel companyProfileModel;
  GetCompanyProfileStateSuccess({
    @required this.companyProfileModel,
  });
}

class GetCompanyProfileStateFailed extends GetCompanyProfileState {
  String msg;
  int errType;
  dynamic statusCode;
  GetCompanyProfileStateFailed({this.msg, this.errType,this.statusCode});
}
