// To parse this JSON data, do
//
//     final allTagsModel = allTagsModelFromJson(jsonString);

import 'dart:convert';

AllTagsModel allTagsModelFromJson(String str) => AllTagsModel.fromJson(json.decode(str));

String allTagsModelToJson(AllTagsModel data) => json.encode(data.toJson());

class AllTagsModel {
    AllTagsModel({
        this.data,
        this.status,
        this.message,
    });

    List<Tag> data;
    String status;
    String message;

    factory AllTagsModel.fromJson(Map<String, dynamic> json) => AllTagsModel(
        data: List<Tag>.from(json["data"].map((x) => Tag.fromJson(x))),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class Tag {
    Tag({
        this.id,
        this.name,
        this.desc,
        this.adCount,
    });

    int id;
    String name;
    String desc;
    int adCount;

    factory Tag.fromJson(Map<String, dynamic> json) => Tag(
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
