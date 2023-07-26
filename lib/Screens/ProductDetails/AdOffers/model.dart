// To parse this JSON data, do
//
//     final adOffersModel = adOffersModelFromJson(jsonString);

import 'dart:convert';

AdOffersModel adOffersModelFromJson(String str) => AdOffersModel.fromJson(json.decode(str));

String adOffersModelToJson(AdOffersModel data) => json.encode(data.toJson());

class AdOffersModel {
    AdOffersModel({
        this.data,
        this.links,
        this.meta,
        this.status,
        this.message,
    });

    List<OfferData> data;
    Links links;
    Meta meta;
    String status;
    String message;

    factory AdOffersModel.fromJson(Map<String, dynamic> json) => AdOffersModel(
        data: List<OfferData>.from(json["data"].map((x) => OfferData.fromJson(x))),
        links: Links.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "links": links.toJson(),
        "meta": meta.toJson(),
        "status": status,
        "message": message,
    };
}

class OfferData {
    OfferData({
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

    factory OfferData.fromJson(Map<String, dynamic> json) => OfferData(
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

class Links {
    Links({
        this.first,
        this.last,
        this.prev,
        this.next,
    });

    String first;
    String last;
    dynamic prev;
    dynamic next;

    factory Links.fromJson(Map<String, dynamic> json) => Links(
        first: json["first"],
        last: json["last"],
        prev: json["prev"],
        next: json["next"],
    );

    Map<String, dynamic> toJson() => {
        "first": first,
        "last": last,
        "prev": prev,
        "next": next,
    };
}

class Meta {
    Meta({
        this.currentPage,
        this.from,
        this.lastPage,
        this.path,
        this.perPage,
        this.to,
        this.total,
    });

    int currentPage;
    int from;
    int lastPage;
    String path;
    int perPage;
    int to;
    int total;

    factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
    };
}