import 'dart:io';
import 'package:age_play/pages/search.dart';
import 'package:flutter/material.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        // title: const Text('Hasil Deteksi'),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 0), // Spasi di bagian atas
            Text(
              "Hasil Deteksi",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            // Menampilkan gambar dengan bingkai
            Container(
              width: screenWidth * 0.4,
              height: screenHeight * 0.26,
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.blue, width: 3), // Border biru
                borderRadius: BorderRadius.circular(12), // Melengkung
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            // Informasi Deteksi
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Usia",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Jenis Kelamin",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(width: 150),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("21 tahun"), // Contoh data
                    SizedBox(height: 10),
                    Text("Laki - laki"), // Contoh data
                  ],
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.04),
            // Rekomendasi Game
            SizedBox(
              child: Container(
                width: screenWidth * 0.8,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(1000, 223, 223, 223), // Background abu-abu muda
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Rekomendasi Game",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // List Rekomendasi Game
                    Column(
                      children: [
                        GameRecommendation(
                          imageName: 'assets/persona3.jpg',
                          title: 'Persona 3 Reload',
                          price: 'Rp 779.000',
                          publisher: 'ATLUS',
                          tags: 'JRPG, RPG Anime',
                        ),
                        SizedBox(height: 10),
                        GameRecommendation(
                          imageName: 'assets/persona3.jpg',
                          title: 'Persona 3 Reload',
                          price: 'Rp 779.000',
                          publisher: 'ATLUS',
                          tags: 'JRPG, RPG Anime',
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Tombol Lainnya
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => SearchPage(previousPage: 'hasil deteksi',)),
                          );
                        },
                        child: Text("Lainnya"),
                        style: ElevatedButton.styleFrom(
                          iconColor: Colors.blue, // Warna tombol
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameRecommendation extends StatelessWidget {
  final String imageName;
  final String title;
  final String price;
  final String publisher;
  final String tags;

  const GameRecommendation({
    required this.imageName,
    required this.title,
    required this.price,
    required this.publisher,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 59, 59, 59).withOpacity(0.4), // Warna shadow dengan transparansi
                spreadRadius: 2, // Penyebaran shadow
                blurRadius: 5, // Tingkat blur shadow
                offset: Offset(0, 3), // Posisi shadow (x, y)
              ),
            ],
            borderRadius: BorderRadius.circular(8), // Pastikan sesuai dengan ClipRRect
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imageName,
              width: screenWidth * 0.3,
              height: screenHeight * 0.075,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              price,
              style: TextStyle(color: Colors.green),
            ),
            SizedBox(height: 6),
            Text(
              publisher,
              style: TextStyle(color: Colors.black),
            ),
            Text(
              tags, // Genre game
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }
}
