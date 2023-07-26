// To parse this JSON data, do
//
//     final offerDetailModel = offerDetailModelFromJson(jsonString);

import 'dart:convert';

OfferDetailModel offerDetailModelFromJson(String str) => OfferDetailModel.fromJson(json.decode(str));

String offerDetailModelToJson(OfferDetailModel data) => json.encode(data.toJson());

class OfferDetailModel {
    OfferDetailModel({
        this.data,
        this.status,
        this.message,
    });

    SingleOfferData data;
    String status;
    String message;

    factory OfferDetailModel.fromJson(Map<String, dynamic> json) => OfferDetailModel(
        data: SingleOfferData.fromJson(json["data"]),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "status": status,
        "message": message,
    };
}

class SingleOfferData {
    SingleOfferData({
        this.id,
        this.ad,
        this.offerPrice,
        this.offerStatus,
        this.transOfferStatus,
    });

    int id;
    Ad ad;
    String offerPrice;
    String offerStatus;
    String transOfferStatus;

    factory SingleOfferData.fromJson(Map<String, dynamic> json) => SingleOfferData(
        id: json["id"],
        ad: Ad.fromJson(json["ad"]),
        offerPrice: json["offer_price"],
        offerStatus: json["offer_status"],
        transOfferStatus: json["trans_offer_status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "ad": ad.toJson(),
        "offer_price": offerPrice,
        "offer_status": offerStatus,
        "trans_offer_status": transOfferStatus,
    };
}

class Ad {
    Ad({
        this.adId,
        this.name,
    });

    int adId;
    String name;

    factory Ad.fromJson(Map<String, dynamic> json) => Ad(
        adId: json["ad_id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "ad_id": adId,
        "name": name,
    };
}