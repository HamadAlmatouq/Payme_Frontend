import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy notifications
    final List<String> notifications = [
      "Loan request approved!",
      "Hamad has sent you 500 KWD.",
      "Reminder: Installment due tomorrow.",
      "Yousef declined your loan request.",
      "Reem has completed their payment."
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.notifications, color: Colors.blueAccent),
            title: Text(
              notifications[index],
              style: const TextStyle(fontSize: 16),
            ),
          );
        },
      ),
    );
  }
}