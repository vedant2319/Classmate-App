import 'package:flutter/material.dart';

class VedantProfile extends StatelessWidget {
  const VedantProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Vedant Rajesh Naik',
          style: TextStyle(fontFamily: 'Outfit'),
          textAlign: TextAlign.center,
        ),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage('assets/profilephoto/Vedant.jpg'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Vedant Rajesh Naik',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Founder & CEO',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Vedant is passionate about software development and innovation. \nHe has extensive experience in building mobile and web applications, with a focus on creating user-friendly interfaces and scalable solutions. \nHe is currently pursuing a degree in Computer Science, where he continues to expand his knowledge and skills in programming, algorithms, and data structures. \nAryaman is also actively involved in various coding communities and open-source projects, where he collaborates with other developers to tackle real-world challenges.',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildEducationTile(
              'Finolex Academy of Management and Technology',
              'Bachelor of Science in Computer Science (AI & ML)',
              '2021 - Present',
            ),
            const SizedBox(height: 20),
            _buildSkillTile(
              'Programming Languages',
              'Dart, Java, Python',
            ),
            const SizedBox(height: 20),
            _buildSkillTile(
              'Tools',
              'Android Studio, Visual Studio Code, Firebase',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationTile(String institution, String degree, String period) {
    return ListTile(
      title: Text(
        institution,
        style: const TextStyle(
          fontFamily: 'Outfit',
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            degree,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 16,
            ),
          ),
          Text(
            period,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillTile(String title, String skills) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Outfit',
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      subtitle: Text(
        skills,
        style: const TextStyle(
          fontFamily: 'Outfit',
          fontSize: 16,
        ),
      ),
    );
  }
}
