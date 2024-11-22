import 'package:flutter/material.dart';
import 'package:age_play/widgets/bottom_navbar.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Map<String, String>> searchResults = [];

  final List<Map<String, String>> allItems = [
    {
      "title": "Persona 3 Reload",
      "price": "Rp 779.000",
      "developer": "ATLUS",
      "tags": "JRPG, RPG, Anime, Adventure",
      "image": "assets/persona3.png",
    },
    // Tambahkan item lainnya sesuai kebutuhan
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  void _performSearch() {
    setState(() {
      searchResults = allItems
          .where((item) =>
              item["title"]!.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
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
                            onSubmitted: (_) =>
                                _performSearch(), // Trigger search
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
                SizedBox(width: 16),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6EAEE),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.filter_alt,
                    color: const Color(0xFF808080),
                  ),
                ),
              ],
            ),
          ),
          if (_searchQuery.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Search: $_searchQuery',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
          Expanded(
            child: _searchQuery.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          "Find the game you want here",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : searchResults.isEmpty
                    ? Center(
                        child: Text(
                          "No results found",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
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
                                  width: 100,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          result["image"]!), // Gambar
                                      fit: BoxFit.cover,
                                    ),
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
                                        result["title"]!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        result["price"]!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.green,
                                        ),
                                      ),
                                      Text(
                                        "${result["developer"]} • ${result["tags"]}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
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
        backgroundColor: Colors.red, // Red color for the central button
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBarWidget(
        currentIndex: 0,
        onTap: (index) {
          // Handle bottom navigation
        },
      ),
    );
  }
}
