// To parse this JSON data, do
//
//     final allCitiesModel = allCitiesModelFromJson(jsonString);

import 'dart:convert';

AllCitiesModel allCitiesModelFromJson(String str) => AllCitiesModel.fromJson(json.decode(str));

String allCitiesModelToJson(AllCitiesModel data) => json.encode(data.toJson());

class AllCitiesModel {
    AllCitiesModel({
        this.data,
        this.status,
        this.message,
    });

    List<CityData> data;
    String status;
    String message;

    factory AllCitiesModel.fromJson(Map<String, dynamic> json) => AllCitiesModel(
        data: List<CityData>.from(json["data"].map((x) => CityData.fromJson(x))),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class CityData {
    CityData({
        this.id,
        this.name,
    });

    int id;
    String name;

    factory CityData.fromJson(Map<String, dynamic> json) => CityData(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
