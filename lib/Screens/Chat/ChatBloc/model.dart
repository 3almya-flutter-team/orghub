// To parse this JSON data, do
//
//     final singleChatModel = singleChatModelFromJson(jsonString);

import 'dart:convert';

import 'package:orghub/Screens/Chat/SendMessageBloc/model.dart';

SingleChatModel singleChatModelFromJson(String str) =>
    SingleChatModel.fromJson(json.decode(str));

String singleChatModelToJson(SingleChatModel data) =>
    json.encode(data.toJson());

class SingleChatModel {
  SingleChatModel({
    this.data,
    this.chatId,
    this.status,
    this.message,
  });

  List<SendMessageData> data;
  int chatId;
  String status;
  String message;

  factory SingleChatModel.fromJson(Map<String, dynamic> json) =>
      SingleChatModel(
        data: List<SendMessageData>.from(
          json["data"].map(
            (x) => SendMessageData.fromJson(x),
          ),
        ),
        chatId: json["chat_id"],
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "chat_id":chatId,
        "message": message,
      };
}

// class ChatData {
//   ChatData({
//     this.chatId,
//     this.messageId,
//     this.messagePosition,
//     this.senderData,
//     this.receiverData,
//     this.message,
//     this.messageType,
//     this.readAt,
//     this.createdAt,
//   });

//   int chatId;
//   int messageId;
//   String messagePosition;
//   UserData senderData;
//   UserData receiverData;
//   String message;
//   String messageType;
//   String readAt;
//   String createdAt;

//   factory ChatData.fromJson(Map<String, dynamic> json) => ChatData(
//         chatId: json["chat_id"],
//         messageId: json["message_id"],
//         messagePosition: json["message_position"],
//         senderData: UserData.fromJson(json["sender_data"]),
//         receiverData: UserData.fromJson(json["receiver_data"]),
//         message: json["message"],
//         messageType: json["message_type"],
//         readAt: json["read_at"],
//         createdAt: json["created_at"],
//       );

//   Map<String, dynamic> toJson() => {
//         "chat_id": chatId,
//         "message_id": messageId,
//         "message_position": messagePosition,
//         "sender_data": senderData.toJson(),
//         "receiver_data": receiverData.toJson(),
//         "message": message,
//         "message_type": messageType,
//         "read_at": readAt,
//         "created_at": createdAt,
//       };
// }

// class UserData {
//   UserData({
//     this.id,
//     this.fullname,
//     this.image,
//   });

//   int id;
//   String fullname;
//   String image;

//   factory UserData.fromJson(Map<String, dynamic> json) => UserData(
//         id: json["id"],
//         fullname: json["fullname"],
//         image: json["image"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "fullname": fullname,
//         "image": image,
//       };
// }
