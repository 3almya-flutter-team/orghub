// To parse this JSON data, do
//
//     final singleBuyingOrderModel = singleBuyingOrderModelFromJson(jsonString);

import 'dart:convert';

SingleBuyingOrderModel singleBuyingOrderModelFromJson(String str) =>
    SingleBuyingOrderModel.fromJson(json.decode(str));

String singleBuyingOrderModelToJson(SingleBuyingOrderModel data) =>
    json.encode(data.toJson());

class SingleBuyingOrderModel {
  SingleBuyingOrderModel({
    this.data,
    this.status,
    this.message,
  });

  SingleBuyingOrder data;
  String status;
  String message;

  factory SingleBuyingOrderModel.fromJson(Map<String, dynamic> json) =>
      SingleBuyingOrderModel(
        data: SingleBuyingOrder.fromJson(json["data"]),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "status": status,
        "message": message,
      };
}

class SingleBuyingOrder {
  SingleBuyingOrder({
    this.id,
    this.createdAt,
    this.finishedAt,
    this.totalPrice,
    this.orderStatus,
    this.isMyAd,
    this.isMyOrder,
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
  bool isMyOrder;
  bool isMyAd;
  String orderStatus;
  String serviceType;
  String transServiceType;
  String transOrderStatus;
  String image;
  City country;
  City city;
  String address;
  Bill bill;

  factory SingleBuyingOrder.fromJson(Map<String, dynamic> json) =>
      SingleBuyingOrder(
        id: json["id"],
        createdAt: json["created_at"],
        finishedAt: json["finished_at"],
        totalPrice: json["total_price"],
        orderStatus: json["order_status"],
        serviceType: json["service_type"],
        transServiceType: json["trans_service_type"],
        transOrderStatus: json["trans_order_status"],
        isMyAd: json["is_my_ad"],
        isMyOrder : json["is_my_order"],
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
