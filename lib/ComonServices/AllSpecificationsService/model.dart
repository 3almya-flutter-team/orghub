// To parse this JSON data, do
//
//     final allSpecificationsModel = allSpecificationsModelFromJson(jsonString);

import 'dart:convert';

AllSpecificationsModel allSpecificationsModelFromJson(String str) => AllSpecificationsModel.fromJson(json.decode(str));

String allSpecificationsModelToJson(AllSpecificationsModel data) => json.encode(data.toJson());

class AllSpecificationsModel {
    AllSpecificationsModel({
        this.data,
        this.status,
        this.message,
    });

    List<Specification> data;
    String status;
    String message;

    factory AllSpecificationsModel.fromJson(Map<String, dynamic> json) => AllSpecificationsModel(
        data: List<Specification>.from(json["data"].map((x) => Specification.fromJson(x))),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class Specification {
    Specification({
        this.id,
        this.name,
        this.desc,
        this.adCount,
    });

    int id;
    String name;
    String desc;
    int adCount;

    factory Specification.fromJson(Map<String, dynamic> json) => Specification(
        id: json["id"],
        name: json["name"],
        desc: json["desc"],
        adCount: json["ad_count"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "desc": desc,
        "ad_count": adCount,
    };
}
