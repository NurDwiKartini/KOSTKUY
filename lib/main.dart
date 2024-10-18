// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';
import 'add.dart';
import 'saved.dart';
import 'login.dart';
import 'profil.dart';
import 'register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Kost',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthWrapper(), // Menggunakan AuthWrapper untuk cek login
      routes: {
        '/home': (context) => const HomePage(),
        '/add': (context) => AddPage(),
        '/saved': (context) => SavedPage(),
        '/login': (context) => LoginPage(),
        '/profil': (context) => const ProfilPage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}

// Widget untuk mengecek apakah user sudah login atau belum
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn ? const HomePage() : LoginPage();
  }
}
