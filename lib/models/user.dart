class User {
  String? id;
  String username;
  String? password;

  User({
    this.id,
    required this.username,
    this.password,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        username = json['username'] as String,
        password = json['password'] as String;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'username': username, 'password': password};
  }
}
