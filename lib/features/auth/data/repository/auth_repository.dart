import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:spotify/core/app_error.dart';
import 'package:spotify/core/exception_handle.dart';
import 'package:spotify/features/auth/data/data_source/auth_data_source.dart';
import 'package:spotify/features/auth/data/models/login/login_request_model.dart';
import 'package:spotify/features/auth/data/models/signup/signup_request_model.dart';
import 'package:spotify/core/models/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(authDataSourceProvider));
});

abstract class AuthRepository {
  Future<Either<AppError, UserModel>> login(LoginRequestModel loginRequestData);
  Future<Either<AppError, UserModel>> signup(
      SignUpRequestModel signupRequestData);
  Future<Either<AppError, UserModel>> getCurrentUser(String token);
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;
  AuthRepositoryImpl(this._authDataSource);

  @override
  Future<Either<AppError, UserModel>> login(
      LoginRequestModel loginRequestData) async {
    try {
      final result = await _authDataSource.loginDs(loginRequestData);

      return Right(result);
    } on DioExceptionHandle catch (e) {
      return Left(AppError(e.message!));
    }
  }

  @override
  Future<Either<AppError, UserModel>> signup(
      SignUpRequestModel signupRequestData) async {
    try {
      final result = await _authDataSource.signupDs(signupRequestData);
      return Right(result);
    } on DioExceptionHandle catch (e) {
      return Left(AppError(e.message!));
    }
  }

  @override
  Future<Either<AppError, UserModel>> getCurrentUser(String token) async {
    try {
      final result = await _authDataSource.getCurrentUserDs(token);
      return Right(result);
    } on DioExceptionHandle catch (e) {
      return Left(AppError(e.message!));
    }
  }
}
