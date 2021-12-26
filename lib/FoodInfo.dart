import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neslihan_kres/Repast.dart';

class FoodInfo {
  String breakfast = "";
  String lunch = "";
  String dinner = "";
  String info = "";
  DateTime date;
  bool valid = true;

  FoodInfo(this.breakfast, this.lunch, this.dinner, this.date, this.info);

  FoodInfo.valid(bool valid) {
    this.valid = valid;
  }

  FoodInfo.onlyInfo(String info) {
    this.valid = true;
    this.info = info;
  }

  Widget getWidget(RepastType repastType) {
    var repast = Repast.getRepast(repastType);
    String content;
    switch (repastType) {
      case RepastType.BREAKFAST:
        content = breakfast;
        break;
      case RepastType.LUNCH:
        content = lunch;
        break;
      case RepastType.DINNER:
        content = dinner;
        break;
    }
    content = utf8.decode(content.codeUnits);

    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                repast.icon,
                size: 32,
                color: Colors.blueAccent,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                repast.title,
                style: TextStyle(fontSize: 32, color: Colors.blueAccent),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            content,
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }
}
