import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/features/auth/data/models/user_model.dart';

enum LocalDataType { boolean, integer, string }

final dbClientProvider = Provider<DbClient>((ref) => DbClient());

class DbClient {
  late SharedPreferences prefs;
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  setAuthData({required Map<String, dynamic> jsonData}) async {
    //     final prefs = await SharedPreferences.getInstance();

    var data = jsonEncode(jsonData);
    prefs.setString("auth", data);
  }

  Future<UserModel> getAuthData() async {
    //     final prefs = await SharedPreferesnces.getInstance();

    String authData = prefs.getString("auth") ?? jsonEncode({});
    var data = UserModel.fromJson(jsonDecode(authData));

    return data;
  }

  setData(
      {required LocalDataType dataType,
      required String dbKey,
      required var value}) async {
    //     final prefs = await SharedPreferences.getInstance();

    dataType == LocalDataType.boolean
        ? prefs.setBool(dbKey, value)
        : dataType == LocalDataType.integer
            ? prefs.setInt(dbKey, value)
            : prefs.setString(dbKey, value);
  }

  getData({required LocalDataType dataType, required String dbKey}) async {
    //     final prefs = await SharedPreferences.getInstance();

    final result = dataType == LocalDataType.boolean
        ? prefs.getBool(dbKey) ?? false
        : dataType == LocalDataType.integer
            ? prefs.getInt(dbKey) ?? 0
            : prefs.getString(dbKey) ?? "";
    return result;
  }

  removeData({required String dbKey}) async {
    //    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(dbKey);
  }

  reset() async {
    //     final prefs = await SharedPreferences.getInstance();

    prefs.clear();
  }
}
