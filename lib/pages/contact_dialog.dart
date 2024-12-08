// import 'package:flutter/material.dart';

// class ContactDialog extends StatelessWidget {
//   final Map<String, dynamic> contact;
//   final Function(BuildContext context, String title, String action) onLoanAction;

//   const ContactDialog({
//     Key? key,
//     required this.contact,
//     required this.onLoanAction,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       title: Row(
//         children: [
//           CircleAvatar(
//             radius: 25,
//             backgroundImage: AssetImage(contact["image"]),
//           ),
//           const SizedBox(width: 10),
//           Text(contact["name"]),
//         ],
//       ),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Rating
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.star, color: Colors.amber, size: 20),
//               Text("${contact["rating"]}"),
//             ],
//           ),
//           const SizedBox(height: 20),

//           // Borrow and Lend Buttons
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context); // Close dialog
//                   onLoanAction(
//                     context,
//                     "Borrow from ${contact["name"]}",
//                     "Borrow",
//                   );
//                 },
//                 child: const Text("Borrow"),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context); // Close dialog
//                   onLoanAction(
//                     context,
//                     "Lend to ${contact["name"]}",
//                     "Lend",
//                   );
//                 },
//                 child: const Text("Lend"),
//               ),
//             ],
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.pop(context); // Close dialog
//           },
//           child: const Text("Close"),
//         ),
//       ],
//     );
//   }
// }