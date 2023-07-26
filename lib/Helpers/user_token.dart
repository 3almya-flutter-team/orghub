import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> headersMap() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  Map<String, dynamic> headersData = {
    'Authorization': preferences.getString("token"),
    "lang": translator.currentLanguage,
    "Content-Type":"application/json"
  };
  return headersData;
}


Future<Map<String, dynamic>> headersMapWithoutToken() async {
 // SharedPreferences preferences = await SharedPreferences.getInstance();
  Map<String, dynamic> headersData = {
   // 'Authorization': preferences.getString("token"),
    "lang": translator.currentLanguage,
    "Content-Type":"application/json"
  };
  return headersData;
}

