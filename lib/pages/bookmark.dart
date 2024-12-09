import 'package:flutter/material.dart';
import 'package:age_play/widgets/bottom_navbar.dart';

class BookmarkPage extends StatefulWidget {
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  int _currentIndex = 2;

  final List<Map<String, String>> bookmarkedItems = [
    {
      "title": "Persona 3 Reload",
      "price": "Rp 779.000",
      "developer": "ATLUS",
      "tags": "JRPG, RPG, Anime, Adventure",
      "image": "assets/persona3.jpg",
    },
    {
      "title": "Red Dead Redemption II",
      "price": "Rp 879.000",
      "developer": "Rockstar Games",
      "tags": "Action, Open World, Western",
      "image": "assets/red_dead.jpg",
    },
    {
      "title": "FIFA 25",
      "price": "Rp 679.000",
      "developer": "EA Sports",
      "tags": "Sports, Soccer, Multiplayer",
      "image": "assets/fifa25.jpg",
    },
    {
      "title": "Horizon Forbidden West",
      "price": "Rp 829.000",
      "developer": "Guerrilla Games",
      "tags": "Adventure, RPG, Open World",
      "image": "assets/horizon.jpg",
    },
    {
      "title": "Street Fighter 6",
      "price": "Rp 739.000",
      "developer": "Capcom",
      "tags": "Fighting, Multiplayer",
      "image": "assets/street_fighter.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Body background set to white
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Bookmark",
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      body: ListView.builder(
        itemCount: bookmarkedItems.length,
        itemBuilder: (context, index) {
          final item = bookmarkedItems[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                // Game image
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.09,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(item["image"]!), // Gambar
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5), // Warna shadow
                        blurRadius: 8, // Tingkat blur
                        offset: Offset(0, 4), // Posisi shadow
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
                        item["title"]!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        item["price"]!, // Harga
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        item["developer"]!, // Developer di atas genre
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        item["tags"]!, // Genre game
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
