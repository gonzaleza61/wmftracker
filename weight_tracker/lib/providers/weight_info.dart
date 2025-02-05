import 'package:flutter/material.dart';

class WeightInfo with ChangeNotifier {
  //firebase generated ID
  final String? fbID;
  final int weightNum;
  final DateTime weightDate;

  WeightInfo(
      {required this.fbID, required this.weightNum, required this.weightDate});
}
