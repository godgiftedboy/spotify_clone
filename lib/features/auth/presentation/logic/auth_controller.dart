import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/core/app_error.dart';
import 'package:spotify/core/db_client.dart';
import 'package:spotify/core/utils.dart';
import 'package:spotify/features/auth/data/models/login/login_request_model.dart';
import 'package:spotify/features/auth/data/models/login/login_response_model.dart';
import 'package:spotify/features/auth/data/models/signup/signup_request_model.dart';
import 'package:spotify/features/auth/data/models/user_model.dart';
import 'package:spotify/features/auth/data/repository/auth_repository.dart';
import 'package:spotify/features/auth/presentation/logic/auth_state.dart';
import 'package:spotify/features/auth/presentation/views/screens/login_page.dart';

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);

class AuthController extends Notifier<AuthState> {
  late AuthRepository authRepository;
  late DbClient dbClient;

  @override
  AuthState build() {
    authRepository = ref.watch(authRepositoryProvider);
    dbClient = ref.watch(dbClientProvider);
    // state = AsyncValue.data(AuthState.loading());
    return const AuthState.loading();
  }

  Future<void> initSharedPreferences() async {
    await dbClient.init();
  }

  Future<void> checkLogin() async {
    final result =
        await dbClient.getData(dataType: LocalDataType.string, dbKey: "token");

    result.isEmpty
        ? state = const AuthState.loggedOut()
        : state = const AuthState.loggedIn();
    // return result;
  }

  Future<LoginResponseModel> login(LoginRequestModel loginRequestData) async {
    state = const AuthState.loading();

    final result = await authRepository.login(loginRequestData);

    return result.fold(
      (l) => _loginFailure(l),
      (r) => _loginSucess(r),
    );
  }

  _loginFailure(AppError l) {
    state = const AuthState.loggedOut();
    return LoginResponseModel(
      isSuccess: false,
      message: l.message,
    );
  }

  _loginSucess(UserModel r) {
    dbClient.setAuthData(jsonData: r.toJson());
    dbClient.setData(
      dataType: LocalDataType.string,
      dbKey: "token",
      value: r.token,
    );
    state = const AuthState.loggedIn();
    return LoginResponseModel(isSuccess: true, data: r);
  }

  Future<LoginResponseModel> signup(
      SignUpRequestModel signupRequestData) async {
    state = const AuthState.loading();

    final result = await authRepository.signup(signupRequestData);
    return result.fold(
      (l) => _signupFailure(l),
      (r) => _signupSuccess(r),
    );
  }

  _signupFailure(AppError l) {
    state = const AuthState.loggedOut();
    return LoginResponseModel(
      isSuccess: false,
      message: l.message,
    );
  }

  _signupSuccess(UserModel r) {
    state = const AuthState.loggedOut();
    return LoginResponseModel(isSuccess: true, data: r);
  }

  Future<void> logout(BuildContext context) async {
    await dbClient.reset();
    state = const AuthState.loggedOut();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (_) => false,
      );
      showSnackBar(context, "Logged Out Succesfully");
    }
  }
}
