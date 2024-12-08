import 'package:flutter/material.dart';

class PaymentDialog extends StatelessWidget {
  final String name;
  final double amount;

  const PaymentDialog({Key? key, required this.name, required this.amount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController passwordController = TextEditingController();
    TextEditingController customAmountController = TextEditingController();
    bool selectAll = false;

    final List<Map<String, dynamic>> installments = [
      {"amount": 25.0, "date": "8 Dec 2024", "selected": false},
      {"amount": 25.0, "date": "8 Jan 2025", "selected": false},
      {"amount": 25.0, "date": "8 Feb 2025", "selected": false},
      {"amount": 25.0, "date": "8 Mar 2025", "selected": false},
      {"amount": 25.0, "date": "8 Apr 2025", "selected": false},
      {"amount": 25.0, "date": "8 May 2025", "selected": false},
    ];

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Select Payments:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                CheckboxListTile(
                  value: selectAll,
                  onChanged: (bool? value) {
                    setState(() {
                      selectAll = value!;
                      for (var installment in installments) {
                        installment["selected"] = selectAll;
                      }
                    });
                  },
                  title: const Text("All"),
                ),
                ...installments.map((installment) {
                  return CheckboxListTile(
                    value: installment["selected"],
                    onChanged: (bool? value) {
                      setState(() {
                        installment["selected"] = value!;
                        selectAll =
                            installments.every((i) => i["selected"] == true);
                      });
                    },
                    title: Text(
                      "${installment["amount"]} KWD",
                      style: const TextStyle(color: Colors.green),
                    ),
                    subtitle: Text("Due: ${installment["date"]}"),
                  );
                }).toList(),

                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                TextField(
                  controller: customAmountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Amount",
                    suffixText: "KWD",
                  ),
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.face),
                      onPressed: () {
                        setState(() {
                          passwordController.text = "khadeejah";
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () {

                print("Payments Submitted:");
                for (var installment in installments) {
                  if (installment["selected"]) {
                    print(
                        "Paid ${installment["amount"]} KWD (Due: ${installment["date"]})");
                  }
                }
                print("Custom Amount: ${customAmountController.text}");
                print("Password: ${passwordController.text}");

                Navigator.pop(context); 
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }
}