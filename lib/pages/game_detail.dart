import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GameDetailsPage extends StatefulWidget {
  final String slug;

  GameDetailsPage({required this.slug});
  
  @override
  _GameDetailsPageState createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends State<GameDetailsPage> {
  Map<String, dynamic>? gameDetails;

  @override
  void initState() {
    super.initState();
    fetchGameDetails();
  }

  Future<void> fetchGameDetails() async {
    try {
      final response = await http.get(
        Uri.parse('https://polinemaesports.my.id/api/game-details/${widget.slug}'),
      );
      if (response.statusCode == 200) {
        setState(() {
          gameDetails = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load game details');
      }
    } catch (e) {
      print('Error fetching game details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (gameDetails == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Background image
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          NetworkImage(gameDetails?['background_image'] ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Icons on top of the image
                Positioned(
                  top: 40,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
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
                                color: Colors.red,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.favorite_border,
                                color: Colors.red,
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ESRB Rating Box
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors
                                  .redAccent, // Warna latar belakang kotak
                              borderRadius: BorderRadius.circular(
                                  8), // Membuat sudut melengkung
                            ),
                            child: Text(
                              gameDetails?['esrb_rating']?['name'] ??
                                  '13+', // Menampilkan ESRB Rating atau N/A jika null
                              style: TextStyle(
                                color: Colors.white, // Warna teks
                                fontSize: 14, // Ukuran teks
                                fontWeight: FontWeight.bold, // Teks lebih tebal
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            gameDetails?['name'] ?? 'Unknown',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            (gameDetails?['publishers']?.isNotEmpty ?? false)
                                ? gameDetails!['publishers'][0]['name']
                                : 'Unknown Publisher',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.orange,
                            size: 20,
                          ),
                          SizedBox(width: 4),
                          Text(
                            (gameDetails?['rating'] ?? 0).toString(),
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
                  // Genres and ESRB Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      for (var genre in gameDetails?['genres'] ?? [])
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
                                Icons.sports_esports,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              genre['name'] ?? '',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Spec Requirements:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    gameDetails?['platforms']?[0]?['requirements']
                            ?['minimum'] ??
                        'N/A',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    gameDetails?['platforms']?[0]?['requirements']
                            ?['recommended'] ??
                        'N/A',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    gameDetails?['description_raw'] ??
                        'No description available.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Website:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    gameDetails?['website'] ?? 'N/A',
                    style: TextStyle(
                      fontSize: 14,
                      decoration: TextDecoration.underline,
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
