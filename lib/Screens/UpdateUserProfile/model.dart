// To parse this JSON data, do
//
//     final UserProfileModel = UserProfileModelFromJson(jsonString);

import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) =>
    UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) =>
    json.encode(data.toJson());

class UserProfileModel {
  UserProfileModel({
    this.data,
    this.status,
    this.message,
  });

  UserData data;
  String status;
  String message;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        data: UserData.fromJson(json["data"]),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "status": status,
        "message": message,
      };
}

class UserData {
  UserData({
    this.id,
    this.fullname,
    this.phone,
    this.whatsapp,
    this.email,
    this.image,
    this.cover,
    this.userType,
    this.country,
    this.city,
  });

  int id;
  String fullname;
  String phone;
  String whatsapp;
  String email;
  String image;
  String cover;
  String userType;
  City country;
  City city;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        fullname: json["fullname"],
        phone: json["phone"],
        whatsapp: json["whatsapp"],
        email: json["email"],
        image: json["image"],
        cover: json["cover"],
        userType: json["user_type"],
        country:
            json["country"] == null ? null : City.fromJson(json["country"]),
        city: json["city"] == null ? null : City.fromJson(json["city"]),
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
        "country": country.toJson(),
        "city": city.toJson(),
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
