import 'dart:typed_data';
import 'dart:io';
import 'package:classmate/student/studentinternal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; // Add this import for platform channel

void main() {
  runApp(const Down(
  ));
}

class FileItem {
  final String name;
  final String type;
  final String description;
  final DateTime timestamp;
  final String downloadUrl;

  FileItem({
    required this.name,
    required this.type,
    required this.description,
    required this.timestamp,
    required this.downloadUrl,
  });
}

class Down extends StatelessWidget {
  const Down({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Upload Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FileUploadScreen(),
    );
  }
}

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({Key? key}) : super(key: key);

  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  List<FileItem> files = [];

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('files').orderBy('timestamp', descending: true).get();
      List<FileItem> loadedFiles = [];
      for (QueryDocumentSnapshot<Map<String, dynamic>> snapshot in querySnapshot.docs) {
        Map<String, dynamic> data = snapshot.data();
        loadedFiles.add(FileItem(
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
      print('Error loading files: $e');
    }
  }

  Future<void> _viewFile(FileItem file) async {
    final fileName = '${file.name}';
    final filePath = '/storage/emulated/0/Download/$fileName'; // Update with actual file path
    try {
      // Use platform channels to open the file
      const platform = MethodChannel('com.example.app/file_viewer');
      await platform.invokeMethod('openFile', {'filePath': filePath});
    } on PlatformException catch (e) {
      print('Error opening file: $e');
    }
  }

  Future<void> _downloadFile(FileItem file) async {
    try {
      final fileName = file.name;
      final storageRef = FirebaseStorage.instance.ref().child('files/$fileName');
      final String downloadUrl = await storageRef.getDownloadURL();
      // Example: Saving file to Downloads directory
      String savePath = '/storage/emulated/0/Download/$fileName';
      await storageRef.writeToFile(File(savePath));

      // Show download success popup
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Download Complete'),
            content: Text('File "${file.name}" downloaded successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      print('File downloaded successfully');
    } catch (e) {
      print('Error downloading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const StudentInternal()));
          },
          icon: const Icon(Icons.arrow_back, size: 25, color: Colors.black),
        ),
        title: const Text('NOTICES',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Outfit',
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),),
      ),
      body: files.isEmpty
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
    );
  }

  Icon _getFileIcon(String fileType) {
    switch (fileType) {
      case 'Image':
        return const Icon(Icons.image);
      case 'PDF':
        return const Icon(Icons.picture_as_pdf);
      default:
        return const Icon(Icons.attach_file);
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
          ],
        );
      },
    );
  }
}
