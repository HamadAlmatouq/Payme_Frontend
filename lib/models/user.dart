class User {
  final String id;
  final String username;
  // final String email;
  final String contact;
  final String civilId;
  double balance;
  final String toUsername;
  final DateTime installmentFrequency;
  double amount;
  int duration;

  User({
    required this.id,
    required this.username,
    // required this.email,
    required this.contact,
    required this.civilId,
    required this.balance,
    required this.toUsername,
    required this.installmentFrequency,
    required this.amount,
    required this.duration
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      // email: json['email'],
      contact: json['contact'],
      civilId: json['civilId'],
      balance: json['balance'] ?? 0.0,
      toUsername: json['toUsername'],
      installmentFrequency: json['installmentFrequency'],
      amount: json['amount'],
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      // 'email': email,
      'contact': contact,
      'civilId': civilId,
      'balance': balance,
      'toUsername': toUsername,
      'installmentFrequency': installmentFrequency,
      'amount': amount,
      'duration': duration,
    };
  }
}
