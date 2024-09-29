import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/core/models/user_model.dart';

class CurrentUserProvider extends Notifier<UserModel?> {
  @override
  UserModel? build() {
    return null;
  }

  void addUser(UserModel user) {
    state = user;
  }
}

final currentUserProvider =
    NotifierProvider<CurrentUserProvider, UserModel?>(CurrentUserProvider.new);
