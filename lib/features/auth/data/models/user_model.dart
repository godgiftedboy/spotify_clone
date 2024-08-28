// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserModel {
  final String name;
  final String email;
  final String id;
  final String token;
  String photoUrl;

  UserModel(
      {required this.name,
      required this.email,
      required this.id,
      required this.token,
      this.photoUrl = ""});

  UserModel copyWith({
    String? name,
    String? email,
    String? id,
    String? token,
    String? photoUrl,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
      token: token ?? this.token,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'id': id,
      'token': token,
      'photoUrl': photoUrl,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      id: map['id'] ?? '',
      token: map['token'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, id: $id, token: $token,photoUrl: $photoUrl)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.id == id &&
        other.token == token &&
        other.photoUrl == photoUrl;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        id.hashCode ^
        token.hashCode ^
        photoUrl.hashCode;
  }
}
