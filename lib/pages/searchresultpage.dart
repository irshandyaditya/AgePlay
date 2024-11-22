import 'package:flutter/material.dart';

class SearchResultsPage extends StatelessWidget {
  final String query;

  SearchResultsPage({required this.query});

  @override
  Widget build(BuildContext context) {
    // Contoh hasil pencarian yang disaring berdasarkan query (untuk ilustrasi)
    final List<Map<String, String>> searchResults = [
      {"title": "Result 1", "subtitle": "Subtitle for Result 1"},
      {"title": "Result 2", "subtitle": "Subtitle for Result 2"},
      {"title": "Result 3", "subtitle": "Subtitle for Result 3"},
      {"title": "Result 4", "subtitle": "Subtitle for Result 4"},
    ]
        .where((item) =>
            item["title"]!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Search Results"),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: Column(
        children: [
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
                        IconButton(
                          icon: Icon(Icons.search,
                              color: const Color(0xFF808080)),
                          onPressed: () {},
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search again",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon:
                              Icon(Icons.clear, color: const Color(0xFF808080)),
                          onPressed: () {
                            // Add clear search action if needed
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
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final result = searchResults[index];
                return ListTile(
                  leading: Icon(Icons.gamepad, color: Colors.redAccent),
                  title: Text(result["title"]!),
                  subtitle: Text(result["subtitle"]!),
                  onTap: () {
                    // Navigate to details of the selected search result
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
