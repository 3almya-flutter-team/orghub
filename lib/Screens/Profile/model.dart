// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
    ProfileModel({
        this.data,
        this.status,
        this.message,
    });

    ProfileData data;
    String status;
    String message;

    factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        data: ProfileData.fromJson(json["data"]),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "status": status,
        "message": message,
    };
}

class ProfileData {
    ProfileData({
        this.id,
        this.fullname,
        this.phone,
        this.email,
        this.image,
        this.country,
        this.city,
    });

    int id;
    String fullname;
    String phone;
    String email;
    String image;
    City country;
    City city;

    factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        id: json["id"],
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
        country: City.fromJson(json["country"]),
        city: City.fromJson(json["city"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
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
