// To parse this JSON data, do
//
//     final myCommentsModel = myCommentsModelFromJson(jsonString);

import 'dart:convert';

MyCommentsModel myCommentsModelFromJson(String str) => MyCommentsModel.fromJson(json.decode(str));

String myCommentsModelToJson(MyCommentsModel data) => json.encode(data.toJson());

class MyCommentsModel {
    MyCommentsModel({
        this.data,
        this.links,
        this.meta,
        this.status,
        this.message,
    });

    List<CommentData> data;
    Links links;
    Meta meta;
    String status;
    String message;

    factory MyCommentsModel.fromJson(Map<String, dynamic> json) => MyCommentsModel(
        data: List<CommentData>.from(json["data"].map((x) => CommentData.fromJson(x))),
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

class CommentData {
    CommentData({
        this.id,
        this.name,
        this.image,
        this.rate,
        this.review,
        this.createdAt,
    });

    int id;
    String name;
    String image;
    dynamic rate;
    String review;
    DateTime createdAt;

    factory CommentData.fromJson(Map<String, dynamic> json) => CommentData(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        rate: json["rate"],
        review: json["review"],
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "rate": rate,
        "review": review,
        "created_at": "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
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