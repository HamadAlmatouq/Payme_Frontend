class User {
  final String id;
  final String username;
  final String email;
  final String contact;
  final String civilId;
  double balance;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.contact,
    required this.civilId,
    required this.balance,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      contact: json['contact'],
      civilId: json['civilId'],
      balance: json['balance'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'contact': contact,
      'civilId': civilId,
      'balance': balance,
    };
  }
}
