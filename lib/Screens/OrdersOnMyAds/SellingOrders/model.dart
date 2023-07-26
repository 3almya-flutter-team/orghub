// To parse this JSON data, do
//
//     final mySellingModel = mySellingModelFromJson(jsonString);

import 'dart:convert';

MySellingModel mySellingModelFromJson(String str) => MySellingModel.fromJson(json.decode(str));

String mySellingModelToJson(MySellingModel data) => json.encode(data.toJson());

class MySellingModel {
    MySellingModel({
        this.data,
        this.links,
        this.meta,
        this.status,
        this.message,
    });

    List<SellingOrderDetail> data;
    Links links;
    Meta meta;
    String status;
    String message;

    factory MySellingModel.fromJson(Map<String, dynamic> json) => MySellingModel(
        data: List<SellingOrderDetail>.from(json["data"].map((x) => SellingOrderDetail.fromJson(x))),
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

class SellingOrderDetail {
    SellingOrderDetail({
        this.id,
        this.createdAt,
        this.finishedAt,
        this.totalPrice,
        this.orderStatus,
        this.serviceType,
        this.transServiceType,
        this.transOrderStatus,
        this.image,
        this.country,
        this.city,
        this.address,
        this.bill,
    });

    int id;
    String createdAt;
    String finishedAt;
    String totalPrice;
    String orderStatus;
    String serviceType;
    String transServiceType;
    String transOrderStatus;
    String image;
    City country;
    City city;
    String address;
    Bill bill;

    factory SellingOrderDetail.fromJson(Map<String, dynamic> json) => SellingOrderDetail(
        id: json["id"],
        createdAt: json["created_at"],
        finishedAt: json["finished_at"],
        totalPrice: json["total_price"],
        orderStatus: json["order_status"],
        serviceType: json["service_type"],
        transServiceType: json["trans_service_type"],
        transOrderStatus: json["trans_order_status"],
        image: json["image"],
        country: City.fromJson(json["country"]),
        city: City.fromJson(json["city"]),
        address: json["address"],
        bill: Bill.fromJson(json["bill"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt,
        "finished_at": finishedAt,
        "total_price": totalPrice,
        "order_status": orderStatus,
        "service_type": serviceType,
        "trans_service_type": transServiceType,
        "trans_order_status": transOrderStatus,
        "image": image,
        "country": country.toJson(),
        "city": city.toJson(),
        "address": address,
        "bill": bill.toJson(),
    };
}

class Bill {
    Bill({
        this.id,
        this.name,
        this.image,
        this.specification,
        this.classification,
        this.mark,
        this.qty,
        this.price,
        this.totalAdPrice,
    });

    int id;
    String name;
    String image;
    String specification;
    String classification;
    String mark;
    int qty;
    String price;
    int totalAdPrice;

    factory Bill.fromJson(Map<String, dynamic> json) => Bill(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        specification: json["specification"],
        classification: json["classification"],
        mark: json["mark"],
        qty: json["qty"],
        price: json["price"],
        totalAdPrice: json["total_ad_price"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "specification": specification,
        "classification": classification,
        "mark": mark,
        "qty": qty,
        "price": price,
        "total_ad_price": totalAdPrice,
    };
}

class City {
    City({
        this.id,
        this.name,
    });

    int id;
    String name;

    factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
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