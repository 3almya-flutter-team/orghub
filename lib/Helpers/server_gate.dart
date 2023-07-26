import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:quick_log/quick_log.dart';

const String BASE_URL = "https://org.taha.elsa3a.com/api";
// const String BASE_URL = "https://orghub.store/api";

class ServerGate {
  Dio dio = Dio();
  Logger log = Logger('--------- Server Gate Logger -------- ');

  void addInterceptors() {
    dio.interceptors.add(CustomApiInterceptor());
  }

  // ------- POST DATA TO SERVER -------//
  Future<CustomResponse> sendToServer({
    @required String url,
    Map<String, dynamic> headers,
    Map<String, dynamic> body,
  }) async {
    // remove nulls from body
    if (body != null) {
      body.removeWhere(
        (key, value) => body[key] == null || body[key] == "",
      );
    }

    try {
      Response response = await dio.post(
        "$BASE_URL/$url",
        data: FormData.fromMap(body),
        options: Options(
          headers: headers,
        ),
      );

      return CustomResponse(
        success: true,
        statusCode: 200,
        errType: null,
        error: null,
        msg: "Your request completed succesfully",
        response: response,
      );
    } on DioError catch (err) {
      return handleServerError(err);
    }
  }

  // ------ GET DATA FROM SERVER -------//
  Future<CustomResponse> getFromServer({
    @required String url,
    Map<String, dynamic> headers,
    Map<String, dynamic> params,
  }) async {
    
    try {
      if (params != null) {
        params.removeWhere(
          (key, value) => params[key] == null || params[key] == "",
        );
      }

      print("=-=-=> ${params.toString()}");

      Response response = await dio.get(
        "$BASE_URL/$url",
        options: Options(
          headers: headers,
        ),
        queryParameters: params,
      );

      return CustomResponse(
        success: true,
        statusCode: 200,
        errType: null,
        error: null,
        msg: "Your request completed succesfully",
        response: response,
      );
    } on DioError catch (err) {
      return handleServerError(err);
    }
  }

  // ------ Download DATA FROM SERVER -------//
  Future<CustomResponse> downloadFromServer({
    @required String url,
    @required String path,
    Map<String, dynamic> headers,
    Map<String, dynamic> params,
  }) async {
    try {
      CancelToken cancelToken = CancelToken();
      Response response = await dio.download(url, path,
          cancelToken: cancelToken, onReceiveProgress: (received, total) {
        print((received / total * 100).toStringAsFixed(0) + "%");
      });

      print("response from download =-=-=> ${response.data.toString()}");

      return CustomResponse(
        success: true,
        statusCode: 200,
        errType: null,
        error: null,
        msg: "Your request completed succesfully",
        response: response,
      );
    } on DioError catch (err) {
      return handleServerError(err);
    }
  }

  // -------- HANDLE ERROR ---------//
  CustomResponse handleServerError(DioError err) {
    if (err.type == DioErrorType.RESPONSE) {
      print("=-=-=-= ERROR FROM THE SERVER =-=-=-=-=");
      log.error(err.response.data.toString());
      // Get.snackbar("Register Error", err.response.data.toString());
      // throw SocketException("");
      return CustomResponse(
        success: false,
        statusCode: err.response.statusCode,
        errType: 1,
        msg: "Please cheack these errors and try again.",
        error: err.response.data,
        response: null,
      );
    } else if (err.type == DioErrorType.DEFAULT &&
        err.error != null &&
        err.error is SocketException) {
      // PLEASE CHECK YOUR NETWORK CONNECTION .
      return CustomResponse(
        success: false,
        // statusCode: err.response.statusCode,
        errType: 0,
        msg: "Please Check Your network Connection.",
        error: null,
        response: null,
      );
    } else if (err.type == DioErrorType.DEFAULT) {
      print("xcxcxcxcxcxcxcxcxcxcxcxcxcxcx");
      print("print error =>>> ${err.error}");
      print("print error =>>> ${err.message}");
      return CustomResponse(
        success: false,
        statusCode: err.response.statusCode,
        errType: 2,
        msg: "Server Error, Please try again later.",
        error: null,
        response: null,
      );
    } else {
      return CustomResponse(
        success: false,
        statusCode: err.response.statusCode,
        errType: 2,
        msg: "Server Error, Please try again later.",
        error: null,
        response: null,
      );
    }
  }
}

class CustomApiInterceptor extends Interceptor {
  Logger log = Logger('--------- Server Gate Logger -------- ');
  @override
  Future onError(DioError err) {
    // CURRENT ERROR
    log.warning("error type");
    log.error(err.type.toString());
    // log.warning("err.response.data");
    // log.error(err.response.data);
    // log.warning("err.response.statusCode");
    // log.error(err.response.statusCode.toString());
    // log.warning("err.message");
    // log.error(err.message);
    // log.warning("err.error");
    // log.error(err.error.toString());
    // log.warning("Sending Path");
    // log.error(err.request.path.toString());
    // log.warning("Sending Data");
    // log.error(err.request.data.toString());
    // log.warning("Sending Headers");
    // log.error(err.request.headers.toString());

    /// When the server response, but with a incorrect status, such as 404, 503...
    // DioErrorType.RESPONSE

    // if (err.type == DioErrorType.RESPONSE) {
    //   print("=-=-=-= ERROR FROM THE SERVER =-=-=-=-=");
    //   log.error(err.response.data);
    //   // Get.snackbar("Register Error", err.response.data.toString());
    //   // throw SocketException("");
    //   return err.response.data;
    // } else if (err.type == DioErrorType.DEFAULT &&
    //     err.error != null &&
    //     err.error is SocketException) {
    //   // PLEASE CHECK YOUR NETWORK CONNECTION .
    //   return null;
    // }

    // AUTHENTICATION ERROR   [401 Unauthorized]

    // 422 REQUEST BODY MISSED REQUIRED FIELD  [422 Unprocessable Entity]

    // DioErrorType.CANCEL
    // DioErrorType.CONNECT_TIMEOUT

    /// Default error type, Some other Error. In this case, you can
    /// use the DioError.error if it is not null.
    // DioErrorType.DEFAULT   => [PRINT DIOERROR.ERROR]

    // DioErrorType.RECEIVE_TIMEOUT
    // DioErrorType.SEND_TIMEOUT

    // Some errors occured with a response from the server
    // here we can show the error to the user

    // SERVER ERROR

    // REQUEST DATA ERROR OR MISSING DATA

    // NETWORK ERROR

    return super.onError(err);
  }

  @override
  Future onResponse(Response response) {
    // CURRENT RESPONSE
    log.debug("------ Current Response -----");
    log.fine(response.data.toString());
    return super.onResponse(response);
  }

  @override
  Future onRequest(RequestOptions options) {
    // CURRENT REQUEST
    log.debug("------ Current Request Data -----");
    log.fine(options.data.toString());
    log.debug("------ Current Request Headers -----");
    log.fine(options.headers.toString());
    log.debug("------ Current Request Path -----");
    log.fine(options.path.toString());
    return super.onRequest(options);
  }
}

class CustomResponse {
  bool success;
  int errType;
  // 0 => network error
  // 1 => error from the server
  // 2 => other error
  String msg;
  int statusCode;
  Response response;
  dynamic error;

  CustomResponse({
    this.success,
    this.errType,
    this.msg,
    this.statusCode,
    this.response,
    this.error,
  });
}

class CustomError {
  int type;
  String msg;
  dynamic error;

  CustomError({
    this.type,
    this.msg,
    this.error,
  });
}
