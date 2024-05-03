import 'dart:ui';
import 'package:classmate/aboutus/aboutteam.dart';
import 'package:classmate/common/searchscreen.dart';
import 'package:classmate/teacher/Add.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../chat/chatscreen.dart';
import '../student/studentinternal.dart';

class TeacherInternal extends StatefulWidget {
  const TeacherInternal({super.key});

  @override
  State<TeacherInternal> createState() => _TeacherInternalState();
}

class _TeacherInternalState extends State<TeacherInternal> {
  String _selectedSection = 'teachers'; // Updated variable for selected section
  String? _userFullName;
  String? _userEmail;
  String _email = ''; // Define _email here and initialize it as an empty string

  String? _userProfilePhotoUrl;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _email = user.email!; // Update _email with the user's email
      });
      await fetchUserInfo(user.email!);
    }
  }

  Future<void> fetchUserInfo(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('teachers')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        setState(() {
          _userFullName = '${userData['fname']} ${userData['sname'] ?? ''}';
          _userProfilePhotoUrl = userData['profilePhotoUrl'];
          _userEmail = userData['email'];
        });
      } else {
        Fluttertoast.showToast(
          msg: 'User Not Found in the Dataset',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Error occurred: $error',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: FadeIn(
          duration: const Duration(milliseconds: 500),
          child: const Text(
            'classMATE',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(currentUserEmail: _email)));
            },
            icon: const Icon(Icons.search),
            iconSize: 30,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                _userFullName ?? 'Username',
                style: const TextStyle(
                  fontFamily: 'Outfit',
                ),
              ),
              accountEmail: Text(
                _userEmail ?? 'user@example.com',
                style: const TextStyle(
                  fontFamily: 'Outfit',
                ),
              ),
              currentAccountPicture: GestureDetector(
                onTap: () {
                  _showZoomedProfile(context);
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: _userProfilePhotoUrl != null ? CachedNetworkImageProvider(_userProfilePhotoUrl!) : null,
                  // child: Icon(Icons.camera_alt), // Add camera icon overlay
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: const Text(
                'Notices',
                style: TextStyle(
                  fontFamily: 'Outfit',
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Add())
                );
              },
            ),
            ListTile(
              title: const Text(
                'About Us',
                style: TextStyle(
                  fontFamily: 'Outfit',
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutTeam())
                );
              },
            ),
          ],
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), // Adjust the shadow color and opacity as needed
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2), // Adjust the shadow offset as needed
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0), // Adjust the border radius as needed
                border: Border.all(color: Colors.black), // Add black border
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(0), // Adjust the border radius as needed
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FadeIn(
                      duration: const Duration(milliseconds: 500),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedSection = 'teachers';
                          });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: _selectedSection == 'teachers' ? Colors.black : Colors.white, // Dynamic text color
                        ),
                        child: const Text(
                          'Teachers',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                    FadeIn(
                      duration: const Duration(milliseconds: 500),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedSection = 'students';
                          });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: _selectedSection == 'students' ? Colors.black : Colors.white, // Dynamic text color
                        ),
                        child: const Text(
                          'Students',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                    FadeIn(
                      duration: const Duration(milliseconds: 500),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Add())
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: _selectedSection == 'Notices' ? Colors.black : Colors.white, // Dynamic text color
                        ),
                        child: const Text(
                          'Notices',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _selectedSection == 'students'
                  ? FadeIn(
                duration: const Duration(milliseconds: 500),
                child: StudentsContent(_email),
              )
                  : FadeIn(
                duration: const Duration(milliseconds: 500),
                child: TeachersContent(_email), // Pass _email here
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showZoomedProfile(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Stack(
            alignment: Alignment.center,
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.0), // Adjust opacity as needed
                ),
              ),
              CircleAvatar(
                radius: 150, // Adjust size as needed
                backgroundColor: Colors.white, // Background color of the circle
                backgroundImage: _userProfilePhotoUrl != null ? CachedNetworkImageProvider(_userProfilePhotoUrl!) : null,
              ),
            ],
          ),
        );
      },
    );
  }
}

_openChatScreen(BuildContext context, String chatUserId, String currentUserEmail, String chatUserEmail, String chatUserName) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ChatScreen(
        currentUseremail: currentUserEmail, // Pass current user's email as currentUserId
        peerUseremail: chatUserEmail, // Pass chat user's email as peerUserId
        chatusername: chatUserName, // Pass chat user's name as peerNickname
      ),
    ),
  );
}

class TeachersContent extends StatelessWidget {
  final String _email;

  const TeachersContent(this._email, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('teachers').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No Chats found.'),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final teacherDocument = snapshot.data!.docs[index];
            final teacherData = teacherDocument.data() as Map<String, dynamic>;

            String fullName = '${teacherData['fname']} ${teacherData['sname'] ??
                ''}';

            final currentUserEmail = FirebaseAuth.instance.currentUser!.email;
            if (teacherData['email'] == currentUserEmail) {
              return const SizedBox.shrink();
            }

            // Get the profile photo URL
            final profilePhotoUrl = teacherData['profilePhotoUrl'] as String?;

            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    _openChatScreen(context, teacherDocument.id, _email, teacherData['email'], fullName);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black26)),
                    ),
                    child: Row(
                      children: [
                        // Use CachedNetworkImage to load profile photo
                        CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(profilePhotoUrl!),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            fullName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'Outfit',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (index != snapshot.data!.docs.length - 1)
                  const Divider(color: Colors.black26, height: 0),
              ],
            );
          },
        );
      },
    );
  }
}
class StudentsContent extends StatelessWidget {
  final String _email;
  const StudentsContent(this._email, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('students').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No students found.'),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final studentDocument = snapshot.data!.docs[index];
            final studentData = studentDocument.data() as Map<String, dynamic>;

            final currentUserEmail = FirebaseAuth.instance.currentUser!.email;
            if (studentData['email'] == currentUserEmail) {
              return const SizedBox.shrink();
            }

            String fullName = '${studentData['fname']} ${studentData['sname'] ?? ''}';
            // Get the profile photo URL
            final profilePhotoUrl = studentData['profilePhotoUrl'] as String?;

            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    _openChatScreen(context, studentDocument.id, _email, studentData['email'], fullName);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black26)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(profilePhotoUrl!),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            fullName,
                            style: const TextStyle(fontSize: 18,
                              fontFamily: 'Outfit',),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (index != snapshot.data!.docs.length - 1)
                  const Divider(color: Colors.black26, height: 0),
              ],
            );
          },
        );
      },
    );
  }
}
