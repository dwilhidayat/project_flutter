import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/loginpage.dart';
import 'package:pawpal/views/mydonationspage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  
  final ImagePicker _picker= ImagePicker();
  File? _image;  
  Uint8List? _webImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final response = await http.get(
      Uri.parse(
        '${MyConfig.baseUrl}/pawpal/api/get_user.php?user_id=${widget.user.userId}'
      ),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        setState(() {
          nameController.text = jsonResponse['data']['user_name'];
          phoneController.text = jsonResponse['data']['user_phone'];
        });
      }
    }
  }


  Future<void> _updateProfile() async {
    String base64Image = "";
    if (nameController.text.isEmpty || phoneController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fill in all fields")),
    );
    return;
  }

  if (_image != null && !kIsWeb) {
    base64Image = base64Encode(_image!.readAsBytesSync());
  } else if (_webImage != null) {
    base64Image = base64Encode(_webImage!);
  }

    setState(() => isLoading = true);

    final response = await http.post(
      Uri.parse('${MyConfig.baseUrl}/pawpal/api/update_profile.php'),
      body: {
        'user_id': widget.user.userId.toString(),
        'user_name': nameController.text,
        'user_phone': phoneController.text,
        'image': base64Image,
      },
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Update failed")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("My Profile"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: "Logout",
              onPressed: logout,
            ),
          ],
        ),

      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                
                GestureDetector(
                  onTap: () {
                    if (kIsWeb) {
                      _openGallery();   
                    } else {
                      _pickImageDialog(); 
                    }
                  },
                  
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade300,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                      image: _image != null && !kIsWeb
                          ? DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit.cover,
                            )
                          : _webImage != null
                              ? DecorationImage(
                                  image: MemoryImage(_webImage!),
                                  fit: BoxFit.cover,
                                )
                              : DecorationImage(
                                  image: NetworkImage(
                                    "${MyConfig.baseUrl}/pawpal/uploads/profile/profile_user_${widget.user.userId}.png",
                                  ),
                                  fit: BoxFit.cover,
                                  onError: (_, __) {},
                                ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.volunteer_activism),
                      label: const Text("My Donations"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyDonationsPage(user: widget.user),
                          ),
                        );
                      },
                    ),
                  ),


                const SizedBox(height: 20),
                _readonlyField("Email", widget.user.userEmail?? "-"),

                const SizedBox(height: 16),

                _inputField(
                  controller: nameController,
                  label: "Name",
                  icon: Icons.person,
                ),
                const SizedBox(height: 12),

                _inputField(
                  controller: phoneController,
                  label: "Phone",
                  icon: Icons.phone,
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: _updateProfile,
                    child: const Text("Save Changes"),
                  ),
                ),
                
              ],
            ),
          ),

          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _readonlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        readOnly: true,
        controller: TextEditingController(text: value ),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

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

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );

  }
    void _pickImageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Profile Picture'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _openCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _openGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }
  Future<void> _openGallery() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      if (kIsWeb) {
        _webImage = await pickedFile.readAsBytes();
      } else {
        _image = File(pickedFile.path);
      }
      setState(() {});
    }
  }
  Future<void> _openCamera() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      if (kIsWeb) {
        _webImage = await pickedFile.readAsBytes();
      } else {
        _image = File(pickedFile.path);
      }
      setState(() {});
    }
  } 
}


