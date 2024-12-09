// class Account {
//   String? id;
//   String email;
//   String? contact;
//   String? image;
//   double? balance;
//   double? loans;
//   double? debt;
//   String? civilId;
//   String? UserID;

//   Account({
//     required this.email,
//     this.contact,
//     this.image,
//     this.balance,
//     this.loans,
//     this.debt,
//     this.civilId,
//     this.UserID,
//   });

//   Account.fromJson(Map<String, dynamic> json)
//       : id = json['_id'] as String?,
//         email = json['email'] as String,
//         contact = json['contact'] as String?,
//         image = json['image'] as String?,
//         balance = (json['balance'] as num?)?.toDouble(),
//         loans = (json['loans'] as num?)?.toDouble(),
//         debt = (json['debts'] as num?)?.toDouble(),
//         civilId = json['civilId'] as String?,
//         UserID = json['UserId'] as String?;
// }
