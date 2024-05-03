import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animate_do/animate_do.dart';

class ForgotPassword extends StatefulWidget {
  final String userType;

  const ForgotPassword({super.key, required this.userType});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference _studentRef =
  FirebaseFirestore.instance.collection("students");

  final CollectionReference _teacherRef =
  FirebaseFirestore.instance.collection("teachers");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 30),
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: const Text(
                  "Forgot Password",
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
                  "Enter your Registered Email",
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 70),
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    padding: const EdgeInsets.only(top: 3, left: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () {
                        _sendPasswordResetEmail();
                      },
                      color: Colors.red,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Reset Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendPasswordResetEmail() {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter your email",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    // Check user type and send password reset email accordingly
    if (widget.userType == "student") {
      _sendPasswordResetEmailForStudent(email); // Pass email parameter here
    } else if (widget.userType == "teacher") {
      _sendPasswordResetEmailForTeacher(email);
    }
  }

  void _sendPasswordResetEmailForStudent(String email) {
    _studentRef.where("email", isEqualTo: email).get().then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        _firebaseAuth.sendPasswordResetEmail(email: email).then((value) {
          Fluttertoast.showToast(
            msg: "Password reset email sent. Please check your inbox.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.pop(context);
        }).catchError((error) {
          Fluttertoast.showToast(
            msg: "Password reset email could not be sent. Please try again.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        });
      } else {
        Fluttertoast.showToast(
          msg: "Invalid email. Please enter a student email.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }).catchError((error) {
      Fluttertoast.showToast(
        msg: "Error: $error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
  }

  void _sendPasswordResetEmailForTeacher(String email) {
    _teacherRef.where("email", isEqualTo: email).get().then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        _firebaseAuth.sendPasswordResetEmail(email: email).then((value) {
          Fluttertoast.showToast(
            msg: "Password reset email sent. Please check your inbox.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.pop(context);
        }).catchError((error) {
          Fluttertoast.showToast(
              msg: "Password reset email could not be sent. Please try again.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            fontSize: 16.0,
          );
        });
      } else {
        Fluttertoast.showToast(
          msg: "Invalid email. Please enter a teacher email.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }).catchError((error) {
      Fluttertoast.showToast(
        msg: "Error: $error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
  }
}
