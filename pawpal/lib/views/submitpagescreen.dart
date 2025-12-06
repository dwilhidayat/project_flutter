import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';

class SubmitPage extends StatefulWidget {
  final User user;
  const SubmitPage({super.key,required this.user});

  @override
  State<SubmitPage> createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  List<String> petTypes=[
    "cat",
    "dog",
    "rabbit",
    "other"
  ];

  List<String> categories=[
    "adoption",
    "donation request",
    "help/rescue"
  ];

  TextEditingController petNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  String selectedPetType="cat";
  String selectedCategory="adoption";

  File? image;
  Uint8List? webImage;
  late double height,width;

  
  
  @override
  Widget build(BuildContext context) {

    width=MediaQuery.of(context).size.width;
    height=MediaQuery.of(context).size.height;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('new submission'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: width,
          child : SingleChildScrollView(
            child : Column (
              children: [
                GestureDetector(
                  onTap: (){
                    if (kIsWeb){
                      openGallery();
                    }else{
                      pickImagedialog();
                    }
                  },
                  child: Container(
                    width: width,
                    height: height/3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey,
                      border: Border.all(color: Colors.grey),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                      image: (image != null && !kIsWeb)
                          ? DecorationImage(
                              image: FileImage(image!),
                              fit: BoxFit.cover,
                            )
                          : (webImage != null)
                              ? DecorationImage(
                                  image: MemoryImage(webImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                    ),

                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: petNameController,
                  decoration:  InputDecoration(
                    labelText: 'pet name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    

                  )
                ),
                const SizedBox(height:12),
                DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: ' pet type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    items: petTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPetType = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height:12),
                  DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: ' Submission category',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      items: categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategory = newValue!;
                        });
                      },
                    ),
                  
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    maxLines: 4,
                    decoration:  InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,width: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: latitudeController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: "Latitude",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: longitudeController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: "Longitude",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.my_location),
                        onPressed: () async{
                          Position position=await _determinePosition();
                          setState(() {
                            latitudeController.text=position.latitude.toString();
                            longitudeController.text=position.longitude.toString();
                          }
                        );

                        }
                        ), 
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(width, 50),
                    ),
                    onPressed: () {
                      submitPet();
                    },
                    child: const Text("Submit"),
                  ),
              ]
            )
          )
        ),
      )
    );
  }
  Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
  void pickImagedialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  openCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  openGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  Future<void> openGallery() async {
    final picker= ImagePicker();
    final pickedFile= await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile!=null){
      if (kIsWeb){
        webImage=await pickedFile.readAsBytes();
        setState(() {
          
        });
      }else{
        image=File(pickedFile.path);
        setState(() {
          
        });
      }
    }
  }
  
  Future<void> openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      if (kIsWeb) {
        webImage = await pickedFile.readAsBytes();
        setState(() {

        });
      } else {
        image = File(pickedFile.path);
        setState(() {

        });
      }
    }
  }
  
  void submitPet() {
  if (petNameController.text.isEmpty ||
      descriptionController.text.isEmpty ||
      latitudeController.text.isEmpty ||
      longitudeController.text.isEmpty ||
      (image == null && webImage == null)) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please complete all fields and select image"),
      ),
    );
    return;
  }

  String base64Image = "";
  if (kIsWeb) {
    base64Image = base64Encode(webImage!);
  } else {
    base64Image = base64Encode(image!.readAsBytesSync());
  }

  String petName = petNameController.text.trim();
  String description = descriptionController.text.trim();
  String lat = latitudeController.text.trim();
  String lng = longitudeController.text.trim();

  http
      .post(
        Uri.parse('${MyConfig.baseUrl}/pawpal/api/submit_pet.php'),
        body: {
          'user_id': widget.user.userId.toString(),
          'pet_name': petName,
          'pet_type': selectedPetType,
          'category': selectedCategory,
          'description': description,
          'lat': lat,
          'lng': lng,
          'image0': base64Image,
        },
      )
      .then((response) {

        print(response.statusCode);
        print(response.body);

        if (response.statusCode == 200) {
          var jsonResponse = response.body;
          var resarray = jsonDecode(jsonResponse);
          log(jsonResponse);
          if (resarray['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Pet submitted successfully"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(resarray['message']),
                backgroundColor: Colors.red,
              ),
            );
          }
        }else{
          if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Submit failed: ${response.statusCode}"),
                backgroundColor: Colors.red,
              ),
            );
        }
      }
    );
  }   
}