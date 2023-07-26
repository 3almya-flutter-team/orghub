// To parse this JSON data, do
//
//     final searchResultsModel = searchResultsModelFromJson(jsonString);

import 'dart:convert';

SearchResultsModel searchResultsModelFromJson(String str) => SearchResultsModel.fromJson(json.decode(str));

String searchResultsModelToJson(SearchResultsModel data) => json.encode(data.toJson());

class SearchResultsModel {
    SearchResultsModel({
        this.data,
        this.links,
        this.meta,
        this.status,
        this.message,
    });

    List<SearchItem> data;
    Links links;
    Meta meta;
    String status;
    String message;

    factory SearchResultsModel.fromJson(Map<String, dynamic> json) => SearchResultsModel(
        data: List<SearchItem>.from(json["data"].map((x) => SearchItem.fromJson(x))),
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

class SearchItem {
    SearchItem({
        this.id,
        this.name,
        this.image,
        this.price,
        this.totalRate,
        this.desc,
        this.address,
        this.adType,
        this.country,
        this.city,
        this.isFavourite,
        this.myRate,
        this.adOwner,
        this.organizationName,
        this.category,
        this.currency,
        this.images,
    });

    int id;
    String name;
    String image;
    String price;
    String totalRate;
    String desc;
    dynamic address;
    String adType;
    String organizationName;
    Category country;
    Category city;
    bool isFavourite;
    String myRate;
    AdOwner adOwner;
    Category category;
    Currency currency;
    List<ImageData> images;

    factory SearchItem.fromJson(Map<String, dynamic> json) => SearchItem(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        price: json["price"],
        organizationName: json["organization_name"],
        totalRate: json["total_rate"],
        desc: json["desc"],
        address: json["address"],
        adType: json["ad_type"],
        
        isFavourite: json["is_favourite"],
        myRate: json["my_rate"],
        country:  json["country"] == null ? null:Category.fromJson(json["country"]),
        city:     json["city"] == null ? null:Category.fromJson(json["city"]),
        adOwner:  json["ad_owner"] == null ? null:AdOwner.fromJson(json["ad_owner"]),
        category: json["category"] == null ? null:Category.fromJson(json["category"]),
        currency: json["currency"] == null ? null:Currency.fromJson(json["currency"]),
        images: json["images"] == null ? null: List<ImageData>.from(json["images"].map((x) => ImageData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "price": price,
        "total_rate": totalRate,
        "desc": desc,
        "address": address,
        "ad_type": adType,
        "country": country.toJson(),
        "city": city.toJson(),
        "is_favourite": isFavourite,
        "my_rate": myRate,
        "ad_owner": adOwner.toJson(),
        "category": category.toJson(),
        "currency": currency.toJson(),
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
    };
}

class AdOwner {
    AdOwner({
        this.id,
        this.name,
        this.phone,
        this.whatsapp,
        this.image,
        this.cover,
        this.userType,
    });

    int id;
    String name;
    dynamic phone;
    dynamic whatsapp;
    String image;
    String cover;
    String userType;

    factory AdOwner.fromJson(Map<String, dynamic> json) => AdOwner(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        whatsapp: json["whatsapp"],
        image: json["image"],
        cover: json["cover"],
        userType: json["user_type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "whatsapp": whatsapp,
        "image": image,
        "cover": cover,
        "user_type": userType,
    };
}

class Category {
    Category({
        this.id,
        this.name,
    });

    int id;
    String name;

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
    };
}
class Currency {
    Currency({
        this.id,
        this.name,
    });

    int id;
    String name;

    factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
    };
}

class ImageData {
    ImageData({
        this.img,
        this.imageId,
    });

    String img;
    int imageId;

    factory ImageData.fromJson(Map<String, dynamic> json) => ImageData(
        img: json["img"],
        imageId: json["image_id"],
    );

    Map<String, dynamic> toJson() => {
        "img": img,
        "image_id": imageId,
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