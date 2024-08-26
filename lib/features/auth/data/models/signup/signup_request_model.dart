class SignUpRequestModel {
  final String name;

  final String email;

  final String password;

  SignUpRequestModel(this.email, this.password, this.name);
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
