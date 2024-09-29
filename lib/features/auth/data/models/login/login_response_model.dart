import 'package:spotify/core/models/user_model.dart';

class LoginResponseModel {
  final bool isSuccess;
  final String message;
  final UserModel? data;
  bool isGoogle;
  String photoUrl;

  LoginResponseModel({
    required this.isSuccess,
    this.message = "",
    this.data,
    this.isGoogle = false,
    this.photoUrl = "",
  });
}
