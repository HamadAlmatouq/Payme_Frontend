import 'dart:ffi';

class Account {
  String? id;
  String? email;
  String? contact;
  String? image;
  String? balance;
  String? loans;
  String? debt;
  String? civilId;
  String? UserID;

  Account({
    this.email,
    this.contact,
    this.image,
    this.balance,
    this.loans,
    this.debt,
    this.civilId,
    this.UserID,
  });

  Account.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        email = json['email'] as String,
        contact = json['contact'] as String,
        image = json['image'] as String,
        balance = json['balance'] as String,
        loans = json['loans'] as String,
        civilId = json['civilId'] as String,
        UserID = json['UserID'] as String;

  // Map<String, dynamic> toJson() {
  //   return <String, dynamic>{'username': username, 'password': password};
  // }
}
