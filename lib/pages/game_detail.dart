import 'package:flutter/material.dart';

class GameDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Gambar latar belakang
                Container(
                  height: MediaQuery.of(context).size.height *
                      0.5, // Setengah layar
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/tekken.png'), // Ganti dengan path gambar Anda
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Icon Back, Send, dan Love di atas gambar
                Positioned(
                  top:
                      40, // Jarak dari atas layar (untuk menyesuaikan dengan status bar)
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Icon Back
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(
                              context); // Kembali ke halaman sebelumnya
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(
                                0.5), // Background gelap transparan
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.red, // Warna merah
                          ),
                        ),
                      ),
                      // Icon Send dan Love
                      Row(
                        children: [
                          // Icon Send
                          GestureDetector(
                            onTap: () {
                              // Tambahkan logika ketika icon Send ditekan
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.send,
                                color: Colors.red, // Warna merah
                              ),
                            ),
                          ),
                          // Icon Love
                          GestureDetector(
                            onTap: () {
                              // Tambahkan logika ketika icon Love ditekan
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.favorite_border,
                                color: Colors.red, // Warna merah
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Konten di bawah gambar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Game dan Developer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TEKKEN 8',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Bandai Namco',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      // Rating
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.orange,
                            size: 20,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '4.3',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Barisan Ikon dan Label
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Arcade Icon
                      Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.sports_esports, // Ikon Arcade
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Arcade',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      // 16+ Icon
                      Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.whatshot, // Ikon 16+
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '16+',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      // Multiplayer Icon
                      Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.group, // Ikon Multiplayer
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Multiplayer',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      // Fighting Icon
                      Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.sports_mma, // Ikon Fighting
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Fighting',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'PC Requirements:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '''
Minimum:
- OS: Windows 10 64-bit
- Processor: Intel Core i5-6600K / AMD Ryzen 5 1600
- Memory: 8 GB RAM
- Graphics: Nvidia GTX 1050Ti / AMD Radeon RX 380X
- DirectX: Version 12
                    ''',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '''
Recommended:
- OS: Windows 10 64-bit
- Processor: Intel Core i7 / AMD Ryzen 7
- Memory: 16 GB RAM
- Graphics: Nvidia RTX 3060 / AMD RX 6700 XT
- DirectX: Version 12
                    ''',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryBadge extends StatelessWidget {
  final String title;

  const CategoryBadge(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
