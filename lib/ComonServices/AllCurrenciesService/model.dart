// To parse this JSON data, do
//
//     final allCurrenciesModel = allCurrenciesModelFromJson(jsonString);

import 'dart:convert';

AllCurrenciesModel allCurrenciesModelFromJson(String str) => AllCurrenciesModel.fromJson(json.decode(str));

String allCurrenciesModelToJson(AllCurrenciesModel data) => json.encode(data.toJson());

class AllCurrenciesModel {
    AllCurrenciesModel({
        this.data,
        this.status,
        this.message,
    });

    List<Currency> data;
    String status;
    String message;

    factory AllCurrenciesModel.fromJson(Map<String, dynamic> json) => AllCurrenciesModel(
        data: List<Currency>.from(json["data"].map((x) => Currency.fromJson(x))),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class Currency {
    Currency({
        this.id,
        this.name,
        this.desc,
        this.adCount,
        this.country,
    });

    int id;
    String name;
    String desc;
    int adCount;
    Country country;

    factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id: json["id"],
        name: json["name"],
        desc: json["desc"],
        adCount: json["ad_count"],
        country: Country.fromJson(json["country"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "desc": desc,
        "ad_count": adCount,
        "country": country.toJson(),
    };
}

class Country {
    Country({
        this.id,
        this.name,
    });

    int id;
    String name;

    factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}