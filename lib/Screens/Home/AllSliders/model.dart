// To parse this JSON data, do
//
//     final allSlidersModel = allSlidersModelFromJson(jsonString);

import 'dart:convert';

AllSlidersModel allSlidersModelFromJson(String str) => AllSlidersModel.fromJson(json.decode(str));

String allSlidersModelToJson(AllSlidersModel data) => json.encode(data.toJson());

class AllSlidersModel {
    AllSlidersModel({
        this.data,
        this.status,
        this.message,
    });

    List<SliderData> data;
    String status;
    String message;

    factory AllSlidersModel.fromJson(Map<String, dynamic> json) => AllSlidersModel(
        data: List<SliderData>.from(json["data"].map((x) => SliderData.fromJson(x))),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class SliderData {
    SliderData({
        this.id,
        this.ad,
        this.image,
        this.link,
        this.name,
        this.desc,
    });

    int id;
    Ad ad;
    String image;
    String name;
    String link;
    String desc;

    factory SliderData.fromJson(Map<String, dynamic> json) => SliderData(
        id: json["id"],
        ad: json["ad"] == null ? null : Ad.fromJson(json["ad"]),
        image: json["image"],
        link: json["link"],
        name: json["name"],
        desc: json["desc"] == null ? null : json["desc"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "ad": ad == null ? null : ad.toJson(),
        "image": image,
        "link": link,
        "name": name,
        "desc": desc == null ? null : desc,
    };
}

class Ad {
    Ad({
        this.adId,
        this.adType,
    });

    int adId;
    String adType;

    factory Ad.fromJson(Map<String, dynamic> json) => Ad(
        adId: json["ad_id"],
        adType: json["ad_type"],
    );

    Map<String, dynamic> toJson() => {
        "ad_id": adId,
        "ad_type": adType,
    };
}


// // To parse this JSON data, do
// //
// //     final allSlidersModel = allSlidersModelFromJson(jsonString);

// import 'dart:convert';

// AllSlidersModel allSlidersModelFromJson(String str) => AllSlidersModel.fromJson(json.decode(str));

// String allSlidersModelToJson(AllSlidersModel data) => json.encode(data.toJson());

// class AllSlidersModel {
//     AllSlidersModel({
//         this.data,
//         this.status,
//         this.message,
//     });

//     List<SliderData> data;
//     String status;
//     String message;

//     factory AllSlidersModel.fromJson(Map<String, dynamic> json) => AllSlidersModel(
//         data: List<SliderData>.from(json["data"].map((x) => SliderData.fromJson(x))),
//         status: json["status"],
//         message: json["message"],
//     );

//     Map<String, dynamic> toJson() => {
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//         "status": status,
//         "message": message,
//     };
// }

// class SliderData {
//     SliderData({
//         this.id,
//         this.adId,
//         this.image,
//         this.name,
//         this.desc,
//     });

//     int id;
//     dynamic adId;
//     String image;
//     String name;
//     String desc;

//     factory SliderData.fromJson(Map<String, dynamic> json) => SliderData(
//         id: json["id"],
//         adId: json["ad_id"],
//         image: json["image"],
//         name: json["name"],
//         desc: json["desc"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "ad_id": adId,
//         "image": image,
//         "name": name,
//         "desc": desc,
//     };
// }