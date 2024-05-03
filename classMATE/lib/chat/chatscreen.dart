import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  final String currentUseremail;
  final String peerUseremail;
  final String chatusername;

  const ChatScreen({super.key,
    required this.currentUseremail,
    required this.peerUseremail,
    required this.chatusername,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String groupChatId;
  late TextEditingController _textEditingController;
  late ScrollController _listScrollController;
  final int _limit = 20; // Limit for initial load of messages
  late String _studentName = '';
  late String _studentProfilePhotoUrl = '';
  File? _imageFile;
  String? backgroundImageUrl;


  @override
  void initState() {
    super.initState();
    fetchStudentInfo();
    _textEditingController = TextEditingController();
    _listScrollController = ScrollController();
    groupChatId = _getGroupChatId(widget.currentUseremail, widget.peerUseremail);
    loadBackgroundImageUrl();
  }

  void loadBackgroundImageUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      backgroundImageUrl = prefs.getString('backgroundImageUrl');
    });
  }


  Future<void> fetchStudentInfo() async {
    QuerySnapshot<Map<String, dynamic>> snapshotStudent =
    await FirebaseFirestore.instance
        .collection('students')
        .where('email', isEqualTo: widget.peerUseremail)
        .get();
    QuerySnapshot<Map<String, dynamic>> snapshotTeacher =
    await FirebaseFirestore.instance
        .collection('teachers')
        .where('email', isEqualTo: widget.peerUseremail)
        .get();

    if (snapshotStudent.docs.isNotEmpty) {
      Map<String, dynamic> data = snapshotStudent.docs.first.data();
      String fullName = '${data['fname'] ?? ''} ${data['sname'] ?? ''}';
      setState(() {
        _studentName = fullName;
        _studentProfilePhotoUrl = data['profilePhotoUrl'] ?? '';
      });
    } else if (snapshotTeacher.docs.isNotEmpty) {
      Map<String, dynamic> data = snapshotTeacher.docs.first.data();
      String fullName = '${data['fname'] ?? ''} ${data['sname'] ?? ''}';
      setState(() {
        _studentName = fullName;
        _studentProfilePhotoUrl = data['profilePhotoUrl'] ?? '';
      });
    }
  }

  Future<void> _getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Show preview of the selected image
      if(!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Preview", style: TextStyle(
              fontFamily: "Outfit",
              fontSize: 15
            ),),
            content: Image.file(_imageFile!), // Display the selected image
            actions: <Widget>[
              FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the preview dialog
                },
                backgroundColor: Colors.orange,
                child: const Icon(Icons.close),
              ),

              FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the preview dialog
                  _sendImageMessage(_imageFile!); // Send the selected image
                },
                backgroundColor: Colors.orange,
                child: const Icon(Icons.send),
              ),

            ],
          );
        },
      );
    }
  }
  Future<void> clearChatHistory(BuildContext context, String groupChatId) async {
    bool confirmClear = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Clear Chat'),
          content: const Text('Are you sure you want to clear this chat?\nClearChat Clears the Chats from Both end!!!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No, do not clear
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Yes, clear the chat
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirmClear == true) {
      try {
        QuerySnapshot<Map<String, dynamic>> messagesSnapshot =
        await FirebaseFirestore.instance
            .collection('messages')
            .doc(groupChatId)
            .collection(groupChatId)
            .get();

        List<QueryDocumentSnapshot<Map<String, dynamic>>> messages =
            messagesSnapshot.docs;

        for (QueryDocumentSnapshot<Map<String, dynamic>> message in messages) {
          await message.reference.delete();
        }

        Fluttertoast.showToast(
          msg: 'Chat cleared successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } catch (error) {
        // Show an error message when an error occurs
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
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(_studentProfilePhotoUrl),
            ),
            const SizedBox(width: 8),
            Text(
              _studentName,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 16,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                _showPopupMenu(context);
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
                 image: DecorationImage(
              image: AssetImage('assets/wa.jpg'),
              fit: BoxFit.cover,
            )
          ),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('messages')
                      .doc(groupChatId)
                      .collection(groupChatId)
                      .orderBy('timestamp', descending: true)
                      .limit(_limit)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('Say Hello !!!',style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Outfit",
                        color: Colors.black
                      ),));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(10.0),
                      itemBuilder: (context, index) {
                        return buildItem(snapshot.data!.docs[index]);
                      },
                      itemCount: snapshot.data!.docs.length,
                      reverse: true,
                      controller: _listScrollController,
                    );
                  },
                ),
              ),
              _buildInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.photo,color: Colors.black),
            onPressed: () {
              _getImage();
            },
          ),
          Expanded(
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: 'Type Message Here.......',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white, // Set the background color to white
              ),
            ),
          ),
          const SizedBox(width: 5),
          FloatingActionButton(
            onPressed: () {
              _sendMessage(0); // 0 for text message type
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.send_outlined),
          ),
        ],
      ),
    );
  }

  void _showPopupMenu(BuildContext context) {
    final RenderBox overlay =
    Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        Offset(MediaQuery.of(context).size.width - 50.0, 0),
        Offset(MediaQuery.of(context).size.width, 50.0),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      color: const Color(0xFFFCFCFC),
      items: [
        PopupMenuItem(
          child: const Row(
            children: [
              Icon(Icons.delete),
              SizedBox(width: 8),
              Text("Clear Chat History"),
            ],
          ),
          onTap: () {
            clearChatHistory(context, groupChatId);
          },
        ),
      ],
    );
  }

  void _sendMessage(int messageType) async {
    String messageContent = _textEditingController.text.trim();
    if (messageContent.isNotEmpty || messageType == 1) {
      _textEditingController.clear();
      DocumentReference messageRef = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      if (messageType == 1 && _imageFile != null) {
        // Upload image to storage and get URL
        String imageUrl = await _uploadImageToStorage(_imageFile!);
        messageContent = imageUrl;
      }

      messageRef.set({
        'idFrom': widget.currentUseremail,
        'idTo': widget.peerUseremail,
        'timestamp': DateTime.now(),
        'content': messageContent,
        'type': messageType,
      });
      _listScrollController.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nothing to send')));
    }
  }


  void _sendImageMessage(File imageFile) async {
    final imageUrl = await _uploadImageToStorage(imageFile);

    DocumentReference messageRef = FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    messageRef.set({
      'idFrom': widget.currentUseremail,
      'idTo': widget.peerUseremail,
      'timestamp': DateTime.now(),
      'content': imageUrl,
      'type': 1, // 1 for image message type
    });

    _listScrollController.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }


  Future<String> _uploadImageToStorage(File imageFile) async {
    try {
      // Get a reference to the Firebase Storage location
      Reference ref = FirebaseStorage.instance.ref().child('images/${DateTime.now().millisecondsSinceEpoch}');

      // Upload the file to Firebase Storage
      UploadTask uploadTask = ref.putFile(imageFile);

      // Get the download URL once the upload is complete
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Return the URL of the uploaded image
      return downloadUrl;
    } catch (error) {
      // Handle any errors that occur during the upload process
      return ''; // Return an empty string if an error occurs
    }
  }

  Widget buildItem(DocumentSnapshot document) {
    int messageType = document['type'];
    String content = document['content'];
    bool isSent = document['idFrom'] == widget.currentUseremail;
    DateTime timestamp = (document['timestamp'] as Timestamp).toDate();

    switch (messageType) {
      case 0:
      // Text message
        return Column(
          crossAxisAlignment: isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: isSent ? Colors.greenAccent : Colors.grey[300],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(isSent ? 12 : 0),
                      topRight: Radius.circular(isSent ? 0 : 12),
                      bottomLeft: const Radius.circular(12),
                      bottomRight: const Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    content,
                    style: TextStyle(color: isSent ? Colors.black : Colors.black),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 2.0),
              child: Text(
                '${timestamp.hour}:${timestamp.minute}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        );
      case 1:
      // Image message
        return Column(
          crossAxisAlignment: isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                // Open the image in full screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreenImage(url: content),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: isSent ? Colors.blueAccent : Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isSent ? 12 : 0),
                    topRight: Radius.circular(isSent ? 0 : 12),
                    bottomLeft: const Radius.circular(12),
                    bottomRight: const Radius.circular(12),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: content,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 2.0),
              child: Text(
                '${timestamp.hour}:${timestamp.minute}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }


  String _getGroupChatId(String currentUserId, String peerUserId) {
    return currentUserId.hashCode <= peerUserId.hashCode ? '$currentUserId-$peerUserId' : '$peerUserId-$currentUserId';
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _listScrollController.dispose();
    super.dispose();
  }
}

class FullScreenImage extends StatelessWidget {
  final String url;

  const FullScreenImage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Hero(
          tag: url,
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.contain,
            placeholder: (context, url) => const SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
