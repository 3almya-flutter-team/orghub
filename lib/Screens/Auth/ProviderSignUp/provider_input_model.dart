import 'dart:io';

class ProviderInputData {
  String fullname;
  String email;
  String password;
  File profileImage;
  File coverImage;
  String phone;
  String whatsapp;
  int cityId;
  String cityName;
  int countryId;
  String countryName;
  String gender;
  String userType;
  String organizationName;
  String organizationAddress;
  String organizationLocation;
  double organizationLat;
  double organizationLng;
  String organizationWebsite;
  File organizationlicenceimage;
  String organizationlicenceNumber;
  

  ProviderInputData({
    this.fullname,
    this.email,
    this.profileImage,
    this.coverImage,
    this.password,
    this.phone,
    this.whatsapp,
    this.cityId,
    this.countryName,
    this.cityName,
    this.countryId,
    this.gender,
    this.userType,
    this.organizationName,
    this.organizationAddress,
    this.organizationLocation,
    this.organizationLat,
    this.organizationLng,
    this.organizationWebsite,
    this.organizationlicenceimage,
    this.organizationlicenceNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "fullname": fullname,
      "email": email,
      "profileImage":profileImage,
      "coverImage":coverImage,
      "password": password,
      "phone": phone,
      "whatsapp": whatsapp,
      "cityId": cityId,
      "countryId": countryId,
      "gender": gender,
      "userType": userType,
      "organizationName": organizationName,
      "organizationAddress": organizationAddress,
      "organizationLocation": organizationLocation,
      "organizationLat": organizationLat,
      "organizationLng": organizationLng,
      "organizationWebsite": organizationWebsite,
      "organizationlicenceimage": organizationlicenceimage,
      "organizationlicenceNumber": organizationlicenceNumber,
    };
  }
}
