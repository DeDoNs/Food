class User {
  int user_id;
  String user_login;
  String user_password;
  String user_email;

  User(
    this.user_id,
    this.user_login,
    this.user_password,
    this.user_email,
  );

  factory User.fromJson(Map<String, dynamic> json) => User(
        int.parse(json["user_id"]),
        json["user_login"],
        json["user_password"],
        json["user_email"],
      );

  Map<String, dynamic> toJson() => {
        'user_id': user_id.toString(),
        'user_login': user_login,
        'user_password': user_password,
        'user_email': user_email,
      };
}
