import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/pet.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';

class PaymentPage extends StatelessWidget {
  final User user;
  final Pet pet;

  PaymentPage({super.key, required this.user, required this.pet});

  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Secure Payment")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Amount (RM)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(
                labelText: "Card Number",
                hintText: "XXXX XXXX XXXX XXXX",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "MM/YY",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "CVV",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text("Pay Now"),
                onPressed: () async {
                  await http.post(
                    Uri.parse('${MyConfig.baseUrl}/pawpal/api/insert_donation.php'),
                    body: {
                      'user_id': user.userId.toString(),
                      'pet_id': pet.petId.toString(),
                      'donation_type': 'money',
                      'amount': amountController.text,
                    },
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Payment successful")),
                  );
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
