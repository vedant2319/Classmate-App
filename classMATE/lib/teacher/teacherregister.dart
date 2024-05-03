import 'dart:io';
import 'package:classmate/teacher/teacherlogin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter/material.dart';

class TeacherRegister extends StatefulWidget {
  const TeacherRegister({super.key});

  @override
  State<TeacherRegister> createState() => _TeacherRegisterState();
}

class _TeacherRegisterState extends State<TeacherRegister> {
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _snameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
  TextEditingController();

  File? _selectedImage;

  // TextStyle with 'Outfit' font family
  final TextStyle _outfitTextStyle = const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, size: 25, color: Colors.black),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) {
            return SingleChildScrollView(
              child: Stack(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height -
                          AppBar().preferredSize.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              FadeInUp(
                                duration: const Duration(milliseconds: 1000),
                                child: const Text(
                                  "Registration",
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              FadeInUp(
                                duration: const Duration(milliseconds: 1000),
                                child: const Text(
                                  "Register as a Professor Now!",
                                  style: TextStyle(
                                    fontFamily: "Outfit",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              const SizedBox(height: 25),
                              FadeInUp(
                                duration: const Duration(milliseconds: 1000),
                                child: makeInput(
                                  label: "First Name",
                                  controller: _fnameController,
                                ),
                              ),
                              FadeInUp(
                                duration: const Duration(milliseconds: 1000),
                                child: makeInput(
                                  label: "Surname",
                                  controller: _snameController,
                                ),
                              ),
                              FadeInUp(
                                duration: const Duration(milliseconds: 1000),
                                child: makeInput(
                                  label: "Email",
                                  controller: _emailController,
                                ),
                              ),
                              FadeInUp(
                                duration: const Duration(milliseconds: 1000),
                                child: makeInput(
                                  label: "Mobile No",
                                  controller: _phoneNoController,
                                ),
                              ),
                              FadeInUp(
                                duration: const Duration(milliseconds: 1000),
                                child: PasswordField(
                                  controller: _passwordController,
                                ),
                              ),
                              FadeInUp(
                                duration: const Duration(milliseconds: 1000),
                                child: PasswordField(
                                  controller: _confirmPasswordController,
                                  labelText: "Confirm Password",
                                ),
                              ),
                              const SizedBox(height: 30),
                              FadeInUp(
                                duration: const Duration(milliseconds: 1000),
                                child: Container(
                                  padding:
                                  const EdgeInsets.only(top: 3, left: 3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: MaterialButton(
                                    minWidth: double.infinity,
                                    height: 60,
                                    onPressed: () {
                                      _register(context);
                                    },
                                    color: Colors.green,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      "Sign up",
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1000),
                            child: Transform.translate(
                              offset: const Offset(0, -30),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10), // Adjust as needed
                                    child: Text(
                                      "Already Have An Account?",
                                      style: _outfitTextStyle,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10), // Adjust as needed
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const TeacherLogin()),
                                        );
                                      },
                                      child: const Text(
                                        " Login",
                                        style: TextStyle(
                                          fontFamily: 'Outfit',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 40,
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Wrap(
                                children: <Widget>[
                                  ListTile(
                                    leading: const Icon(Icons.camera),
                                    title: const Text('Capture a photo'),
                                    onTap: () async {
                                      await _getImageFromCamera();
                                      if(context.mounted){
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text('Choose from gallery'),
                                    onTap: () async {
                                      await _getImageFromGallery();
                                      if(context.mounted){
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 35,
                          child: _selectedImage != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(35),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                              width: 70,
                              height: 70,
                            ),
                          )
                              : const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget makeInput(
      {required String label,
        bool obscureText = false,
        required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: _outfitTextStyle,
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding:
            const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _register(BuildContext context) async {
    // Validate input fields
    if (!_validateFields()) {
      return;
    }

    // Show loading screen
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20.0),
                Text("Registering..."),
              ],
            ),
          ),
        );
      },
    );

    try {
      String fname = _fnameController.text.trim();
      String sname = _snameController.text.trim();
      String email = _emailController.text.trim();
      String phoneNo = _phoneNoController.text.trim();
      String password = _passwordController.text.trim();

      // Check if email exists
      QuerySnapshot emailSnapshot = await FirebaseFirestore.instance
          .collection("teachers")
          .where("email", isEqualTo: email)
          .get();
      if (emailSnapshot.docs.isNotEmpty) {
        if(context.mounted){
          Navigator.of(context).pop(); // Dismiss loading dialog
          showMessage(context, "Email is already taken");
          return;
        }
      }

      // If roll number and email are unique, proceed with registration
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        await _uploadProfilePhoto(
            _selectedImage!, fname, sname, email, phoneNo);
        if(context.mounted){
          Navigator.of(context).pop(); // Dismiss loading dialog
        }


        if (context.mounted) {
          showDialog(
            context:context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Registration Successful"),
                content: const Icon(Icons.check_circle, color: Colors.green, size: 50),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TeacherLogin()),
                      );
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      if(context.mounted){
        Navigator.of(context).pop(); // Dismiss loading dialog
        showMessage(context, "Registration Failed: $e");
      }
    }
  }

  bool _validateFields() {
    String fname = _fnameController.text.trim();
    String sname = _snameController.text.trim();
    String email = _emailController.text.trim();
    String phoneNo = _phoneNoController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (fname.isEmpty ||
        sname.isEmpty ||
        email.isEmpty ||
        phoneNo.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showMessage(context, "Please fill all fields");
      return false;
    }

    if (password != confirmPassword) {
      showMessage(context, "Passwords don't match");
      return false;
    }

    if (_selectedImage == null) {
      showMessage(context, "Please select a profile photo");
      return false;
    }

    return true;
  }

  Future<void> _uploadProfilePhoto(File profilePhotoUri,
      String fname, sname, String email, String phoneNo) async {
    Reference profilePhotoRef = FirebaseStorage.instance
        .ref()
        .child("Profile_Photos/Teacher")
        .child("$email.jpg");

    UploadTask uploadTask = profilePhotoRef.putFile(profilePhotoUri);
    await uploadTask;
    String downloadUrl = await profilePhotoRef.getDownloadURL();
    await FirebaseFirestore.instance.collection("teachers").doc(email).set({
      "fname": fname,
      "sname": sname,
      "email": email,
      "phoneNo": phoneNo,
      "profilePhotoUrl": downloadUrl,
    });
  }

  Future<void> _getImageFromCamera() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _getImageFromGallery() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void showMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Message"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;

  const PasswordField({super.key, required this.controller, this.labelText = 'Password'});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.labelText,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: widget.controller,
          obscureText: _obscureText,
          decoration: InputDecoration(
            contentPadding:
            const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}