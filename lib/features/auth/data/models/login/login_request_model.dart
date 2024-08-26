class LoginRequestModel {
  final String email;
  final String password;

  LoginRequestModel(this.email, this.password);
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'password': password,
    };
  }
}
