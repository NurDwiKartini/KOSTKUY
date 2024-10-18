// add.dart
// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, depend_on_referenced_packages, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  File? _image; // Variable to store the selected image
  final ImagePicker _picker = ImagePicker();

  // Controllers untuk form input
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _fasilitasController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA8E6CF), // Warna hijau pastel
        title: const Text('Tambah Kost Baru',
            style: TextStyle(color: Colors.black)), // Mengubah warna teks
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_upload,
                color: Colors.black), // Mengubah warna ikon
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Aksi unggah data (misalnya simpan ke database)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data berhasil diunggah')),
                );
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: const Color(0xFFE8F5E9), // Warna latar belakang
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  SizedBox(
                      height:
                          100), // Memberi jarak agar form tidak tertutup button foto
                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(labelText: 'Nama Kost'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama Kost tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _alamatController,
                    decoration: const InputDecoration(labelText: 'Alamat Kost'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Alamat Kost tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _noHpController,
                    decoration: const InputDecoration(labelText: 'No. HP'),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nomor HP tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _deskripsiController,
                    decoration: const InputDecoration(labelText: 'Deskripsi'),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Deskripsi tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _fasilitasController,
                    decoration: const InputDecoration(labelText: 'Fasilitas'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Fasilitas tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _hargaController,
                    decoration: const InputDecoration(labelText: 'Harga'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harga tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                          0xFF81C784), // Warna hijau pastel untuk tombol
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Data berhasil divalidasi, sekarang kita kirim ke HomePage
                        Navigator.pop(context, {
                          'nama': _namaController.text,
                          'alamat': _alamatController.text,
                          'noHp': _noHpController.text,
                          'deskripsi': _deskripsiController.text,
                          'fasilitas': _fasilitasController.text,
                          'harga': _hargaController.text,
                          'image':
                              _image?.path ?? '', // Path gambar yang dipilih
                        });
                      }
                    },
                    child: const Text('Simpan'),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: MediaQuery.of(context).size.width / 2 -
                50, // Posisikan di tengah layar
            child: Column(
              children: [
                // Button Upload Foto
                ElevatedButton.icon(
                  onPressed: () {
                    _showImageSourceActionSheet(context);
                  },
                  icon: const Icon(Icons.photo_camera),
                  label: const Text('Upload Foto'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: const Color(0xFF81C784),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20), // Warna hijau pastel untuk tombol
                  ),
                ),
                const SizedBox(height: 10),
                // Display the selected image
                _image != null
                    ? Image.file(
                        _image!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : const Text('Belum ada foto terpilih'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to show action sheet for selecting image source
  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeri'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Kamera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
