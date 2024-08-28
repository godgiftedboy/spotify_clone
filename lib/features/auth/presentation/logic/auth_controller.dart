import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/core/app_error.dart';
import 'package:spotify/core/db_client.dart';
import 'package:spotify/core/firebase_auth/auth_services.dart';
import 'package:spotify/core/providers/current_user_provider.dart';
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
    if (result.isEmpty) {
      state = const AuthState.loggedOut();
    } else {
      state = const AuthState.loggedIn();
      getUserData();
    }
  }

  getUserData() async {
    final response = await ref.read(dbClientProvider).getAuthData();
    ref.read(currentUserProvider.notifier).addUser(response);
  }

  Future<LoginResponseModel> login(
    LoginRequestModel loginRequestData,
  ) async {
    state = const AuthState.loading();

    if (loginRequestData.isGoogle) {
      //signup using gmail google data to store it in the database
      // try {
      final response = await authRepository.signup(
        SignUpRequestModel(
          loginRequestData.email,
          loginRequestData.password,
          loginRequestData.name,
        ),
      );
      return response.fold((l) async {
        if (l.message == "User with the same email already exists!") {
          return await login(loginRequestData.copyWith(isGoogle: false));
        } else {
          throw l.message;
        }
      }, (r) async {
        return await login(loginRequestData.copyWith(isGoogle: false));
      });
      // } catch (e) {
      //   print("here is the error: ${e}");
      // }
    } else {
      final result = await authRepository.login(loginRequestData);

      return result.fold(
        (l) => _loginFailure(l),
        (r) => _loginSucess(
            r.copyWith(photoUrl: loginRequestData.photoUrl), loginRequestData),
      );
    }
  }

  _loginFailure(AppError l) {
    state = const AuthState.loggedOut();
    return LoginResponseModel(
      isSuccess: false,
      message: l.message,
    );
  }

  _loginSucess(UserModel r, LoginRequestModel loginReqData) {
    dbClient.setAuthData(jsonData: r.toJson());
    ref.read(currentUserProvider.notifier).addUser(r);

    dbClient.setData(
      dataType: LocalDataType.string,
      dbKey: "token",
      value: r.token,
    );
    state = const AuthState.loggedIn();
    return LoginResponseModel(
      isSuccess: true,
      data: r,
      isGoogle: loginReqData.isGoogle,
      photoUrl: loginReqData.photoUrl,
    );
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
    await ref.read(authServicesProvider).googleSignOut();
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
