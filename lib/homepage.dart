// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Untuk mengonversi List ke String dan sebaliknya

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Map<String, String>> kostList = []; // List untuk menyimpan data kost
  List<Map<String, String>> savedKostList =
      []; // List untuk menyimpan data yang di-save

  @override
  void initState() {
    super.initState();
    _loadKostData(); // Memuat data kost yang tersimpan
    _loadSavedKostData(); // Memuat data saved kost yang tersimpan
  }

  // Fungsi untuk menyimpan data kost ke SharedPreferences
  Future<void> _saveKostData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> kostStringList =
        kostList.map((kost) => jsonEncode(kost)).toList();
    await prefs.setStringList('kostList', kostStringList);
  }

  // Fungsi untuk menyimpan data saved kost ke SharedPreferences
  Future<void> _saveSavedKostData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedKostStringList =
        savedKostList.map((kost) => jsonEncode(kost)).toList();
    await prefs.setStringList('savedKostList', savedKostStringList);
  }

  // Fungsi untuk memuat data kost dari SharedPreferences
  Future<void> _loadKostData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? kostStringList = prefs.getStringList('kostList');
    if (kostStringList != null) {
      setState(() {
        kostList = kostStringList
            .map((kostString) =>
                Map<String, String>.from(jsonDecode(kostString)))
            .toList();
      });
    }
  }

  // Fungsi untuk memuat data saved kost dari SharedPreferences
  Future<void> _loadSavedKostData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedKostStringList = prefs.getStringList('savedKostList');
    if (savedKostStringList != null) {
      setState(() {
        savedKostList = savedKostStringList
            .map((kostString) =>
                Map<String, String>.from(jsonDecode(kostString)))
            .toList();
      });
    }
  }

  // Fungsi untuk menambahkan atau menghapus bookmark
  void _toggleSave(int index) async {
    final kost = kostList[index];
    final isSaved = savedKostList.contains(kost);
    setState(() {
      if (isSaved) {
        savedKostList.remove(kost);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Postingan dihapus dari bookmark')),
        );
      } else {
        savedKostList.add(kost);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Postingan ditambahkan ke bookmark')),
        );
      }
    });
    _saveSavedKostData(); // Simpan data saved kost yang diperbarui
  }

  void _onItemTapped(int index) async {
    if (index == 1) {
      // Navigasi ke halaman tambah kost dan terima data
      final newKost =
          await Navigator.pushNamed(context, '/add') as Map<String, String>?;
      if (newKost != null) {
        setState(() {
          kostList.add(newKost); // Tambahkan data kost baru ke list
        });
        _saveKostData(); // Simpan data setelah ditambahkan
      }
    } else if (index == 2) {
      // Navigasi ke halaman profil
      Navigator.pushNamed(context, '/profil'); // Navigate to the Profil Page
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA8E6CF), // Warna hijau pastel
        title: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari Kost...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white, // Warna latar belakang text field
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.bookmark),
              onPressed: () {
                Navigator.pushNamed(
                    context, '/saved'); // Navigasi ke halaman saved
              },
            ),
          ],
        ),
      ),
      body: kostList.isEmpty
          ? const Center(
              child: Text(
                'Selamat datang di Aplikasi Kost!',
                style: TextStyle(fontSize: 24),
              ),
            )
          : ListView.builder(
              itemCount: kostList.length,
              itemBuilder: (context, index) {
                final kost = kostList[index];
                final isSaved = savedKostList.contains(kost);
                return Card(
                  margin: const EdgeInsets.all(10),
                  color: const Color(
                      0xFFE8F5E9), // Warna latar belakang setiap item
                  child: ListTile(
                    leading: kost['image'] != null && kost['image']!.isNotEmpty
                        ? Image.file(
                            File(kost['image']!),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image,
                            size: 50), // Jika gambar tidak tersedia
                    title: Text(kost['nama']!,
                        style: const TextStyle(
                            color: Colors.black)), // Menampilkan nama kost
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Alamat: ${kost['alamat']}',
                            style: const TextStyle(
                                color: Colors.black)), // Alamat kost
                        Text('No. HP: ${kost['noHp']}',
                            style: const TextStyle(
                                color: Colors.black)), // Nomor HP pemilik kost
                        Text('Deskripsi: ${kost['deskripsi']}',
                            style: const TextStyle(
                                color: Colors.black)), // Deskripsi kost
                        Text('Fasilitas: ${kost['fasilitas']}',
                            style: const TextStyle(
                                color: Colors.black)), // Fasilitas kost
                        Text('Harga: Rp${kost['harga']}',
                            style: const TextStyle(
                                color: Colors.black)), // Harga kost
                      ],
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                      ),
                      onPressed: () =>
                          _toggleSave(index), // Tambah atau hapus bookmark
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:
            const Color(0xFF388E3C), // Warna hijau gelap untuk item terpilih
        unselectedItemColor: const Color(
            0xFFB2DFDB), // Warna hijau muda untuk item tidak terpilih
        onTap: _onItemTapped,
      ),
    );
  }
}
