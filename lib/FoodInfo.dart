import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neslihan_kres/Repast.dart';

import 'main.dart';

class FoodInfo {
  String breakfast;
  String lunch;
  String dinner;
  String info;
  DateTime date;

  FoodInfo({this.breakfast, this.lunch, this.dinner, this.date, this.info}) {
    breakfast = "";
    lunch = "";
    dinner = "";
    info = "";
    date = DateTime.now();
  }

  Widget getWidget(BuildContext context, RepastType repastType) {
    var repast = Repast.getRepast(repastType);
    String content = "";
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
    content = content.isEmpty
        ? "Öğün bilgisi mevcut değil."
        : utf8.decode(content.codeUnits);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: MyHomePage.foodBackground,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    color: MyHomePage.backColor,
                    child: Icon(
                      repast.icon,
                      color: MyHomePage.textTextColor,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      repast.title,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: MyHomePage.textTextColor,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                        content,
                        overflow: TextOverflow.clip,
                        maxLines: 3,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 16,
                          color: MyHomePage.textTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
