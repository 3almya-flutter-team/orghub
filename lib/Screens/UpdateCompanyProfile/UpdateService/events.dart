

class CompanyUpdateEvents {}

class CompanyUpdateEventStart extends CompanyUpdateEvents {
  Map<String,dynamic> profileData;
  CompanyUpdateEventStart({this.profileData});
}

class CompanyUpdateEventFailed extends CompanyUpdateEvents {}

class CompanyUpdateEventSuccess extends CompanyUpdateEvents {}