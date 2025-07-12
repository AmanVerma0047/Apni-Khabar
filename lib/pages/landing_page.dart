import 'package:flutter/material.dart';
import 'package:news_app/pages/home.dart';
import 'package:news_app/pages/profile.dart';
import 'package:news_app/pages/videos.dart';
import 'package:news_app/pages/weather.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';



void main() {
  runApp(const MainPage());
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Home(),
    const VideosPage(),
    weatherPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Apni',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    fontFamily:
                        'Georgia', // or 'Times New Roman', or your custom font
                  ),
                ),
                Text(
                  'Khabar',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 0, 179, 249),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    fontFamily:
                        'Georgia', // or 'Times New Roman', or your custom font
                  ),
                ),
              ],
            ),
            Text(
              'Your trusted tech news source',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: _pages[_currentIndex], // Dynamically switch body
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() => _currentIndex = i);

          switch (i) {
            case 0:
              _currentIndex = 0;
              break;

            case 1:
              _currentIndex = 1;

              break;

            case 2:
              _currentIndex = 2;
              break;

            case 3:
              _currentIndex = 3;
              break;

            default:
              break;
          }
        },
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            selectedColor: Colors.purple,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: Icon(Icons.video_library),
            title: Text("Videos"),
            selectedColor: Colors.pink,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: Icon(Icons.cloud_circle_outlined),
            title: Text("weather"),
            selectedColor: Colors.orange,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
            selectedColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}


