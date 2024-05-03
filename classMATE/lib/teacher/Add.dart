import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:classmate/teacher/teacherinternal.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(const Add());
}

class FileItem {
  final String id;
  final String name;
  final String type;
  final String description;
  final DateTime timestamp;
  final String downloadUrl;

  FileItem({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.timestamp,
    required this.downloadUrl,
  });
}

class Add extends StatelessWidget {
  const Add({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notices',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FileUploadScreen(),
    );
  }
}

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({Key? key});

  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  List<FileItem> files = [];
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    _loadFiles();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFiles() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('files').orderBy('timestamp', descending: true).get();
      List<FileItem> loadedFiles = [];
      for (QueryDocumentSnapshot<Map<String, dynamic>> snapshot in querySnapshot.docs) {
        Map<String, dynamic> data = snapshot.data();
        loadedFiles.add(FileItem(
          id: snapshot.id,
          name: data['name'],
          type: data['type'],
          description: data['description'],
          timestamp: (data['timestamp'] as Timestamp).toDate(),
          downloadUrl: data['downloadUrl'],
        ));
      }
      setState(() {
        files = loadedFiles;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading files: $e');
      }
    }
  }

  Future<void> _uploadFile(File file) async {
    try {
      String fileName = file.path.split('/').last;

      Reference storageRef = FirebaseStorage.instance.ref().child('files/$fileName');
      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('files').add({
        'name': fileName,
        'type': fileName.split('.').last,
        'description': 'Uploaded File',
        'timestamp': DateTime.now(),
        'downloadUrl': downloadUrl,
      });

      _loadFiles(); // Refresh file list

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('File uploaded successfully'),
        duration: Duration(seconds: 2),
      ));
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading file: $e');
      }
    }
  }

  void _viewFile(FileItem file) {
    // Implement your logic to view the file here
    if (kDebugMode) {
      print('Viewing file: ${file.name}');
    }
  }

  Future<void> _downloadFile(FileItem file) async {
    try {
      final fileName = file.name;
      final storageRef = FirebaseStorage.instance.ref().child('files/$fileName');
      final String downloadUrl = await storageRef.getDownloadURL();

      // Fetch the file's MIME type
      http.Response response = await http.head(Uri.parse(downloadUrl));
      final String contentType = response.headers['content-type'] ?? 'application/octet-stream';

      final String savePath = '/storage/emulated/0/Download/$fileName'; // Save path
      final File fileOnDevice = File(savePath);
      await fileOnDevice.writeAsBytes((await storageRef.getData()) as List<int>);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('File downloaded successfully'),
        duration: Duration(seconds: 2),
      ));

      // Open the downloaded file using url_launcher
      await openFile(savePath, contentType);
    } catch (e) {
      if (kDebugMode) {
        print('Error downloading file: $e');
      }
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error downloading file'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  Future<void> openFile(String filePath, Object contentType) async {
    try {
      // Get the platform-specific path for the file
      String platformPath = filePath;
      if (Platform.isAndroid) {
        platformPath = 'file://$filePath';
      }

      // Launch the file using platform-specific code
      bool isOpened = false;
      if (Platform.isAndroid) {
        isOpened = await launch(platformPath, forceSafariVC: false);
      } else if (Platform.isIOS) {
        final bool iosLaunchStatus = await launch('file://$filePath', forceSafariVC: false);
        isOpened = iosLaunchStatus;
      }

      if (!isOpened) {
        throw 'Could not open file';
      }
    } catch (e) {
      print('Error opening file: $e');
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error opening file'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  Future<void> _deleteFile(String fileId) async {
    try {
      await FirebaseFirestore.instance.collection('files').doc(fileId).delete();
      _loadFiles(); // Refresh file list
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting file: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const TeacherInternal()));
          },
          icon: const Icon(Icons.arrow_back, size: 25, color: Colors.white),
        ),
        title: const Text('NOTICES',
          style: TextStyle(
            color: Colors.white,
          fontFamily: 'Outfit',
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                // Implement search logic here
              },
              decoration: const InputDecoration(
                hintText: 'Search Files',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: files.isEmpty
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                final file = files[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    leading: _getFileIcon(file.type),
                    title: Text(file.name),
                    subtitle: Text('${file.type} - ${file.description}'),
                    trailing: Text(DateFormat('dd/MM/yyyy HH:mm').format(file.timestamp)),
                    onTap: () {
                      _showFileOptionsDialog(context, file);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles();
          if (result != null) {
            File file = File(result.files.single.path!);
            _uploadFile(file);
          }
        },
        tooltip: 'Upload File',
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white,),
      ),
    );
  }

  Icon _getFileIcon(String fileType) {
    switch (fileType) {
      case 'pdf':
        return const Icon(Icons.picture_as_pdf);
      case 'jpg':
      case 'png':
        return const Icon(Icons.image);
      default:
        return const Icon(Icons.insert_drive_file);
    }
  }

  void _showFileOptionsDialog(BuildContext context, FileItem file) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(file.name),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Type: ${file.type}'),
                Text('Description: ${file.description}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                _viewFile(file);
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.visibility),
              label: const Text('View'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                _downloadFile(file);
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.download),
              label: const Text('Download'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                _deleteFile(file.id);
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.delete),
              label: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
