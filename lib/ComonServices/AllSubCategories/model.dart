



// // To parse this JSON data, do
// //
// //     final allCategoriesModel = allCategoriesModelFromJson(jsonString);

// import 'dart:convert';

// AllCategoriesModel allCategoriesModelFromJson(String str) => AllCategoriesModel.fromJson(json.decode(str));

// String allCategoriesModelToJson(AllCategoriesModel data) => json.encode(data.toJson());

// class AllCategoriesModel {
//     AllCategoriesModel({
//         this.allCategories,
//         this.status,
//         this.message,
//     });

//     List<CategoryData> allCategories;
//     String status;
//     String message;

//     factory AllCategoriesModel.fromJson(Map<String, dynamic> json) => AllCategoriesModel(
//         allCategories: List<CategoryData>.from(json["data"].map((x) => CategoryData.fromJson(x))),
//         status: json["status"],
//         message: json["message"],
//     );

//     Map<String, dynamic> toJson() => {
//         "data": List<dynamic>.from(allCategories.map((x) => x.toJson())),
//         "status": status,
//         "message": message,
//     };
// }

// class CategoryData {
//     CategoryData({
//         this.id,
//         this.name,
//         this.image,
//     });

//     int id;
//     String name;
//     String image;

//     factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
//         id: json["id"],
//         name: json["name"],
//         image: json["image"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "image": image,
//     };
// }