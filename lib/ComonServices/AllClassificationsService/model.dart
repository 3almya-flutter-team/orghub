
class AllClassificationsModel {
    AllClassificationsModel({
        this.data,
        this.status,
        this.message,
    });

    List<Classification> data;
    String status;
    String message;

    factory AllClassificationsModel.fromJson(Map<String, dynamic> json) => AllClassificationsModel(
        data: List<Classification>.from(json["data"].map((x) => Classification.fromJson(x))),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class Classification {
    Classification({
        this.id,
        this.name,
        this.desc,
        this.adCount,
    });

    int id;
    String name;
    String desc;
    int adCount;

    factory Classification.fromJson(Map<String, dynamic> json) => Classification(
        id: json["id"],
        name: json["name"],
        desc: json["desc"],
        adCount: json["ad_count"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "desc": desc,
        "ad_count": adCount,
    };
}
