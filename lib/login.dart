// login.dart
// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');
    String? savedPassword = prefs.getString('password');

    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username == savedUsername && password == savedPassword) {
      await prefs.setBool('isLoggedIn', true);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid username or password')),
      );
    }
  }

  Future<void> _goToRegister() async {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA8E6CF), // Warna hijau pastel
        title: const Text('Login',
            style: TextStyle(color: Colors.black)), // Mengubah warna teks
      ),
      body: Container(
        color: const Color(0xFFE8F5E9), // Warna latar belakang
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Menyusun elemen di tengah
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                labelStyle:
                    TextStyle(color: Colors.black), // Mengubah warna label
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.black), // Border saat enabled
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color(0xFF81C784)), // Border saat fokus
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                labelStyle:
                    TextStyle(color: Colors.black), // Mengubah warna label
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.black), // Border saat enabled
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color(0xFF81C784)), // Border saat fokus
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF81C784), // Warna hijau pastel untuk tombol
              ),
              onPressed: _login,
              child: const Text('Login'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _goToRegister,
              child: const Text(
                'Register',
                style: TextStyle(color: Colors.black), // Mengubah warna teks
              ),
            ),
          ],
        ),
      ),
    );
  }
}
