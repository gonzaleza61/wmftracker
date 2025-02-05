import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/http_exception.dart';
import 'dart:async';

import './weight_info.dart';

class UserWeightInfo with ChangeNotifier {
  UserWeightInfo(this._authToken, this._userId, this._preMadeList);

  List<WeightInfo> _preMadeList = [
    WeightInfo(fbID: 'test', weightNum: 12, weightDate: DateTime.now())
  ];

  final String _authToken;
  final String _userId;

  List<WeightInfo> get preMadeList {
    return [..._preMadeList];
  }

  Future<void> addWeight(WeightInfo weightInfo) async {
    var url = Uri.parse(
        'https://wmf-weight-tracker-default-rtdb.firebaseio.com/userweightinfo/$_userId/weightdata.json?auth=$_authToken');

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'weight': weightInfo.weightNum,
            'date': weightInfo.weightDate.toIso8601String()
          },
        ),
      );
      final newWeight = WeightInfo(
        fbID: json.decode(response.body)['name'],
        weightNum: weightInfo.weightNum,
        weightDate: weightInfo.weightDate,
      );
      _preMadeList.add(newWeight);
    } catch (error) {
      rethrow;
    }

    notifyListeners();
  }

  Future<void> fetchWeight() async {
    var url = Uri.parse(
        'https://wmf-weight-tracker-default-rtdb.firebaseio.com/userweightinfo/$_userId/weightdata.json?auth=$_authToken');

    try {
      final response = await http.get(url);
      final extractWeightData =
          json.decode(response.body) as Map<String, dynamic>;
      print(extractWeightData);
      final List<WeightInfo> loadedWeight = [];
      extractWeightData.forEach((fbID, value) {
        loadedWeight.add(
          WeightInfo(
            fbID: fbID,
            weightNum: value['weight'],
            weightDate: DateTime.parse(value['date']),
          ),
        );
      });
      _preMadeList = loadedWeight;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
