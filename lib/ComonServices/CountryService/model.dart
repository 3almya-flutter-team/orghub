// To parse this JSON data, do
//
//     final allCountriesModel = allCountriesModelFromJson(jsonString);

import 'dart:convert';

AllCountriesModel allCountriesModelFromJson(String str) => AllCountriesModel.fromJson(json.decode(str));

String allCountriesModelToJson(AllCountriesModel data) => json.encode(data.toJson());

class AllCountriesModel {
    AllCountriesModel({
        this.data,
        this.status,
        this.message,
    });

    List<CountryData> data;
    String status;
    String message;

    factory AllCountriesModel.fromJson(Map<String, dynamic> json) => AllCountriesModel(
        data: List<CountryData>.from(json["data"].map((x) => CountryData.fromJson(x))),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class CountryData {
    CountryData({
        this.id,
        this.name,
    });

    int id;
    String name;

    factory CountryData.fromJson(Map<String, dynamic> json) => CountryData(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
