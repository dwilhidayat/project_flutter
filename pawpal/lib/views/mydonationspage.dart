import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/donation.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';

class MyDonationsPage extends StatefulWidget {
  final User user;
  const MyDonationsPage({super.key, required this.user});

  @override
  State<MyDonationsPage> createState() => _MyDonationsPageState();
}

class _MyDonationsPageState extends State<MyDonationsPage> {
  List<Donation> donationList = [];
  String status = "Loading...";

  @override
  void initState() {
    super.initState();
    loadMyDonations();
  }

  void loadMyDonations() {
    setState(() {
      status = "Loading...";
    });

    String url =
        "${MyConfig.baseUrl}/pawpal/api/get_my_donations.php?user_id=${widget.user.userId}";

    http.get(Uri.parse(url)).then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData['status'] == 'success') {
          donationList.clear();
          for (var item in jsonData['data']) {
            donationList.add(Donation.fromJson(item));
          }
          setState(() {
            status = "";
          });
        } else {
          setState(() {
            donationList.clear();
            status = "No donations yet.";
          });
        }
      } else {
        setState(() {
          status = "Server error.";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Donations")),
      body: donationList.isEmpty
          ? Center(child: Text(status))
          : ListView.builder(
              itemCount: donationList.length,
              itemBuilder: (context, index) {
                final d = donationList[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(d.petName ?? ""),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Type: ${d.donationType}"),
                        if (d.donationType == "money")
                          Text("Amount: RM ${d.amount}"),
                        if (d.description != null && d.description!.isNotEmpty)
                          Text("Note: ${d.description}"),
                      ],
                    ),
                    trailing: Text(
                      d.createdAt ?? "",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
