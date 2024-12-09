import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:age_play/widgets/bottom_navbar.dart';
import 'package:age_play/pages/game_detail.dart';

class BookmarkPage extends StatefulWidget {
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  int _currentIndex = 2;
  bool _isLoading = true;
  List<dynamic> bookmarks = [];
  List<Map<String, dynamic>> gameDetails = [];

  @override
  void initState() {
    super.initState();
    _fetchBookmarks();
  }

  Future<void> _fetchBookmarks() async {
    final id = await storage.read(key: 'id');
    if (id == null) {
      print("Error: No ID found in storage");
      return;
    }

    final url = 'https://polinemaesports.my.id/api/bookmark/list/$id';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          bookmarks = data['bookmarks'];
          await _fetchGameDetails();
        } else {
          print("Failed to fetch bookmarks: ${data['message']}");
        }
      } else {
        print("Failed to fetch data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchGameDetails() async {
    List<Map<String, dynamic>> details = [];
    for (var bookmark in bookmarks) {
      final gameId = bookmark['id_game'];
      final url =
          'https://polinemaesports.my.id/api/game-details/${Uri.encodeComponent(gameId)}';
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          details.add({
            'slug': data['slug'] ?? gameId,
            'name': data['name'] ?? "Unknown Game",
            'image': data['background_image'] ?? 'https://via.placeholder.com/150',
            'platforms': data['platforms']
                    ?.map((p) => p['platform']['name'])
                    ?.toList()
                    ?.join(', ') ??
                'Unknown',
            'rating': data['rating'] ?? 'N/A',
          });
        } else {
          print("Failed to fetch details for game ID: $gameId");
        }
      } catch (e) {
        print("Error fetching details for game ID $gameId: $e");
      }
    }
    setState(() {
      gameDetails = details;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Bookmark",
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : gameDetails.isEmpty
              ? Center(child: Text("No bookmarks found."))
              : ListView.builder(
                  itemCount: gameDetails.length,
                  itemBuilder: (context, index) {
                    final item = gameDetails[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameDetailsPage(slug: item['slug']),
                            ),
                          );
                        },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Row(
                          children: [
                            // Game image
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.height * 0.09,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(item['image']),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16),
                            // Game info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item["name"],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Platforms: ${item["platforms"]}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "Rating: ${item["rating"]}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/camera');
        },
        elevation: 0,
        shape: CircleBorder(),
        child: Icon(
          Icons.camera_alt_outlined,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBarWidget(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
