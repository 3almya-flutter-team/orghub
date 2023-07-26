// To parse this JSON data, do
//
//     final aboutAppModel = aboutAppModelFromJson(jsonString);

import 'dart:convert';

AboutAppModel aboutAppModelFromJson(String str) => AboutAppModel.fromJson(json.decode(str));

String aboutAppModelToJson(AboutAppModel data) => json.encode(data.toJson());

class AboutAppModel {
    AboutAppModel({
        this.data,
        this.status,
        this.message,
    });

    AboutData data;
    String status;
    String message;

    factory AboutAppModel.fromJson(Map<String, dynamic> json) => AboutAppModel(
        data: AboutData.fromJson(json["data"]),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "status": status,
        "message": message,
    };
}

class AboutData {
    AboutData({
        this.about,
        this.phone,
        this.email,
        this.whatsapp,
        this.smsMessage,
    });

    String about;
    String phone;
    String email;
    String whatsapp;
    String smsMessage;

    factory AboutData.fromJson(Map<String, dynamic> json) => AboutData(
        about: json["about"],
        phone: json["phone"],
        email: json["email"],
        whatsapp: json["whatsapp"],
        smsMessage: json["sms_message"],
    );

    Map<String, dynamic> toJson() => {
        "about": about,
        "phone": phone,
        "email": email,
        "whatsapp": whatsapp,
        "sms_message": smsMessage,
    };
}