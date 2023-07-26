// To parse this JSON data, do
//
//     final allRecursionCategoriesModel = allRecursionCategoriesModelFromJson(jsonString);

import 'dart:convert';

AllRecursionCategoriesModel allRecursionCategoriesModelFromJson(String str) => AllRecursionCategoriesModel.fromJson(json.decode(str));

String allRecursionCategoriesModelToJson(AllRecursionCategoriesModel data) => json.encode(data.toJson());

class AllRecursionCategoriesModel {
    AllRecursionCategoriesModel({
        this.data,
        this.status,
        this.message,
    });

    List<CatData> data;
    String status;
    String message;

    factory AllRecursionCategoriesModel.fromJson(Map<String, dynamic> json) => AllRecursionCategoriesModel(
        data: List<CatData>.from(json["data"].map((x) => CatData.fromJson(x))),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class CatData {
    CatData({
        this.id,
        this.name,
        this.image,
        this.hasSubcategories,
        this.subcategories,
    });

    int id;
    String name;
    String image;
    bool hasSubcategories;
    List<CatData> subcategories;

    factory CatData.fromJson(Map<String, dynamic> json) => CatData(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        hasSubcategories: json["has_subcategories"],
        subcategories: List<CatData>.from(json["subcategories"].map((x) => CatData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "has_subcategories": hasSubcategories,
        "subcategories": List<dynamic>.from(subcategories.map((x) => x.toJson())),
    };
}
