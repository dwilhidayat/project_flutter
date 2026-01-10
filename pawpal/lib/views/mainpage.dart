import 'package:flutter/material.dart';
import 'package:pawpal/models/pet.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/views/donationpage.dart';
import 'package:pawpal/views/profilepage.dart';
import 'package:pawpal/views/submitpagescreen.dart';
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

  TextEditingController searchController = TextEditingController();
  String? selectedType = "all";
  List<String> petTypes = ["all", 
    "cat", 
    "dog", 
    "rabbit", 
    "other"
  ];


  @override
  void initState() {
    super.initState();
    loadAllPets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'profile',
            onPressed: (){
              Navigator.push(context,
              MaterialPageRoute(
                builder: (context)=> ProfilePage(user: widget.user)
              )
              );
            },
          ),
          
        ],
      ),
      
      body: Column(
  children: [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: searchController,
        decoration: const InputDecoration(
          labelText: "Search pet name",
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: (value) {
          loadAllPets(); 
        },
      ),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedType,
        decoration: const InputDecoration(
          labelText: "Filter pet type",
          border: OutlineInputBorder(),
        ),
        items: petTypes.map((type) {
          return DropdownMenuItem(
            value: type,
            child: Text(type),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedType = value!;
          });
          loadAllPets(); 
        },
      ),
    ),

    const SizedBox(height: 8),
    Expanded(
    child: submissionList.isEmpty
        ? Center(child: Text(status))
        : ListView.builder(
            itemCount: submissionList.length,
            itemBuilder: (context, index) {
              final pet = submissionList[index];
              print("IMG = ${MyConfig.baseUrl}/pawpal/${pet.imagePath}");

              return InkWell(
                onTap: () {
                  showPetDetails(pet);
                },

              child :Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          '${MyConfig.baseUrl}/pawpal/${pet.imagePath}',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.image_not_supported,
                              size: 50,
                            );
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
                              
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              );
            },
          ),
        ),
      ],
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
          loadAllPets();
        },
      ),
    );
  }
  void loadAllPets() {
    submissionList.clear();
    setState(() {
      status = "Loading...";
  });

  String search = searchController.text;
  String type = selectedType ?? "all";

  String url =
      '${MyConfig.baseUrl}/pawpal/api/get_all_pets.php'
      '?search=$search&type=$type';

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

  void showPetDetails(Pet pet) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    '${MyConfig.baseUrl}/pawpal/${pet.imagePath}',
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                pet.petName ?? '',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),
              Text("Type: ${pet.petType}"),
              Text("Category: ${pet.category}"),

              const SizedBox(height: 10),
              const Text(
                "Description",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(pet.description ?? ''),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text("Request to Adopt"),
                  
                  onPressed: () {
                    Navigator.pop(context);
                    showAdoptionForm(pet);
                  },
                ),
                
              ),
              SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text("Donate"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DonationPage(
                        user: widget.user,
                        pet: pet,
                      ),
                    ),
                  );
                },
              ),
            ),


            ],
          ),
        ),
      );
    },
  );
}

  void showAdoptionForm(Pet pet) {
  TextEditingController messageController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Adoption Request"),
        content: TextField(
          controller: messageController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: "Why do you want to adopt this pet?",
            border: OutlineInputBorder(),
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
              if (messageController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Message cannot be empty")),
                );
                return;
              }

              submitAdoption(pet.petId!, messageController.text);
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
void submitAdoption(int petId, String message) {
  http.post(
    Uri.parse('${MyConfig.baseUrl}/pawpal/api/insert_adoption.php'),
    body: {
      'pet_id': petId.toString(),
      'user_id': widget.user.userId.toString(),
      'message': message,
    },
  ).then((response) {
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Adoption request sent")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to submit request")),
      );
    }
  });
}
 
}

