// To parse this JSON data, do
//
//     final reasonsModel = reasonsModelFromJson(jsonString);

import 'dart:convert';

ReasonsModel reasonsModelFromJson(String str) =>
    ReasonsModel.fromJson(json.decode(str));

String reasonsModelToJson(ReasonsModel data) => json.encode(data.toJson());

class ReasonsModel {
  ReasonsModel({
    this.data,
    this.status,
    this.message,
  });

  List<ReasonData> data;
  String status;
  String message;

  factory ReasonsModel.fromJson(Map<String, dynamic> json) => ReasonsModel(
        data: List<ReasonData>.from(
            json["data"].map((x) => ReasonData.fromJson(x))),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
      };
}

class ReasonData {
  ReasonData({
    this.id,
    this.name,
    this.selected,
  });

  int id;
  String name;
  bool selected;

  factory ReasonData.fromJson(Map<String, dynamic> json) => ReasonData(
        id: json["id"],
        name: json["name"],
        selected: false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
