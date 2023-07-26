// To parse this JSON data, do
//
//     final companyActivationModel = companyActivationModelFromJson(jsonString);

import 'dart:convert';

CompanyActivationModel companyActivationModelFromJson(String str) =>
    CompanyActivationModel.fromJson(json.decode(str));

String companyActivationModelToJson(CompanyActivationModel data) =>
    json.encode(data.toJson());

class CompanyActivationModel {
  CompanyActivationModel({
    this.data,
    this.status,
    this.message,
  });

  Data data;
  String status;
  String message;

  factory CompanyActivationModel.fromJson(Map<String, dynamic> json) =>
      CompanyActivationModel(
        data: Data.fromJson(json["data"]),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "status": status,
        "message": message,
      };
}

class Data {
  Data({
    this.id,
    this.fullname,
    this.phone,
    this.whatsapp,
    this.email,
    this.image,
    this.cover,
    this.userType,
    this.token,
    this.country,
    this.city,
    this.organizationName,
    this.organizationWebsite,
    this.organizationAddress,
    this.organizationLocation,
    this.organizationLat,
    this.organizationLng,
    this.organizationLicenceImage,
    this.organizationLicenceNumber,
  });

  int id;
  String fullname;
  String phone;
  String whatsapp;
  String email;
  String image;
  String cover;
  String userType;
  String token;
  City country;
  City city;
  String organizationName;
  dynamic organizationWebsite;
  String organizationAddress;
  String organizationLocation;
  dynamic organizationLat;
  dynamic organizationLng;
  String organizationLicenceImage;
  String organizationLicenceNumber;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        fullname: json["fullname"],
        phone: json["phone"],
        whatsapp: json["whatsapp"],
        email: json["email"],
        image: json["image"],
        cover: json["cover"],
        userType: json["user_type"],
        token: json["token"],
        country:
            json["country"] == null ? null : City.fromJson(json["country"]),
        city: json["city"] == null ? null : City.fromJson(json["city"]),
        organizationName: json["organization_name"],
        organizationWebsite: json["organization_website"],
        organizationAddress: json["organization_address"],
        organizationLocation: json["organization_location"],
        organizationLat: json["organization_lat"],
        organizationLng: json["organization_lng"],
        organizationLicenceImage: json["organization_licence_image"],
        organizationLicenceNumber: json["organization_licence_number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "phone": phone,
        "whatsapp": whatsapp,
        "email": email,
        "image": image,
        "cover": cover,
        "user_type": userType,
        "token": token,
        "country": country.toJson(),
        "city": city.toJson(),
        "organization_name": organizationName,
        "organization_website": organizationWebsite,
        "organization_address": organizationAddress,
        "organization_location": organizationLocation,
        "organization_lat": organizationLat,
        "organization_lng": organizationLng,
        "organization_licence_image": organizationLicenceImage,
        "organization_licence_number": organizationLicenceNumber,
      };
}

class City {
  City({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

// // To parse this JSON data, do
// //
// //     final organizationProfileModel = organizationProfileModelFromJson(jsonString);

// import 'dart:convert';

// OrganizationProfileModel organizationProfileModelFromJson(String str) =>
//     OrganizationProfileModel.fromJson(json.decode(str));

// String organizationProfileModelToJson(OrganizationProfileModel data) =>
//     json.encode(data.toJson());

// class OrganizationProfileModel {
//   OrganizationProfileModel({
//     this.profile,
//     this.status,
//     this.message,
//   });

//   CompanyProfile profile;
//   String status;
//   String message;

//   factory OrganizationProfileModel.fromJson(Map<String, dynamic> json) =>
//       OrganizationProfileModel(
//         profile: CompanyProfile.fromJson(json["data"]),
//         status: json["status"],
//         message: json["message"],
//       );

//   Map<String, dynamic> toJson() => {
//         "data": profile.toJson(),
//         "status": status,
//         "message": message,
//       };
// }

// class CompanyProfile {
//   CompanyProfile({
//     this.id,
//     this.fullname,
//     this.phone,
//     this.email,
//     this.image,
//     this.token,
//     this.country,
//     this.city,
//   });

//   int id;
//   String fullname;
//   String phone;
//   String email;
//   String image;
//   String token;
//   City country;
//   City city;

//   factory CompanyProfile.fromJson(Map<String, dynamic> json) => CompanyProfile(
//         id: json["id"],
//         fullname: json["fullname"],
//         phone: json["phone"],
//         email: json["email"],
//         image: json["image"],
//         token: json["token"],
//         country: json["country"] == null ? null:City.fromJson(json["country"]),
//         city: json["city"] == null ? null: City.fromJson(json["city"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "fullname": fullname,
//         "phone": phone,
//         "email": email,
//         "image": image,
//         "token": token,
//         "country": country.toJson(),
//         "city": city.toJson(),
//       };
// }

// class City {
//   City({
//     this.id,
//     this.name,
//   });

//   int id;
//   String name;

//   factory City.fromJson(Map<String, dynamic> json) => City(
//         id: json["id"],
//         name: json["name"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//       };
// }
