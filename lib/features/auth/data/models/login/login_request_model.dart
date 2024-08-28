class LoginRequestModel {
  final String email;
  final String password;
  String name;
  String photoUrl;

  LoginRequestModel(this.email, this.password,
      {this.name = "", this.photoUrl = ""});
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'password': password,
    };
  }
}
