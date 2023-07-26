// To parse this JSON data, do
//
//     final adReviewsModel = adReviewsModelFromJson(jsonString);

import 'dart:convert';

AdReviewsModel adReviewsModelFromJson(String str) => AdReviewsModel.fromJson(json.decode(str));

String adReviewsModelToJson(AdReviewsModel data) => json.encode(data.toJson());

class AdReviewsModel {
    AdReviewsModel({
        this.data,
        this.links,
        this.meta,
        this.status,
        this.message,
    });

    List<ReviewData> data;
    Links links;
    Meta meta;
    String status;
    String message;

    factory AdReviewsModel.fromJson(Map<String, dynamic> json) => AdReviewsModel(
        data: List<ReviewData>.from(json["data"].map((x) => ReviewData.fromJson(x))),
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

class ReviewData {
    ReviewData({
        this.id,
        this.fullname,
        this.image,
        this.rate,
        this.review,
    });

    int id;
    String fullname;
    String image;
    dynamic rate;
    String review;

    factory ReviewData.fromJson(Map<String, dynamic> json) => ReviewData(
        id: json["id"],
        fullname: json["fullname"],
        image: json["image"],
        rate: json["rate"],
        review: json["review"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "image": image,
        "rate": rate,
        "review": review,
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
