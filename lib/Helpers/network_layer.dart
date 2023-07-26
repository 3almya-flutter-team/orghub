// import 'dart:convert';
// import 'package:dio/dio.dart';
// class NetWork {
//   Dio dio = Dio();

//   String baseUrl = 'http://mzadphone.com/api/';

//   Future<dynamic> getData(
//       {String url, List<Map<String, dynamic>> headers}) async {
//     var jsonResponse;
//     dio.options.baseUrl = baseUrl;

//     headers != null ? dio.options.headers = headers[0] : '';

//     Response response = await dio.get('$url').catchError((err) {});
//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       jsonResponse = json.decode(response.toString());
//       return jsonResponse;
//     } else if (response == null) {
//       return response;
//     } else {
//       return response;
//     }
//   }

//   Future<dynamic> postData(
//       {FormData formData, Map<String, dynamic> headers, String url}) async {
//     try {
//       dio.options.baseUrl = baseUrl;
//       headers != null ? dio.options.headers = headers : '';
//       var jsonResponse;
//       Response response = await dio.post(url, data: formData);
//       jsonResponse = json.decode(response.toString());
//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         jsonResponse = json.decode(response.toString());
//         return jsonResponse;
//       } else if (response == null) {
//         return response;
//       } else {
//         return response;
//       }
//     } on DioError catch (e) {
//       print("11111111111");
//       print(e.response.data);
//       print("2222");
//       print(e.response.headers);
//       print("33333333");
//       print(e.response.request);
//       return e.response.data;
//     }
//   }
// //  Future<dynamic> postData(
// //      {FormData formData, Map<String, dynamic> headers, String url}) async {
// //    dio.options.baseUrl = baseUrl;
// //    headers != null ? dio.options.headers = headers : '';
// //    var jsonResponse;
// //    Response response = await dio.post(url, data: formData);
// //    jsonResponse = json.decode(response.toString());
// //    if (response.statusCode >= 200 && response.statusCode < 300) {
// //      jsonResponse = json.decode(response.toString());
// //      return jsonResponse;
// //    } else if (response == null) {
// //      return response;
// //    } else {
// //      return response;
// //    }
// //  }
// }

// //class NetWork {
// //  Dio dio = Dio();
// //
// //  String baseUrl = 'http://easy.taha.rmal.com.sa/api/';
// //
// //  Future<dynamic> getData(
// //      {String url, List<Map<String, dynamic>> headers}) async {
// //    var jsonResponse;
// //    dio.options.baseUrl = baseUrl;
// //
// //    headers != null ? dio.options.headers = headers[0] : '';
// //
// //    Response response = await dio.get('$url').catchError((err) {});
// //    if (response.statusCode >= 200 && response.statusCode < 300) {
// //      jsonResponse = json.decode(response.toString());
// //      return jsonResponse;
// //    } else if (response == null) {
// //      return response;
// //    } else {
// //      return response;
// //    }
// //  }
// //
// //  Future<dynamic> postData(
// //      {FormData formData, Map<String, dynamic> headers, String url}) async {
// //    try {
// //      dio.options.baseUrl = baseUrl;
// //      headers != null ? dio.options.headers = headers : '';
// //      // var jsonResponse;
// //      Response response = await dio.post(url, data: formData);
// //      print(response.toString());
// //      // jsonResponse = json.decode(response.toString());
// //      // if (response.statusCode >= 200 && response.statusCode < 300) {
// //      // jsonResponse = json.decode(response.toString());
// //      return response;
// //      // } else if (response == null) {
// //      //   return response;
// //      // } else {
// //      //   return response;
// //      // }
// //    } on DioError catch (e) {
// //      print("I am here ${e.response.statusCode}");
// //      print("11111111111");
// //      print(e.response.data);
// //      print("2222");
// //      print(e.response.headers);
// //      print("33333333");
// //      print(e.response.request);
// //      return e.response;
// //    }
// //  }
// //}
