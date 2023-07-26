import 'package:flutter/cupertino.dart';

Widget noInternetWidget(BuildContext context) {
  return Center(
    child: Container(
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        children: [
          Image.asset("assets/icons/no-connection.png"),
          SizedBox(
            height: 10,
          ),
          Text(
            "برجاء التاكد من الاتصال بالانترنت",
            style: TextStyle(
              fontSize: 13,
            ),
          ),
        ],
      ),
    ),
  );
}
