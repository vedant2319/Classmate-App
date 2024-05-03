import 'dart:io';
import 'package:classmate/aboutus/aboutteam.dart';
import 'package:classmate/main_files/tmain.dart';
import 'package:classmate/student/studentlogin.dart';
import 'package:classmate/student/studentregister.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize OpenAI


  Platform.isAndroid
      ? await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyD-9_3fJfZztkLawLoJjXwRxTnk6SqADzg",
          projectId: "classmate-849fb",
          storageBucket: "classmate-849fb.appspot.com",
          messagingSenderId: "1024116935518",
          appId: "1:1024116935518:android:1216971ab0b8dbbefd9dcf",
      )) : await Firebase.initializeApp();

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false, // Set debugShowCheckedModeBanner to false
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/background.jpg',
            fit: BoxFit.fill)),
          SafeArea(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 150),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      FadeIn(
                        duration: const Duration(milliseconds: 1000),
                        child: const Text(
                          "Hello Student!",
                          style: TextStyle(
                            backgroundColor: Colors.white,
                            fontFamily: 'Outfit', // Apply the 'Outfit' font family here
                            fontWeight: FontWeight.bold,
                            fontSize: 60,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      FadeIn(
                        duration: const Duration(milliseconds: 1000),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Baseline(
                            baseline: 0.0,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              "Connect. Learn. Succeed.",
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                fontFamily: 'Outfit',
                                color: Colors.redAccent[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          minWidth: double.infinity,
                          height: 50,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const StudentLogin()),
                            );
                          },
                          color: Colors.yellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.black)
                          ),
                          child: const Text(
                            "LOGIN",
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20), // Adding some space between the buttons
                        MaterialButton(
                          minWidth: double.infinity,
                          height: 50,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const StudentRegister()),
                            );
                          },
                          color: Colors.green,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: Colors.black)
                          ),
                          child: const Text(
                            "SIGN UP",
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 60,
            right: 30,
            child: IconButton(
              icon: const Icon(Icons.info_rounded, size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutTeam()),
                );
              },
            ),
          ),
          Positioned(
            top: 60,
            left: 30,
            child: MaterialButton(
              minWidth: 130,
              height: 40,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TeacherHome()),
                );
              },
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              child: const Text(
                "Professor",
                style: TextStyle(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}