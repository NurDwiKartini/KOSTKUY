// profil.dart
// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  String? _username;
  String? _password;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Fungsi untuk memuat data profil dari SharedPreferences
  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username'); // Ambil username
      _password = prefs.getString('password'); // Ambil password
    });
  }

  // Fungsi untuk logout
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('username');
    await prefs.remove('password');
    Navigator.pushReplacementNamed(
        context, '/login'); // Navigasi ke halaman login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA8E6CF), // Warna hijau pastel
        title: const Text('Profil',
            style: TextStyle(color: Colors.black)), // Mengubah warna teks
        actions: [
          IconButton(
            icon: const Icon(Icons.logout,
                color: Colors.black), // Mengubah warna ikon logout
            onPressed: _logout,
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFE8F5E9), // Warna latar belakang
        child: Center(
          child: _username != null && _password != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Welcome, $_username!',
                        style: const TextStyle(
                            fontSize: 24,
                            color: Colors.black)), // Mengubah warna teks
                    const SizedBox(height: 20),
                    Text('Password: $_password',
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black)), // Mengubah warna teks
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                            0xFF81C784), // Warna hijau pastel untuk tombol
                      ),
                      onPressed: _logout,
                      child: const Text('Logout'),
                    ),
                  ],
                )
              : const CircularProgressIndicator(), // Tampilkan progress indicator saat memuat data
        ),
      ),
    );
  }
}
