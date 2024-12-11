import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:age_play/pages/search.dart';
import 'package:age_play/pages/game_detail.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final String? age;
  final String? gender;
  const DisplayPictureScreen(
      {super.key,
      required this.imagePath,
      required this.age,
      required this.gender});

  String determineEsrbRating(String? age) {
    if (age == null) return 'adults-only';
    if (age == "0-3 years" || age == "4-7 years") return 'everyone';
    if (age == "8-12 years") return 'everyone-10-plus';
    if (age == "13-17 years") return 'teen';
    if (age == "18-25 years") return 'mature';
    if (age == "26-35 years") return 'adults-only';
    return 'adults-only';
  }

  Future<List<dynamic>> fetchGameRecommendations(String esrb) async {
    final url = Uri.parse('https://polinemaesports.my.id/api/game-esrb/$esrb');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['results'] as List<dynamic>;
      } else {
        throw Exception('Failed to fetch games');
      }
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final esrbRating = determineEsrbRating(age);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 0),
            Text(
              "Hasil Deteksi",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Container(
              width: screenWidth * 0.4,
              height: screenHeight * 0.26,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
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
                    Text(age ?? '-'),
                    SizedBox(height: 10),
                    Text(gender ?? '-'),
                  ],
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.04),
            FutureBuilder<List<dynamic>>(
              future: fetchGameRecommendations(esrbRating),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError ||
                    snapshot.data == null ||
                    snapshot.data!.isEmpty) {
                  return Text("Tidak ada rekomendasi game.");
                } else {
                  return Container(
                    width: screenWidth * 0.8,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(1000, 223, 223, 223),
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
                        Column(
                          children: snapshot.data!
                              .map((game) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GameDetailsPage(
                                          slug: game['slug'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      GameRecommendation(
                                        imageName: game['background_image'] ?? '',
                                        title: game['name'] ?? '-',
                                        platform: (game['parent_platforms']
                                                as List<dynamic>)
                                            .map((e) => e.toString())
                                            .toList(),
                                        genre: (game['genres'] as List<dynamic>)
                                            .map((e) => e.toString())
                                            .toList(),
                                        rating:
                                            'Rating: ${game['rating'] ?? '-'}',
                                        publisher:
                                            'ESRB: ${game['esrb_rating'] ?? '-'}',
                                        tags: '',
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                );
                              })
                              .take(2)
                              .toList(),
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchPage(
                                          previousPage: 'hasil deteksi',
                                        )),
                              );
                            },
                            child: Text("Lainnya"),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
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
  final List<String> platform;
  final List<String> genre;
  final String rating;
  final String publisher;
  final String tags;

  const GameRecommendation({
    required this.imageName,
    required this.title,
    required this.platform,
    required this.genre,
    required this.rating,
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
                color: const Color.fromARGB(255, 59, 59, 59).withOpacity(0.4),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
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
              platform.join(', '),
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
            Text(
              genre.join(', '),
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              rating,
              style: TextStyle(color: Colors.green),
            ),
            Text(
              publisher,
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ],
        ),
      ],
    );
  }
}
