import 'package:animate_do/animate_do.dart';
import 'package:classmate/chat/chatscreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';


class SearchScreen extends StatefulWidget {
  final String currentUserEmail;

  const SearchScreen({super.key, required this.currentUserEmail});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];


  Future<void> _search(String query) async {
    final studentsQuery = FirebaseFirestore.instance
        .collection('students')
        .where('fname', isGreaterThanOrEqualTo: query)
        .where('fname', isLessThan: '${query}z')
        .get();
    final teachersQuery = FirebaseFirestore.instance
        .collection('teachers')
        .where('fname', isGreaterThanOrEqualTo: query)
        .where('fname', isLessThan: '${query}z')
        .get();

    final studentsSnapshot = await studentsQuery;
    final teachersSnapshot = await teachersQuery;

    final List<Map<String, dynamic>> combinedResults = [];

    for (var doc in studentsSnapshot.docs) {
      final data = doc.data();
      final fullName =
          '${data['fname']} ${data['mname'] ?? ''} ${data['sname']}';
      data['fullName'] = fullName;
      data['profilePhotoUrl'] = data['profilePhotoUrl'];
      data['role'] = 'Student';
      data['email'] = doc['email'];
      data['regNo'] = doc.id;
      if (data['email'] != widget.currentUserEmail) {
        combinedResults.add(data);
      }
    }

    for (var doc in teachersSnapshot.docs) {
      final data = doc.data();
      final fullName =
          '${data['fname']} ${data['mname'] ?? ''} ${data['sname']}';
      data['fullName'] = fullName;
      data['profilePhotoUrl'] = data['profilePhotoUrl'];
      data['role'] = 'Teacher';
      data['email'] = doc['email'];
      data['id'] = doc.id;
      if (data['email'] != widget.currentUserEmail) {
        combinedResults.add(data);
      }
    }

    setState(() {
      _searchResults = combinedResults;
    });

    if (_searchResults.isEmpty) {
      Fluttertoast.showToast(
        msg: 'No students or teachers found.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    if (combinedResults.isEmpty) {
      Fluttertoast.showToast(
        msg: 'User not found.',
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

        title: FadeInDown(
          duration: const Duration(milliseconds: 500),
          child: const Text(
            'classMATE',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          FadeInDown(
            duration: const Duration(milliseconds: 500), // Set the duration of the animation
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  labelStyle: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      _search(_searchController.text);
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final result = _searchResults[index];
                  return GestureDetector(
                    onTap: () async {
                      await navigateToChatScreen(result['role'], widget.currentUserEmail, result['email'], result['fullName']);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: result['profilePhotoUrl'] != null
                              ? CachedNetworkImageProvider(result['profilePhotoUrl'] as String)
                              : const AssetImage('assets/profilephoto/default_profile_image.jpg') as ImageProvider<Object>,
                        ),
                        title: Text(
                          result['fullName'] ?? 'No Name',
                          style: const TextStyle(fontFamily: "Outfit", fontSize: 16),
                        ),
                        subtitle: Text(
                          result['role'],
                          style: const TextStyle(fontFamily: "Outfit", fontSize: 16),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> navigateToChatScreen(String role, String currentUserEmail, String peerUserEmail, String chatUserName) async {
    if (role == 'Student' || role == 'Teacher') {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            currentUseremail: currentUserEmail, // Pass the current user's email
            peerUseremail: peerUserEmail, // Pass the searched user's email
            chatusername: chatUserName, // Pass the searched user's name
          ),
        ),
      );
    }
  }
}
