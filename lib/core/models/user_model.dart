// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:spotify/features/home/data/models/fav_song_model.dart';

class UserModel {
  final String name;
  final String email;
  final String id;
  final String token;
  String photoUrl;

  final List<FavSongModel> favorites;

  UserModel({
    required this.name,
    required this.email,
    required this.id,
    required this.token,
    this.photoUrl = "",
    required this.favorites,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? id,
    String? token,
    String? photoUrl,
    List<FavSongModel>? favorites,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
      token: token ?? this.token,
      photoUrl: photoUrl ?? this.photoUrl,
      favorites: favorites ?? this.favorites,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'id': id,
      'token': token,
      'photoUrl': photoUrl,
      'favorites': List<dynamic>.from(favorites.map((x) => x)),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
        name: map['name'] ?? '',
        email: map['email'] ?? '',
        id: map['id'] ?? '',
        token: map['token'] ?? '',
        photoUrl: map['photoUrl'] ?? '',
        favorites: List<FavSongModel>.from(
                (map['favorites'] ?? []).map((x) => FavSongModel.fromMap(x)))
            .toList());
  }

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, id: $id, token: $token,photoUrl: $photoUrl,favorites: $favorites)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.id == id &&
        other.token == token &&
        other.photoUrl == photoUrl &&
        other.favorites == favorites;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        id.hashCode ^
        token.hashCode ^
        photoUrl.hashCode ^
        favorites.hashCode;
  }
}
