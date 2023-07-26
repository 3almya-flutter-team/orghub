// To parse this JSON data, do
//
//     final policyAppModel = policyAppModelFromJson(jsonString);

import 'dart:convert';

PolicyAppModel policyAppModelFromJson(String str) => PolicyAppModel.fromJson(json.decode(str));

String policyAppModelToJson(PolicyAppModel data) => json.encode(data.toJson());

class PolicyAppModel {
    PolicyAppModel({
        this.data,
        this.status,
        this.message,
    });

    PolicyData data;
    String status;
    String message;

    factory PolicyAppModel.fromJson(Map<String, dynamic> json) => PolicyAppModel(
        data: PolicyData.fromJson(json["data"]),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "status": status,
        "message": message,
    };
}

class PolicyData {
    PolicyData({
        this.policy,
    });

    String policy;

    factory PolicyData.fromJson(Map<String, dynamic> json) => PolicyData(
        policy: json["policy"],
    );

    Map<String, dynamic> toJson() => {
        "policy": policy,
    };
}
