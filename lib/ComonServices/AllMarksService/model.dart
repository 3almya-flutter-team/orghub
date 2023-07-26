// To parse this JSON data, do
//
//     final allMarksModel = allMarksModelFromJson(jsonString);

import 'dart:convert';

AllMarksModel allMarksModelFromJson(String str) => AllMarksModel.fromJson(json.decode(str));

String allMarksModelToJson(AllMarksModel data) => json.encode(data.toJson());

class AllMarksModel {
    AllMarksModel({
        this.data,
        this.status,
        this.message,
    });

    List<Mark> data;
    String status;
    String message;

    factory AllMarksModel.fromJson(Map<String, dynamic> json) => AllMarksModel(
        data: List<Mark>.from(json["data"].map((x) => Mark.fromJson(x))),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class Mark {
    Mark({
        this.id,
        this.name,
        this.desc,
        this.adCount,
    });

    int id;
    String name;
    String desc;
    int adCount;

    factory Mark.fromJson(Map<String, dynamic> json) => Mark(
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
