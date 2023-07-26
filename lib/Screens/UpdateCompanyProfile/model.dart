// To parse this JSON data, do
//
//     final companyProfileModel = companyProfileModelFromJson(jsonString);

import 'dart:convert';

CompanyProfileModel companyProfileModelFromJson(String str) => CompanyProfileModel.fromJson(json.decode(str));

String companyProfileModelToJson(CompanyProfileModel data) => json.encode(data.toJson());

class CompanyProfileModel {
    CompanyProfileModel({
        this.data,
        this.status,
        this.message,
    });

    CompanyData data;
    String status;
    String message;

    factory CompanyProfileModel.fromJson(Map<String, dynamic> json) => CompanyProfileModel(
        data: CompanyData.fromJson(json["data"]),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "status": status,
        "message": message,
    };
}

class CompanyData {
    CompanyData({
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
    City country;
    City city;
    String organizationName;
    String organizationWebsite;
    String organizationAddress;
    String organizationLocation;
    dynamic organizationLat;
    dynamic organizationLng;
    String organizationLicenceImage;
    String organizationLicenceNumber;

    factory CompanyData.fromJson(Map<String, dynamic> json) => CompanyData(
        id: json["id"],
        fullname: json["fullname"],
        phone: json["phone"],
        whatsapp: json["whatsapp"],
        email: json["email"],
        image: json["image"],
        cover: json["cover"],
        userType: json["user_type"],
        country: City.fromJson(json["country"]),
        city: City.fromJson(json["city"]),
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