import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class ChatSettingsScreen extends StatefulWidget {
  const ChatSettingsScreen({super.key});

  @override
  State<ChatSettingsScreen> createState() => _ChatSettingsScreenState();
}

class _ChatSettingsScreenState extends State<ChatSettingsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        title: FadeInDown(
          duration: const Duration(milliseconds: 500),
          child: const Text(
            'S E T T I N G S',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile',style: TextStyle(fontFamily: "Outfit", fontSize: 16),),
            onTap: () {
              // Navigate to profile settings screen
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Theme',style: TextStyle(fontFamily: "Outfit", fontSize: 16),),
            onTap: () {
              _showThemeSelectionDialog(context); // Show theme selection dialog
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
  void _showThemeSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Theme',style: TextStyle(fontFamily: "Outfit", fontSize: 16),),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 50),
              IconButton(
                icon: const Icon(Icons.light_mode),
                onPressed: () {
                  // Handle light theme selection
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 50),
              IconButton(
                icon: const Icon(Icons.dark_mode),
                onPressed: () {
                  // Handle dark theme selection
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

