import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/pet.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/paymentpage.dart';

class DonationPage extends StatefulWidget {
  final User user;
  final Pet pet;

  const DonationPage({super.key, required this.user, required this.pet});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  String? donationType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Donation Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Donation Type",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "money", child: Text("Money")),
                DropdownMenuItem(value: "food", child: Text("Food")),
                DropdownMenuItem(value: "medical", child: Text("Medical")),
              ],
              onChanged: (value) {
                donationType = value;
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text("Continue"),
                onPressed: () {
                  if (donationType == "money") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(
                          user: widget.user,
                          pet: widget.pet,
                        ),
                      ),
                    );
                  } else {
                    showDescriptionDialog();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void showDescriptionDialog() {
    TextEditingController descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Donation Description"),
        content: TextField(
          controller: descController,
          decoration: const InputDecoration(
            hintText: "Enter description",
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Submit"),
            onPressed: () {
              submitDonation(
                type: donationType!,
                description: descController.text,
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void submitDonation({required String type, String? description}) async {
    await http.post(
      Uri.parse('${MyConfig.baseUrl}/pawpal/api/insert_donation.php'),
      body: {
        'user_id': widget.user.userId.toString(),
        'pet_id': widget.pet.petId.toString(),
        'donation_type': type,
        'description': description ?? '',
      },
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Donation submitted")),
    );
    Navigator.pop(context);
  }
}


