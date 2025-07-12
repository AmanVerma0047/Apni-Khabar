import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser;
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
    void _logout() async {
  // Sign out from Firebase
  await _auth.signOut();

  // Sign out from Google too
  await GoogleSignIn().signOut();

  // Optional: Disconnect to revoke the token completely (forces re-auth)
  await GoogleSignIn().disconnect();

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => const LoginPage()),
    (route) => false,
  );
}

  }

  void _openAboutUs() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('About Us'),
          content: const Text(
            'Apni Khabar version 1.0.1 Beta\n\ndeveloped by Aman Verma',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      body: currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Profile Image
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage('images/user.png'),
                              // To use Firebase profile picture, uncomment below:
                              // backgroundImage: NetworkImage(currentUser!.photoURL ?? ''),
                            ),
                            const SizedBox(height: 16),

                            // Email only
                            Text(
                              currentUser!.email ?? 'No Email',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                    child: Column(
                      children: [
                        _buildButton(Icons.info_outline, 'About Us', _openAboutUs),
                        const SizedBox(height: 12),
                        _buildButton(Icons.logout, 'Logout', _logout, isDestructive: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildButton(IconData icon, String text, VoidCallback onTap, {bool isDestructive = false}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: isDestructive ? Colors.red : Colors.white),
        label: Text(
          text,
          style: TextStyle(color: isDestructive ? Colors.red : Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDestructive ? Colors.white : Colors.deepPurple,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isDestructive ? const BorderSide(color: Colors.red) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
