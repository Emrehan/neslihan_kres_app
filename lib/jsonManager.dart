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

      FoodInfo foodInfo = FoodInfo();

      if (json.containsKey("breakfast")) foodInfo.breakfast = json['breakfast'];

      if (json.containsKey("lunch")) foodInfo.lunch = json['lunch'];

      if (json.containsKey("dinner")) foodInfo.dinner = json['dinner'];

      if (json.containsKey("info")) foodInfo.info = json['info'];

      return foodInfo;
    } on Exception {
      return null;
    }
  }
}
