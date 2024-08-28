// ignore_for_file: public_member_api_docs, sort_constructors_first
class LoginRequestModel {
  final String email;
  final String password;
  String name;
  String photoUrl;
  bool isGoogle;

  LoginRequestModel(this.email, this.password,
      {this.name = "", this.photoUrl = "", this.isGoogle = false});
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'password': password,
    };
  }

  LoginRequestModel copyWith({
    String? email,
    String? password,
    String? name,
    String? photoUrl,
    bool? isGoogle,
  }) {
    return LoginRequestModel(
      email ?? this.email,
      password ?? this.password,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      isGoogle: isGoogle ?? this.isGoogle,
    );
  }
}
