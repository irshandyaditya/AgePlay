import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:age_play/widgets/bottom_navbar.dart';

class SearchPage extends StatefulWidget {
  final String? previousPage;

  SearchPage({this.previousPage});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Map<String, dynamic>> searchResults = [];
  int _currentIndex = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  Future<void> _performSearch() async {
    if (_searchQuery.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final url =
        'https://polinemaesports.my.id/api/game-search/?query=${Uri.encodeComponent(_searchQuery)}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        setState(() {
          searchResults = results.map((item) {
            return {
              'slug': item['slug'],
              'name': item['name'],
              'platforms': item['platforms']
                  ?.map((p) => p['platform']['name'])
                  ?.toList()
                  ?.join(', ') ?? 'Unknown',
              'rating': item['rating'] ?? 'N/A',
              'genres': item['genres']
                  ?.map((g) => g['name'])
                  ?.toList()
                  ?.join(', ') ?? 'N/A',
              'esrb_rating': item['esrb_rating']?['name'] ?? 'N/A',
              'screenshot': item['short_screenshots']?.firstWhere(
                      (s) => s['id'] == -1,
                      orElse: () => null)?['image'] ??
                  'https://via.placeholder.com/150', // Default image
            };
          }).toList();
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6EAEE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: const Color(0xFF808080)),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: "Search",
                              border: InputBorder.none,
                            ),
                            onSubmitted: (_) => _performSearch(),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.clear, color: const Color(0xFF808080)),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                              searchResults.clear();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : searchResults.isEmpty
                    ? Center(
                        child: Text(
                          "No results found",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final result = searchResults[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Row(
                              children: [
                                // Game image
                                Container(
                                  width: 130,
                                  height: 78,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: NetworkImage(result["screenshot"]),
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
                                        result["name"],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Rating: ${result["rating"]}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.green,
                                        ),
                                      ),
                                      Text(
                                        "Platforms: ${result["platforms"]}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        "Genres: ${result["genres"]}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        "ESRB: ${result["esrb_rating"]}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
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
