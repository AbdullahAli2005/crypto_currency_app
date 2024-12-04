import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadUserProfile(); // Load user profile when the page is initialized
  }

  // Load user profile info (name and profile image) from SharedPreferences
  Future<void> _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileImage = _loadImage(prefs.getString('userProfileImageUrl'));
      _nameController.text =
          prefs.getString('userName') ?? ''; // Load user name
    });
  }

  // Load the image from the file path stored in SharedPreferences
  File? _loadImage(String? imagePath) {
    if (imagePath != null && imagePath.isNotEmpty) {
      return File(imagePath); // Return the file object from path
    }
    return null; // Return null if no image is found
  }

  // Pick an image from the gallery or choose "None"
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path); // Update the profile image
      });
    }
  }

  // Reset profile image to None
  void _resetImage() {
    setState(() {
      _profileImage = null;
    });
  }

  // Save user profile information to SharedPreferences
  void _saveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the name and profile image URL (or a placeholder if no image is selected)
    await prefs.setString('userName', _nameController.text);
    await prefs.setString(
      'userProfileImageUrl',
      _profileImage?.path ?? '', // Store the local file path if available
    );

    setState(() {
      _nameController.text = _nameController.text;
    });

    // Show a message when saved
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Profile Picture Section with white shadow
            Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () =>
                    _showImageSelectionDialog(), // Allow users to pick an image or reset
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 99, 99, 99),
                        Color.fromARGB(255, 51, 51, 51),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius:
                        BorderRadius.circular(70), // Round the container
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 40,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.transparent,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!) // Show profile image
                        : null,
                    child: _profileImage == null
                        ? const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          ) // Default icon when no image
                        : null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Name TextField Section with white text
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white), // White text color
              decoration: const InputDecoration(
                labelText: 'Enter your name',
                labelStyle: TextStyle(color: Colors.white), // White label text
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.white), // White border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.white), // White focused border color
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Save Button with white text
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(
                    255, 89, 88, 88), // Black background for button
                elevation: 10,
              ),
              child: const Text(
                'Save Profile',
                style: TextStyle(color: Colors.white), // White text color
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show the image selection dialog
  void _showImageSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(
            255, 44, 44, 44), // Set the dialog background to black
        title: const Text(
          'Select Profile Image',
          style: TextStyle(color: Colors.white), // White title text
        ),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Option to pick from gallery
              ListTile(
                title: const Text(
                  'Pick from Gallery',
                  style: TextStyle(color: Colors.white), // White text
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage();
                },
                leading: const Icon(Icons.photo, color: Colors.white),
              ),
              // Option to remove image
              ListTile(
                title: const Text(
                  'Remove Image',
                  style: TextStyle(color: Colors.white), // White text
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _resetImage();
                },
                leading: const Icon(Icons.delete, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
