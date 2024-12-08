import 'dart:ffi';

import 'package:flutter/material.dart';

class Account {
  String? id;
  String? email;
  String? contact;
  String? image;
  Int? balance;
  Int? loans;
  Int? civilID;
  Int? UserID;

  Account({
    this.email,
    this.contact,
    this.image,
    this.balance,
    this.loans,
    this.civilID,
    this.UserID,
  });

  Account.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        email = json['email'] as String,
        contact = json['contact'] as String,
        image = json['image'] as String,
        balance = json['balance'] as Int,
        loans = json['loans'] as Int,
        civilID = json['civilID'] as Int,
        UserID = json['UserID'] as Int;

  // Map<String, dynamic> toJson() {
  //   return <String, dynamic>{'username': username, 'password': password};
  // }
}
