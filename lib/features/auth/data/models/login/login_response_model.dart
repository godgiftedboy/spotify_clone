import 'package:spotify/features/auth/data/models/user_model.dart';

class LoginResponseModel {
  final bool isSuccess;
  final String message;
  final UserModel? data;

  LoginResponseModel({
    required this.isSuccess,
    this.message = "",
    this.data,
  });
}
