import 'dart:convert';
import 'dart:io';
import 'package:age_play/pages/home_page.dart';
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

Map<String, dynamic> determineEsrbAndGenre(String? age, String? gender) {
  if (age == null || gender == null) {
    return {'esrb': 'everyone', 'genre': ['casual']};
  }

  if (age == "0-10" && gender.toLowerCase() == "male") {
    return {'esrb': 'everyone', 'genre': 'platformer,puzzle,adventure'};
  }
  if (age == "0-10" && gender.toLowerCase() == "female") {
    return {'esrb': 'everyone', 'genre': 'simulation,adventure,puzzle'};
  }

  if (age == "11-15" && gender.toLowerCase() == "male") {
    return {'esrb': 'everyone-10-plus', 'genre': 'action,shooter,sports'};
  }
  if (age == "11-15" && gender.toLowerCase() == "female") {
    return {'esrb': 'everyone-10-plus', 'genre': 'simulation,adventure,educational'};
  }

  if (age == "16-20" && gender.toLowerCase() == "male") {
    return {'esrb': 'teen', 'genre': 'role-playing-games-rpg,shooter,fighting'};
  }
  if (age == "16-20" && gender.toLowerCase() == "female") {
    return {'esrb': 'teen', 'genre': 'role-playing-games-rpg,simulation,educational'};
  }

  if (age == "21-30" && gender.toLowerCase() == "male") {
    return {'esrb': 'mature', 'genre': 'shooter,strategy,massively-multiplayer'};
  }
  if (age == "21-30" && gender.toLowerCase() == "female") {
    return {'esrb': 'mature', 'genre': 'role-playing-games-rpg,adventure'};
  }

  if (age == "31-50" && gender.toLowerCase() == "male") {
    return {'esrb': 'mature', 'genre': 'strategy,simulation,shooter'};
  }
  if (age == "31-50" && gender.toLowerCase() == "female") {
    return {'esrb': 'mature', 'genre': 'simulation,puzzle,educational'};
  }

  if (age == "51-100" && gender.toLowerCase() == "male") {
    return {'esrb': 'everyone', 'genre': 'card,strategy,casual'};
  }
  if (age == "51-100" && gender.toLowerCase() == "female") {
    return {'esrb': 'everyone', 'genre': 'puzzle,board-games,casual'};
  }

  return {'esrb': 'adults-only', 'genre': 'casual'};
}

Future<List<dynamic>> fetchGameRecommendations(String? age, String? gender) async {
  final esrbAndGenre = determineEsrbAndGenre(age, gender);
  final esrb = esrbAndGenre['esrb'];
  final genres = esrbAndGenre['genre'];
  final url = Uri.parse('https://polinemaesports.my.id/api/game-esrb/$esrb?genres=$genres'); 
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
    final esrbRating = determineEsrbAndGenre(age, gender);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // automaticallyImplyLeading: false,
        leading:  IconButton(
          icon: Icon(Icons.home, color: const Color.fromARGB(255, 111, 111, 111),), // Ganti ikon di sini
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()), // Sesuaikan dengan halaman utama Anda
              (Route<dynamic> route) => false,
            );
          },
        ),
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
                  key: ValueKey(imagePath),
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
              future: fetchGameRecommendations(age, gender),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(color: Colors.red,);
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
                                        imageName:
                                            game['background_image'] ?? '',
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
                                          esrb: esrbRating['esrb'],
                                          genres: esrbRating['genre'],
                                        )),
                              );
                            },
                            child: Text(
                              "Lainnya",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: [
                  Text(
                    platform.join(', '),
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ],
              ),
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: [
                  Text(
                    genre.join(', '),
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                    maxLines: 3,
                  ),
                ],
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
        ),
      ],
    );
  }
}
