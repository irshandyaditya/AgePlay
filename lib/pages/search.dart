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
  String? selectedAge;
  String? selectedCategory;
  int _currentIndex = 0;
  bool _isFilterApplied = false; // Status filter

  final List<Map<String, String>> allItems = [
    {
      "title": "Persona 3 Reload",
      "price": "Rp 779.000",
      "developer": "ATLUS",
      "tags": "JRPG, RPG, Anime, Adventure",
      "image": "assets/p5s.png",
    },
    // Tambahkan item lainnya sesuai kebutuhan
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
        _performSearch();
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

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context); // Tutup modal
                    },
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('Age'),
              DropdownButton<String>(
                isExpanded: true,
                value: selectedAge,
                items: <String>['16+', '18+', 'All Ages']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedAge = newValue;
                  });
                },
                hint: Text('Select Age'),
              ),
              SizedBox(height: 16),
              Text('Categories'),
              DropdownButton<String>(
                isExpanded: true,
                value: selectedCategory,
                items: <String>['All Categories', 'Action', 'Adventure']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                },
                hint: Text('Select Category'),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  _applyFilters();
                  Navigator.pop(context);
                },
                child: Text('Apply'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _applyFilters() {
    setState(() {
      searchResults = allItems.where((item) {
        bool matchesCategory = selectedCategory == null ||
            selectedCategory == 'All Categories' ||
            item["tags"]!.contains(selectedCategory!);
        bool matchesAge = selectedAge == null ||
            (selectedAge == '16+' && item["tags"]!.contains('JRPG')) ||
            (selectedAge == '18+' && item["tags"]!.contains('RPG'));
        return matchesCategory && matchesAge;
      }).toList();

      // Update status filter
      _isFilterApplied = selectedAge != null || selectedCategory != null;

      // Menambahkan deskripsi filter
      if (selectedCategory != null) {
        _searchQuery =
            'Filter: ${selectedCategory!}, Age: ${selectedAge ?? "Any"}';
      }
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
                          icon:
                              Icon(Icons.clear, color: const Color(0xFF808080)),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                              searchResults.clear();
                              selectedAge = null; // Reset filter
                              selectedCategory = null; // Reset filter
                              _isFilterApplied = false; // Reset filter status
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                IconButton(
                  icon: Icon(
                    _isFilterApplied
                        ? Icons.filter_alt
                        : Icons.filter_alt_outlined,
                    color:
                        _isFilterApplied ? Colors.red : const Color(0xFF808080),
                  ),
                  onPressed: _showFilterSheet,
                ),
              ],
            ),
          ),
          if (_searchQuery.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _searchQuery,
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
