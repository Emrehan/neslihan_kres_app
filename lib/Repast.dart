import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum RepastType { BREAKFAST, LUNCH, DINNER }

class Repast {
  String title;
  IconData icon;

  Repast(this.title, this.icon);

  static Repast getRepast(RepastType rt) {
    switch (rt) {
      case RepastType.BREAKFAST:
        return Repast("Kahvaltı", Icons.wb_sunny_outlined);
      case RepastType.LUNCH:
        return Repast("Öğle Yemeği", Icons.dinner_dining);
      case RepastType.DINNER:
        return Repast("İkindi Kahvaltısı", Icons.free_breakfast_outlined);
    }
  }
}
