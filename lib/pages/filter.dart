import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String selectedGenre = '';
  String selectedGenreText = 'All Genres';
  String selectedPlatform = '';
  String selectedPlatformText = 'All Platforms';
  String selectedStore = '';
  String selectedStoreText = 'All Stores';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filters'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Genre Filter Dropdown
              Text(
                'Genres',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedGenre,
                onChanged: (value) {
                  setState(() {
                    selectedGenre = value!;
                    selectedGenreText = genreList.firstWhere(
                      (genre) => genre['value'] == value,
                      orElse: () => {'text': 'All Genres'},
                    )['text']!;
                  });
                },
                items: genreList
                    .map((genre) => DropdownMenuItem(
                          value: genre['value'],
                          child: Text(genre['text']!),
                        ))
                    .toList(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Parent Platforms Filter Dropdown
              Text(
                'Parent Platforms',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedPlatform,
                onChanged: (value) {
                  setState(() {
                    selectedPlatform = value!;
                    selectedPlatformText = platformList.firstWhere(
                      (platform) => platform['value'] == value,
                      orElse: () => {'text': 'All Platforms'},
                    )['text']!;
                  });
                },
                items: platformList
                    .map((platform) => DropdownMenuItem(
                          value: platform['value'],
                          child: Text(platform['text']!),
                        ))
                    .toList(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Store Filter Dropdown
              Text(
                'Stores',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedStore,
                onChanged: (value) {
                  setState(() {
                    selectedStore = value!;
                    selectedStoreText = storeList.firstWhere(
                      (store) => store['value'] == value,
                      orElse: () => {'text': 'All Stores'},
                    )['text']!;
                  });
                },
                items: storeList
                    .map((store) => DropdownMenuItem(
                          value: store['value'],
                          child: Text(store['text']!),
                        ))
                    .toList(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'genres': selectedGenre,
                      'parent_platforms': selectedPlatform,
                      'stores': selectedStore,
                      'genreText': selectedGenreText,
                      'platformText': selectedPlatformText,
                      'storeText': selectedStoreText,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Apply',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Data lists for dropdown menus
const genreList = [
  {'text': 'All Genres', 'value': ''},
  {'text': 'Action', 'value': 'action'},
  {'text': 'Indie', 'value': 'indie'},
  {'text': 'Adventure', 'value': 'adventure'},
  {'text': 'RPG', 'value': 'role-playing-games-rpg'},
  {'text': 'Strategy', 'value': 'strategy'},
  {'text': 'Shooter', 'value': 'shooter'},
  {'text': 'Casual', 'value': 'casual'},
  {'text': 'Simulation', 'value': 'simulation'},
  {'text': 'Puzzle', 'value': 'puzzle'},
  {'text': 'Arcade', 'value': 'arcade'},
  {'text': 'Platformer', 'value': 'platformer'},
  {'text': 'Racing', 'value': 'racing'},
  {'text': 'MMO', 'value': 'massively-multiplayer'},
  {'text': 'Sports', 'value': 'sports'},
  {'text': 'Fighting', 'value': 'fighting'},
  {'text': 'Family', 'value': 'family'},
  {'text': 'Board Games', 'value': 'board-games'},
  {'text': 'Card', 'value': 'card'},
  {'text': 'Educational', 'value': 'educational'},
];

const platformList = [
  {'text': 'All Platforms', 'value': ''},
  {'text': 'PC', 'value': '1'},
  {'text': 'PlayStation', 'value': '2'},
  {'text': 'Xbox', 'value': '3'},
  {'text': 'iOS', 'value': '4'},
  {'text': 'Mac', 'value': '5'},
  {'text': 'Linux', 'value': '6'},
  {'text': 'Nintendo', 'value': '7'},
  {'text': 'Android', 'value': '8'},
  {'text': 'Atari', 'value': '9'},
  {'text': 'Commodore / Amiga', 'value': '10'},
  {'text': 'SEGA', 'value': '11'},
  {'text': '3DO', 'value': '12'},
  {'text': 'Neo Geo', 'value': '13'},
  {'text': 'Web', 'value': '14'},
];

const storeList = [
  {'text': 'All Stores', 'value': ''},
  {'text': 'Steam', 'value': '1'},
  {'text': 'PlayStation Store', 'value': '3'},
  {'text': 'Xbox Store', 'value': '2'},
  {'text': 'App Store', 'value': '4'},
  {'text': 'GOG', 'value': '5'},
  {'text': 'Nintendo Store', 'value': '6'},
  {'text': 'Xbox 360 Store', 'value': '7'},
  {'text': 'Google Play', 'value': '8'},
  {'text': 'itch.io', 'value': '9'},
  {'text': 'Epic Games', 'value': '11'},
];
