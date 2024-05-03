import 'dart:ui';
import 'package:classmate/aboutus/aboutteam.dart';
import 'package:classmate/common/searchscreen.dart';
import 'package:classmate/student/Down.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../chat/chatscreen.dart';

class StudentInternal extends StatefulWidget {
  const StudentInternal({super.key});

  @override
  State<StudentInternal> createState() => _StudentInternalState();
}

class _StudentInternalState extends State<StudentInternal> {
  String _selectedSection = 'students';
  String? _userFullName;
  String? _userEmail;
  String _email = '';

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
        _email = user.email!;
      });
      await fetchUserInfo(user.email!);
    }
  }

  Future<void> fetchUserInfo(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('students')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        setState(() {
          _userFullName = '${userData['fname']} ${userData['mname'] ?? ''} ${userData['sname'] ?? ''}';
          _userProfilePhotoUrl = userData['profilePhotoUrl'];
          _userEmail = userData['email'];
        });
      } else {
        Fluttertoast.showToast(
          msg: 'User Not Found in Database',
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
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.orange,
              ),
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
                  MaterialPageRoute(builder: (context) => const AboutTeam()),
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
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                border: Border.all(color: Colors.orange),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FadeIn(
                      duration: const Duration(milliseconds: 500),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedSection = 'students';
                          });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: _selectedSection == 'students' ? Colors.black : Colors.white,
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
                          setState(() {
                            _selectedSection = 'teachers';
                          });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: _selectedSection == 'teachers' ? Colors.black : Colors.white,
                        ),
                        child: const Text(
                          'Teachers',
                          style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 17
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
                              MaterialPageRoute(builder: (context) => Down())
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: _selectedSection == 'notices' ? Colors.black : Colors.white,
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
                child: TeachersContent(_email),
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
                  color: Colors.black.withOpacity(0.0),
                ),
              ),
              CircleAvatar(
                radius: 150,
                backgroundColor: Colors.white,
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
                            style: const TextStyle(fontSize: 18, fontFamily: 'Outfit',),
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
            child: Text('No teachers found.'),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final teacherDocument = snapshot.data!.docs[index];
            final teacherData = teacherDocument.data() as Map<String, dynamic>;

            String fullName = '${teacherData['fname']} ${teacherData['sname'] ?? ''}';

            final currentUserEmail = FirebaseAuth.instance.currentUser!.email;
            if (teacherData['email'] == currentUserEmail) {
              return const SizedBox.shrink();
            }

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
