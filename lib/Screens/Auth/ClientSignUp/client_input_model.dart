import 'dart:io';

class ClientInputData {
  String fullname;
  String email;
  String password;
  File profileImage;
  String phone;
  String whatsapp;
  int cityId;
  String cityName;
  int countryId;
  String countryName;
  String gender;
  String userType;

  

  ClientInputData({
    this.fullname,
    this.email,
    this.profileImage,
    this.password,
    this.phone,
    this.whatsapp,
    this.cityId,
    this.countryName,
    this.cityName,
    this.countryId,
    this.gender,
    this.userType,

  });

  Map<String, dynamic> toJson() {
    return {
      "fullname": fullname,
      "email": email,
      "profileImage":profileImage,
      "password": password,
      "phone": phone,
      "whatsapp": whatsapp,
      "cityId": cityId,
      "countryId": countryId,
      "gender": gender,
      "userType": userType,
    
    };
  }
}
