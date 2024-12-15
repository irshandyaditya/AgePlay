import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GameDetailsPage extends StatefulWidget {
  final String slug;

  GameDetailsPage({required this.slug});

  @override
  _GameDetailsPageState createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends State<GameDetailsPage> {
  final storage = const FlutterSecureStorage();
  Map<String, dynamic>? gameDetails;
  List<dynamic>? storeLinks;
  final Map<int, String> storeNames = {
    1: 'Steam',
    2: 'Xbox Store',
    3: 'PlayStation Store',
    4: 'App Store',
    5: 'GOG',
    6: 'Nintendo Store',
    7: 'Xbox 360 Store',
    8: 'Google Play',
    9: 'itch.io',
    11: 'Epic Games',
  };

  bool isBookmarked = false;
  String? _id;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
  await _loadProfileData(); // Tunggu hingga data profil selesai dimuat
  fetchGameDetails();
  checkBookmarkStatus(); // Panggil setelah _id berhasil diperbarui
}

  Future<void> _loadProfileData() async {
    final id = await storage.read(key: 'id');

    setState(() {
      _id = id ?? '0';
    });
  }

Future<void> checkBookmarkStatus() async {
  try {
    final url = "https://polinemaesports.my.id/api/bookmark/check/";
    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['id_game'] = widget.slug;
    request.fields['akun_id'] = _id ?? '0';

    // Log data yang dikirim
    print("Sending request to $url with fields: ${request.fields}");

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final responseData = json.decode(responseBody);
      if (responseData['success'] == true) {
        setState(() {
          isBookmarked = responseData['isBookmarked'];
        });
      } else {
        print("Failed to check bookmark status: ${responseData['message']}");
      }
    } else {
      print("HTTP error: ${response.statusCode}");
    }
  } catch (e) {
    print("Error checking bookmark status: $e");
  }
}


  Future<void> toggleBookmark() async {
    try {
      final url = isBookmarked
          ? "https://polinemaesports.my.id/api/bookmark/delete/"
          : "https://polinemaesports.my.id/api/bookmark/save/";

      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['id_game'] = widget.slug;
      request.fields['akun_id'] = _id ?? '';

      print("Request to $url with fields: ${request.fields}");

      final response = await request.send();

      final responseBody = await response.stream.bytesToString();
      print("Response status: ${response.statusCode}");
      print("Response body: $responseBody");

      if (response.statusCode == 200) {
        final responseData = json.decode(responseBody);
        setState(() {
          isBookmarked = !isBookmarked;
        });

        final message = responseData['message'] ?? "Success";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.green,),
        );
      } else {
        print(
            "Failed to toggle bookmark. Status: ${response.statusCode}, Body: $responseBody");
      }
    } catch (e) {
      print("Error toggling bookmark: $e");
    }
  }

  Future<void> fetchGameDetails() async {
    setState(() {
      gameDetails = null; // Reset game details
      storeLinks = null; // Reset store links
    });

    try {
      final responses = await Future.wait([
        http.get(Uri.parse(
            'https://polinemaesports.my.id/api/game-details/${widget.slug}')),
        http.get(Uri.parse(
            'https://polinemaesports.my.id/api/game-storelinks/${widget.slug}')),
      ]);

      if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
        setState(() {
          gameDetails = json.decode(responses[0].body);
          final storeData = json.decode(responses[1].body);
          storeLinks = storeData['results'] ?? []; // Ambil store links
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        gameDetails = {}; // Set sebagai default kosong
        storeLinks = [];
      });
    }
  }

  Future<bool> doesAssetExist(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<List<Widget>> _buildPlatformIcons(List<dynamic>? platforms) async {
    if (platforms == null) return [];

    List<Widget> icons = [];
    for (var platform in platforms) {
      final platformSlug = platform['platform']['slug'];
      final assetPath = 'assets/icons/$platformSlug.png';

      if (await doesAssetExist(assetPath)) {
        icons.add(
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Image.asset(
              assetPath,
              width: 20,
              height: 20,
            ),
          ),
        );
      }
    }

    return icons;
  }

