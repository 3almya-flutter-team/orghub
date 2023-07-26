// To parse this JSON data, do
//
//     final allChatsModel = allChatsModelFromJson(jsonString);

import 'dart:convert';

AllChatsModel allChatsModelFromJson(String str) => AllChatsModel.fromJson(json.decode(str));

String allChatsModelToJson(AllChatsModel data) => json.encode(data.toJson());

class AllChatsModel {
    AllChatsModel({
        this.data,
        this.links,
        this.meta,
        this.status,
        this.message,
    });

    List<Conversation> data;
    Links links;
    Meta meta;
    String status;
    String message;

    factory AllChatsModel.fromJson(Map<String, dynamic> json) => AllChatsModel(
        data: List<Conversation>.from(json["data"].map((x) => Conversation.fromJson(x))),
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

class Conversation {
    Conversation({
        this.chatId,
        this.orderId,
        this.adOfferId,
        this.clientData,
        this.senderData,
        this.receiverData,
        this.messageType,
        this.lastMessage,
        this.readAt,
        this.createdAt,
    });

    int chatId;
    dynamic orderId;
    dynamic adOfferId;
    ErData senderData;
    ErData clientData;
    ErData receiverData;
    String messageType;
    String lastMessage;
    String readAt;
    DateTime createdAt;

    factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        chatId: json["chat_id"],
        orderId: json["order_id"],
        adOfferId: json["ad_offer_id"],
        clientData: ErData.fromJson(json["client_data"]),
        senderData: ErData.fromJson(json["sender_data"]),
        receiverData: ErData.fromJson(json["receiver_data"]),
        messageType: json["message_type"],
        lastMessage: json["last_message"],
        readAt: json["read_at"],
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "chat_id": chatId,
        "order_id": orderId,
        "ad_offer_id": adOfferId,
        "client_data": clientData.toJson(),
        "sender_data": senderData.toJson(),
        "receiver_data": receiverData.toJson(),
        "message_type": messageType,
        "last_message": lastMessage,
        "read_at": readAt,
        "created_at": "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
    };
}

class ErData {
    ErData({
        this.id,
        this.fullname,
        this.image,
    });

    int id;
    String fullname;
    String image;

    factory ErData.fromJson(Map<String, dynamic> json) => ErData(
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
