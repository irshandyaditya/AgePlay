import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:age_play/widgets/bottom_navbar.dart';
import 'package:http/http.dart' as http;
import 'package:age_play/pages/search.dart';
import 'package:age_play/pages/game_detail.dart';
import 'package:age_play/pages/profile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = const FlutterSecureStorage();
  int _currentIndex = 0;

  String? _name;
  String? _profilePicture;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final name = await storage.read(key: 'name');
    final profilePicture = await storage.read(key: 'foto_profil');

    setState(() {
      _name = name ?? 'Unknown';
      _profilePicture = profilePicture;
    });
  }

  Future<List<Map<dynamic, dynamic>>> fetchMainGames(String? category) async {
    final box = await Hive.openBox<List>('gameCache');

    // Check if the category data is cached
    if (box.containsKey(category)) {
      return List<Map<dynamic, dynamic>>.from(box.get(category)!);
    }

    final response;
    if (category == 'Popular Genres') {
      response = await http.get(Uri.parse(
          'http://polinemaesports.my.id/api/game-lists?genres=action'));
    } else if (category == 'PC Games') {
      response = await http.get(Uri.parse(
          'http://polinemaesports.my.id/api/game-lists?parent_platforms=1'));
    } else if (category == 'For Everyone') {
      response = await http.get(
          Uri.parse('http://polinemaesports.my.id/api/game-esrb/everyone'));
    } else {
      response = await http
          .get(Uri.parse('https://polinemaesports.my.id/api/game-lists/'));
    }

    if (response.statusCode == 200) {
      final Map<dynamic, dynamic> jsonResponse = json.decode(response.body);
      List<Map<dynamic, dynamic>> result;

      if (category == 'For Everyone') {
        final List<dynamic> gameList = jsonResponse['results'];

        result = gameList.map((game) {
          return {
            'slug': game['slug'] ?? 'Unknown Slug',
            'name': game['name'] ?? 'Unknown Game',
            'image':
                game['background_image'] ?? 'https://via.placeholder.com/150',
            'platforms': game['parent_platforms']?.join(', ') ?? 'Unknown',
            'rating': game['rating']?.toString() ?? 'N/A',
            'genres': game['genres']?.join(', ') ?? 'N/A',
            'esrb_rating': game['esrb_rating'] ?? 'N/A',
          };
        }).toList();
      } else {
        final List<dynamic> gameList = jsonResponse['results'];
        result = gameList.map((game) {
          return {
            'slug': game['slug'] ?? 'Unknown Slug',
            'name': game['name'] ?? 'Unknown Game',
            'image':
                game['background_image'] ?? 'https://via.placeholder.com/150',
            'platforms': game['parent_platforms']
                    ?.map((p) => p['platform']['name'])
                    ?.toList()
                    ?.join(', ') ??
                'Unknown',
            'rating': game['rating']?.toString() ?? 'N/A',
            'genres':
                game['genres']?.map((g) => g['name'])?.toList()?.join(', ') ??
                    'N/A',
            'esrb_rating': game['esrb_rating']?['name'] ?? 'N/A',
          };
        }).toList();
      }

    await box.put(category, result);

      return result;
    } else {
      throw Exception('Failed to load games');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => Profile(),
                    transitionDuration: Duration.zero, // Durasi transisi 0
                    reverseTransitionDuration: Duration.zero, // Durasi transisi balik 0
                  ),
                );
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: _profilePicture != null
                    ? NetworkImage(
                        'https://polinemaesports.my.id/$_profilePicture')
                    : const AssetImage('assets/foto_profil.png')
                        as ImageProvider,
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: Text(
                'Welcome, ${_name ?? 'Loading...'}',
                style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 111, 111, 111)),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search,
                  color: const Color.fromARGB(255, 111, 111, 111)),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        SearchPage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              FutureBuilder<List<Map<dynamic, dynamic>>>(
                  future: fetchMainGames('Main'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                            color: Color.fromARGB(255, 255, 0, 0)),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Error: ${snapshot.error}'),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {}); // Trigger reload
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text('Retry',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No games found'));
                    }
                    final games = snapshot.data!;
                    final topGames = games.take(5).toList();
                    return Container(
                      height: screenHeight * 0.45,
                      child: PageView.builder(
                        controller: PageController(viewportFraction: 0.98),
                        itemCount: topGames.length,
                        itemBuilder: (context, index) {
                          final game = topGames[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      GameDetailsPage(slug: game['slug']),
                                ),
                              );
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: screenHeight * 0.3,
                                    width: screenWidth,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 0,
                                          blurRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                      child: Image.network(
                                        game['image'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(16),
                                        bottomRight: Radius.circular(16),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                game['name'],
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.orange,
                                                  size: 15,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  game['rating'],
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.orange,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "Platforms: ${game['platforms']}",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          "Genres: ${game['genres']}",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          "ESRB: ${game['esrb_rating']}",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey,
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
                    );
                  }),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 16.0),
                child: Text("Popular Genres",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              FutureBuilder<List<Map<dynamic, dynamic>>>(
                future: fetchMainGames('Popular Genres'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 255, 0, 0)),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Error: ${snapshot.error}'),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {}); // Trigger reload
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text('Retry',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No games found'));
                  }

                  final games = snapshot.data!;
                  final pcGames = games.take(10).toList();

                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.29,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: pcGames.length,
                      itemBuilder: (context, index) {
                        final game = pcGames[index];

                        return PopularItem(
                          slug: game['slug'],
                          imageUrl: game['image'],
                          title: game['name'] ?? 'Unknown Name',
                          platform: game['platforms'],
                          subtitle: game['genres'] ?? 'Unknown Genres',
                          esrb: game['esrb_rating'] ?? 'Unknown Publisher',
                          rating: double.tryParse(
                                  game['rating']?.toString() ?? '') ??
                              0.0,
                        );
                      },
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 16.0),
                child: Text("PC Games",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              FutureBuilder<List<Map<dynamic, dynamic>>>(
                future: fetchMainGames('PC Games'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 255, 0, 0)),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Error: ${snapshot.error}'),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {}); // Trigger reload
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text('Retry',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No games found'));
                  }

                  final games = snapshot.data!;
                  final pcGames = games.take(10).toList();

                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.29,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: pcGames.length,
                      itemBuilder: (context, index) {
                        final game = pcGames[index];

                        return PopularItem(
                          slug: game['slug'],
                          imageUrl: game['image'],
                          title: game['name'] ?? 'Unknown Name',
                          platform: game['platforms'],
                          subtitle: game['genres'] ?? 'Unknown Genres',
                          esrb: game['esrb_rating'] ?? 'Unknown Publisher',
                          rating: double.tryParse(
                                  game['rating']?.toString() ?? '') ??
                              0.0,
                        );
                      },
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 16.0),
                child: Text("For Everyone",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              FutureBuilder<List<Map<dynamic, dynamic>>>(
                future: fetchMainGames('For Everyone'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 255, 0, 0)),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Error: ${snapshot.error}'),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {}); // Trigger reload
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text('Retry',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No games found'));
                  }

                  final games = snapshot.data!;
                  final games3 = games.toList();

                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.29,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: games3.length,
                      itemBuilder: (context, index) {
                        final game = games3[index];

                        return PopularItem(
                          slug: game['slug'],
                          imageUrl: game['image'],
                          title: game['name'] ?? 'Unknown Name',
                          platform: game['platforms'],
                          subtitle: game['genres'] ?? 'Unknown Genres',
                          esrb: game['esrb_rating'] ?? 'Not Rated',
                          rating: double.tryParse(
                                  game['rating']?.toString() ?? '') ??
                              0.0,
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/camera');
        },
        elevation: 0,
        shape: CircleBorder(),
        child: Icon(Icons.camera_alt_outlined, color: Colors.white),
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

class PopularItem extends StatelessWidget {
  final String slug;
  final String imageUrl;
  final String title;
  final String subtitle;
  final String platform;
  final String esrb;
  final double rating;

  PopularItem({
    required this.slug,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.platform,
    required this.esrb,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameDetailsPage(slug: slug),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    height: MediaQuery.of(context).size.height * 0.12,
                    width: MediaQuery.of(context).size.width * 0.4,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.12,
                        width: MediaQuery.of(context).size.width * 0.4,
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow, size: 16),
                        SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 2),
            Wrap(
              spacing: 4,
              runSpacing: 2,
              children: platform.split(',').map((p) {
                return Text(
                  p.trim(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2),
            Flexible(
              child: Text(
                'ESRB: ' + esrb,
                style: TextStyle(fontSize: 10, color: Colors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoBadge extends StatelessWidget {
  final Icon icon;
  final String text;

  InfoBadge({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          icon,
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
