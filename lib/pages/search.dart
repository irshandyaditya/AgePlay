import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:age_play/widgets/bottom_navbar.dart';
import 'package:age_play/pages/game_detail.dart';
import 'package:age_play/pages/filter.dart';

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
  bool _isFilterApplied = false;
  Map<String, String>? _filterData;

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
    setState(() {
      _isLoading = true;
    });

    // Siapkan URL dan parameter filter
    final url = Uri.parse('https://polinemaesports.my.id/api/game-lists/');
    final params = {
      'search': _searchQuery,
      if (_filterData?['genres'] != null) 'genres': _filterData!['genres']!,
      if (_filterData?['parent_platforms'] != null)
        'parent_platforms': _filterData!['parent_platforms']!,
      if (_filterData?['stores'] != null) 'stores': _filterData!['stores']!,
      if (_filterData?['developers'] != null)
        'developers': _filterData!['developers']!,
    };

    try {
      final response = await http.get(url.replace(queryParameters: params));
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
                      ?.join(', ') ??
                  'Unknown',
              'rating': item['rating'] ?? 'N/A',
              'genres':
                  item['genres']?.map((g) => g['name'])?.toList()?.join(', ') ??
                      'N/A',
              'esrb_rating': item['esrb_rating']?['name'] ?? 'N/A',
              'screenshot': item['short_screenshots']?.firstWhere(
                      (s) => s['id'] == -1,
                      orElse: () => null)?['image'] ??
                  'https://via.placeholder.com/150',
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

  void _applyFilter() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FilterPage()),
    ).then((result) {
      if (result != null && result is Map<String, String>) {
        setState(() {
          _isFilterApplied = true;
          _filterData = result; // Simpan filter data
        });
        _performSearch(); // Lakukan pencarian dengan filter baru
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding to avoid overlap with status bar
          SizedBox(height: MediaQuery.of(context).padding.top + 8),
          // Search bar with filter button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                          icon:
                              Icon(Icons.clear, color: const Color(0xFF808080)),
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
                SizedBox(width: 8),
                // Filter button
                Container(
                  decoration: BoxDecoration(
                    color:
                        _isFilterApplied ? Colors.red : const Color(0xFFE6EAEE),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: _applyFilter,
                    icon: Icon(Icons.tune_rounded,
                        color: _isFilterApplied ? Colors.white : Colors.black),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          if (_isFilterApplied && _filterData != null) ...[
            // Show applied filter info
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      [
                        if (_filterData!['genres'] != null &&
                            _filterData!['genres'] != '')
                          'Genre: ${_filterData!['genres']}',
                        if (_filterData!['parent_platforms'] != null &&
                            _filterData!['parent_platforms'] != '')
                          'Platforms: ${_filterData!['parent_platforms']}',
                        if (_filterData!['stores'] != null &&
                            _filterData!['stores'] != '')
                          'Stores: ${_filterData!['stores']}',
                      ].join(', '),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.clear, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _isFilterApplied = false;
                        _filterData = null;
                        searchResults
                            .clear(); // clear seluruh result dan search
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.red))
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
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      GameDetailsPage(slug: result["slug"]),
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    height: MediaQuery.of(context).size.height *
                                        0.09,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image:
                                            NetworkImage(result["screenshot"]),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          result["name"],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.star,
                                                color: Colors.orange, size: 15),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "${result["rating"]}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "Platforms: ${result["platforms"]}",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          "Genres: ${result["genres"]}",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          "ESRB: ${result["esrb_rating"]}",
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
