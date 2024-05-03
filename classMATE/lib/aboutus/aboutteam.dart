import 'package:classmate/aboutus/ayushprofile.dart';
import 'package:classmate/aboutus/vedantprofile.dart';
import 'package:classmate/aboutus/sujalprofile.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'harshprofile.dart';

class AboutTeam extends StatelessWidget {
  const AboutTeam({super.key});

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
          icon: const Icon(Icons.arrow_back, size: 25, color: Colors.black,),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: FadeIn(
                duration: const Duration(milliseconds: 1000),
                child: const Text(
                  "Our Team",
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildMemberTile(
              context,
              'Vedant Rajesh NAik',
              'Founder & CEO',
              'VedantProfile',
              'assets/profilephoto/Vedant.jpg',
            ),
            _buildMemberTile(
              context,
              'Harsh Umesh Bhingarde',
              'Lead Developer',
              'HarshProfile',
              'assets/profilephoto/Harsh.jpg',
            ),
            _buildMemberTile(
              context,
              'Ayush Sunil Bansod',
              'UI/UX Designer',
              'AyushProfile',
              'assets/profilephoto/Ayush.jpg',
            ),
            _buildMemberTile(
              context,
              'Sujal Deepak Jadhav',
              'Data Analytics',
              'SujalProfile',
              'assets/profilephoto/Sujal.jpg',
            ),
            const SizedBox(height: 40),
            Center(
              child: FadeIn(
                duration: const Duration(milliseconds: 1000),
                child: const Text(
                  "Our Mission",
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: FadeIn(
                duration: const Duration(milliseconds: 1000),
                child: const Center(
                  child: Text(
                    "At classMATE, \nLinking learners to success through collaborative learning. \n\nOur mission is to empower students and educators by seamlessly integrating the communication features of WhatsApp with the educational functionalities of Google Classroom, fostering collaboration, engagement, and efficiency in the learning process.""\n\n Our platform aims to provide a unified solution for real-time communication, resource sharing, assignment management, and class discussions, simplifying the educational experience for both students and teachers. ""\n\nThrough intuitive design and innovative features, we strive to enhance learning outcomes, promote active participation, and build a vibrant community of learners.",
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center, // Center the text horizontally
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberTile(BuildContext context, String name, String role, String routeName, String imagePath) {
    return FadeInDown(
      duration: const Duration(milliseconds: 1000),
      child: TeamMemberTile(
        image: AssetImage(imagePath),
        name: name,
        role: role,
        onTap: () {
          switch (routeName) {
            case 'VedantProfile':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VedantProfile()),
              );
              break;
            case 'HarshProfile':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HarshProfile()),
              );
              break;
            case 'SujalProfile':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SujalProfile()),
              );
              break;
            case 'AyushProfile':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AyushProfile()),
              );
              break;
            default:
            // Handle default case or do nothing
          }
        },
      ),
    );
  }

}

class TeamMemberTile extends StatelessWidget {
  final ImageProvider image;
  final String name;
  final String role;
  final Function()? onTap;

  const TeamMemberTile({
    super.key,
    required this.image,
    required this.name,
    required this.role,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: image,
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontFamily: 'Outfit',
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        role,
        style: const TextStyle(
          fontFamily: 'Outfit',
        ),
      ),
    );
  }
}
