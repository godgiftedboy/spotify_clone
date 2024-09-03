import 'dart:io';

class ApiConst {
  static String baseUrl =
      Platform.isAndroid ? 'http://10.0.2.2:8000' : 'http://127.0.0.1:8000';
  static const login = '/auth/login';
  static const signup = '/auth/signup';
  static const uploadSong = '/song/upload';
}
