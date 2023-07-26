// To parse this JSON data, do
//
//     final sendMessageModel = sendMessageModelFromJson(jsonString);

import 'dart:convert';

SendMessageModel sendMessageModelFromJson(String str) =>
    SendMessageModel.fromJson(json.decode(str));

String sendMessageModelToJson(SendMessageModel data) =>
    json.encode(data.toJson());

class SendMessageModel {
  SendMessageModel({
    this.data,
    this.status,
    this.message,
  });

  SendMessageData data;
  String status;
  String message;

  factory SendMessageModel.fromJson(Map<String, dynamic> json) =>
      SendMessageModel(
        data: SendMessageData.fromJson(json["data"]),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "status": status,
        "message": message,
      };
}

class SendMessageData {
  SendMessageData({
    this.chatId,
    this.messageId,
    this.messagePosition,
    this.messageSender,
    this.senderData,
    this.receiverData,
    this.message,
    this.messageType,
    this.readAt,
    this.createdAt,
  });

  int chatId;
  int messageId;
  String messagePosition;
  int messageSender;
  SenderData senderData;
  ReceiverData receiverData;
  String message;
  String messageType;
  String readAt;
  String createdAt;

  factory SendMessageData.fromJson(Map<String, dynamic> json) =>
      SendMessageData(
        chatId: json["chat_id"],
        messageId: json["message_id"],
        messageSender: json["message_sender"],
        messagePosition: json["message_position"],
        senderData: SenderData.fromJson(json["sender_data"]),
        receiverData: ReceiverData.fromJson(json["receiver_data"]),
        message: json["message"],
        messageType: json["message_type"],
        readAt: json["read_at"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "chat_id": chatId,
        "message_id": messageId,
        "message_position": messagePosition,
        "sender_data": senderData.toJson(),
        "message_sender":messageSender,
        "receiver_data": receiverData.toJson(),
        "message": message,
        "message_type": messageType,
        "read_at": readAt,
        "created_at": createdAt,
      };
}

class ReceiverData {
  ReceiverData({
    this.id,
    this.fullname,
    this.image,
  });

  dynamic id;
  String fullname;
  String image;

  factory ReceiverData.fromJson(Map<String, dynamic> json) => ReceiverData(
        id: json["id"],
        fullname: json["fullname"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "image": image,
      };
}

class SenderData {
  SenderData({
    this.id,
    this.fullname,
    this.image,
  });

  dynamic id;
  String fullname;
  String image;

  factory SenderData.fromJson(Map<String, dynamic> json) => SenderData(
        id: json["id"],
        fullname: json["fullname"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "image": image,
      };
}