Future<List<Widget>> _buildCategoryIcons(List<dynamic>? genres) async {
  if (genres == null) return [];

  List<Widget> categories = [];
  for (var genre in genres) {
    final genreSlug = genre['slug']; // Mengambil slug genre
    final genrePath = 'assets/categories/$genreSlug.png';

    // Memeriksa apakah aset ada
    final assetExists = await doesAssetExist(genrePath);

    categories.add(
      Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(14),
            child: assetExists
                ? Image.asset(
                    genrePath,
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                  )
                : Icon(
                    Icons.sports_esports,
                    color: Colors.white,
                    size: 30,
                  ),
          ),
          SizedBox(height: 4),
          SizedBox(
            width: 62,
            height: 40, // Sesuaikan dengan lebar kontainer di atas
            child: Text(
              genre['name'] ?? '',
              style: TextStyle(fontSize: 14),
              maxLines: 2, // Maksimal dua baris teks
              overflow: TextOverflow.ellipsis, // Tambahkan "..." jika teks terpotong
              textAlign: TextAlign.center, // Pusatkan teks
              softWrap: true, // Bungkus otomatis jika teks terlalu panjang
            ),
          ),
        ],
      ),
    );
  }
  return categories;
}


  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication, // Membuka aplikasi eksternal
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (gameDetails == null || storeLinks == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.red)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
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
                            onTap: toggleBookmark,
                            child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) {
                                return ScaleTransition(
                                    scale: animation, child: child);
                              },
                              child: Container(
                                key: ValueKey<bool>(isBookmarked),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isBookmarked
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: Colors.red,
                                ),
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
                                  'Not Rated', // Menampilkan ESRB Rating atau N/A jika null
                              style: TextStyle(
                                color: Colors.white, // Warna teks
                                fontSize: 14, // Ukuran teks
                                fontWeight: FontWeight.bold, // Teks lebih tebal
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          FutureBuilder<List<Widget>>(
                            future: _buildPlatformIcons(
                                gameDetails?['parent_platforms']),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(color: Colors.red,);
                              } else if (snapshot.hasData) {
                                return Row(children: snapshot.data!);
                              } else {
                                return SizedBox();
                              }
                            },
                          ),
                          SizedBox(height: 4),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                              gameDetails?['name'] ?? 'Unknown Game Name',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
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
                  FutureBuilder<List<Widget>>(
                    future: _buildCategoryIcons(gameDetails?['genres']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(color: Colors.red,);
                      } else if (snapshot.hasData) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: snapshot.data!,
                        );
                      } else {
                        return SizedBox();
                      }
                    },
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
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Download/Purchase Links:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  if (storeLinks!.isEmpty)
                    Center(
                      child: Text(
                        'No store links available.',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var link in storeLinks!)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  _launchURL(link['url']);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 8.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4.0,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      // Icon from assets/icons/{store_id}.png
                                      FutureBuilder<bool>(
                                        future: doesAssetExist(
                                            'assets/icons/${link['store_id']}.png'),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CircularProgressIndicator(
                                              strokeWidth: 2,
                                            );
                                          } else if (snapshot.hasData &&
                                              snapshot.data!) {
                                            return Image.asset(
                                              'assets/icons/${link['store_id']}.png',
                                              width: 24,
                                              height: 24,
                                            );
                                          } else {
                                            return Icon(
                                              Icons.store,
                                              size: 24,
                                              color: Colors.grey,
                                            );
                                          }
                                        },
                                      ),
                                      SizedBox(width: 12),
                                      // Store Name
                                      Expanded(
                                        child: Text(
                                          storeNames[link['store_id']] ??
                                              'Unknown Store',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          SizedBox(height: 24),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
