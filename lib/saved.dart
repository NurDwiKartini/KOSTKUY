// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Untuk mengonversi List ke String dan sebaliknya

class SavedPage extends StatefulWidget {
  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  List<Map<String, String>> savedKostList =
      []; // List untuk menyimpan data kost yang di-bookmark

  @override
  void initState() {
    super.initState();
    _loadSavedKostData(); // Memuat data saved kost yang tersimpan
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

  // Fungsi untuk menghapus bookmark
  void _removeSavedKost(int index) async {
    setState(() {
      savedKostList.removeAt(index);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedKostStringList =
        savedKostList.map((kost) => jsonEncode(kost)).toList();
    await prefs.setStringList('savedKostList', savedKostStringList);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Postingan dihapus dari bookmark')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA8E6CF), // Warna hijau pastel
        title: const Text('Bookmark Kost',
            style: TextStyle(color: Colors.black)), // Mengubah warna teks
      ),
      body: savedKostList.isEmpty
          ? const Center(
              child: Text(
                'Tidak ada postingan yang di-bookmark',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: savedKostList.length,
              itemBuilder: (context, index) {
                final kost = savedKostList[index];
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
                      icon: const Icon(Icons.delete,
                          color: Colors.red), // Mengubah warna ikon hapus
                      onPressed: () =>
                          _removeSavedKost(index), // Hapus bookmark
                    ),
                  ),
                );
              },
            ),
    );
  }
}
