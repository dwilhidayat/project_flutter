import 'package:flutter/material.dart';
import 'package:pawpal/models/pet.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/views/loginpage.dart';
import 'package:pawpal/views/submitpagescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pawpal/myconfig.dart';

class MainPage extends StatefulWidget {
  final User user;
  const MainPage({super.key, required this.user});

  @override
  State<MainPage> createState() => _MainPageState();
}


class _MainPageState extends State<MainPage> {
  List<Pet> submissionList = [];
  String status = "Loading...";

  @override
  void initState() {
    super.initState();
    loadMyPets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: logout,
          ),
        ],
      ),
      body: submissionList.isEmpty
          ? Center(
              child: Text(
                status,
                style: const TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: submissionList.length,
              itemBuilder: (context, index) {
                final pet = submissionList[index];
                print("IMG = ${MyConfig.baseUrl}/pawpal/${pet.imagePath}");

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: 
                          
                          Image.network(
                            '${MyConfig.baseUrl}/pawpal/${pet.imagePath}',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported, size: 50);
                            },
                          ),

                        ),

                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pet.petName ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("Type: ${pet.petType ?? ''}"),
                              Text("Category: ${pet.category ?? ''}"),
                              const SizedBox(height: 6),
                              Text(
                                pet.description ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubmitPage(user: widget.user),
            ),
          );
          loadMyPets();
        },
      ),
    );
  }
  void loadMyPets() {
  submissionList.clear();
  setState(() {
    status = "Loading...";
  });

  String url =
      '${MyConfig.baseUrl}/pawpal/api/get_my_pets.php?user_id=${widget.user.userId}';

  print("REQUEST URL: $url");

  http.get(Uri.parse(url)).then((response) {
    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      print("DECODED JSON: $jsonResponse");
      if (jsonResponse['data'] != null &&
          jsonResponse['data'] is List &&
          jsonResponse['data'].length > 0) {

        submissionList.clear();
        for (var item in jsonResponse['data']) {
          submissionList.add(Pet.fromJson(item));
        }

        setState(() {
          status = "";
        });

      } else {
        setState(() {
          submissionList.clear();
          status = "No submissions yet.";
        });
      }
    } else {
      setState(() {
        status = "Server error.";
      });
    }
  });
}


  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool remember = prefs.getBool("rememberMe") ?? false;

    if (!remember) {
      await prefs.remove("email");
      await prefs.remove("password");
      await prefs.remove("rememberMe");
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}


