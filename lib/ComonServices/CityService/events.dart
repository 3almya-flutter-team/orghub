class GetAllCitiesEvents {}

class GetAllCitiesEventStart extends GetAllCitiesEvents {
  int countryId;
  GetAllCitiesEventStart({this.countryId});
}

class GetAllCitiesEventSucess extends GetAllCitiesEvents {}

class GetAllCitiesEventFaild extends GetAllCitiesEvents {}
