import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/core/api_client.dart';
import 'package:spotify/core/api_const.dart';
import 'package:spotify/core/api_method_enum.dart';
import 'package:spotify/features/auth/data/models/login/login_request_model.dart';
import 'package:spotify/features/auth/data/models/signup/signup_request_model.dart';
import 'package:spotify/core/models/user_model.dart';

final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  return AuthDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
  );
});

abstract class AuthDataSource {
  Future<UserModel> loginDs(LoginRequestModel loginRequestData);
  Future<UserModel> signupDs(SignUpRequestModel signupRequestData);
  Future<UserModel> getCurrentUserDs(String token);
}

class AuthDataSourceImpl implements AuthDataSource {
  final ApiClient apiClient;

  AuthDataSourceImpl({required this.apiClient});
  @override
  Future<UserModel> loginDs(LoginRequestModel loginRequestData) async {
    final result = await apiClient.request(
      path: ApiConst.login,
      data: loginRequestData.toJson(),
      type: ApiMethod.post,
    );
    return UserModel.fromJson(result['user']).copyWith(token: result['token']);
//     {
//     "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImMwNjc4MTc5LTcwM2EtNDVlOS05ZWJkLTBlODYzZWFmMDFhZiJ9.MhLVndJy2zU3wU-KueikA2QjNA9oXAfm5sspEhnAFe0",
//     "user": {
//         "email": "email@gmail.com",
//         "name": "raj",
//         "password": "$2b$12$qW/.KgDpvdGXm9WcHSSaZ.vhagePcJag7yLD4fpeMfG3oniMTVGwu",
//         "id": "c0678179-703a-45e9-9ebd-0e863eaf01af"
//     }
//     }
  }

  @override
  Future<UserModel> signupDs(SignUpRequestModel signupRequestData) async {
    final result = await apiClient.request(
      path: ApiConst.signup,
      type: ApiMethod.post,
      data: signupRequestData.toJson(),
    );
    return UserModel.fromJson(result ?? {});

    // {
    // "email": "email@gmail.com",
    // "name": "raj",
    // "password": "$2b$12$pfpLC63lGxZwgmh7Isn5aOaDyQr.I74NcxDHIrwtCrMgVwGL.PdjG",
    // "id": "56f8356d-f24f-48c4-b410-66d425a775e3"
    // }
  }

  @override
  Future<UserModel> getCurrentUserDs(String token) async {
    final result = await apiClient.request(
      path: ApiConst.getuser,
      type: ApiMethod.get,
      token: token,
    );
    return UserModel.fromJson(result ?? {}).copyWith(token: token);
  }
}
