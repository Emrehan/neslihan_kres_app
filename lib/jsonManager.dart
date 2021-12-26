import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'FoodInfo.dart';

class JsonManager {
  static Future<FoodInfo> getFoodListByDate(DateTime dt) async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(dt);
    final String url = "https://www.harikalardiyarineslihan.com/yemek_listesi/";

    try {
      var result = await http.read(url + formatted);
      Map<String, dynamic> json = jsonDecode(result);

      if (json.containsKey("breakfast") &&
          json.containsKey("lunch") &&
          json.containsKey("dinner")) {
        String info = "";
        if (json.containsKey("info")) {
          info = json["info"];
        }

        return FoodInfo(
            json['breakfast'], json['lunch'], json['dinner'], dt, info);
      } else if (json.containsKey("info")) {
        return FoodInfo.onlyInfo(json["info"]);
      } else {
        return FoodInfo.valid(false);
      }
    } on Exception {
      return FoodInfo.valid(false);
    }
  }
}
