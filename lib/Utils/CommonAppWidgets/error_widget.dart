import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:orghub/Screens/Auth/CheckUserAuth/init_app_bloc.dart';
import 'package:orghub/Screens/Splash/view.dart';

Widget errorWidget(BuildContext context, String msg, dynamic statusCode) {
  return Center(
    child: Container(
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        children: [
          Image.asset("assets/icons/error.png"),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              if (statusCode == 401) {
                Get.to(
                  BlocProvider(
                    create: (_) => AppInitBloc(),
                    child: SplashView(),
                  ),
                );
              }
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: AutoSizeText(
                  msg ?? "يوجد خطا بالسيرفر الرجاء المحاوله فى وقت لاحق",
                  maxLines: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
