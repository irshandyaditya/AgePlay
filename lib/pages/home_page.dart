import 'package:flutter/material.dart';
import 'package:age_play/widgets/bottom_navbar.dart';
import 'package:age_play/pages/search.dart';
import 'package:age_play/pages/game_detail.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: screenHeight * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/tekken.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6EAEE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.search,
                                color: const Color(0xFF808080)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchPage()),
                              );
                            },
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Search",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 75,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TEKKEN 8',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFEDEDED),
                            ),
                          ),
                          Row(
                            children: [
                              InfoBadge(
                                icon: Icon(Icons.sports_esports,
                                    color: Colors.white, size: 16),
                                text: 'Arcade',
                              ),
                              SizedBox(width: 16),
                              InfoBadge(
                                icon: Icon(Icons.fire_extinguisher_outlined,
                                    color: Colors.white),
                                text: '16+',
                              ),
                            ],
                          ),
                          SizedBox(width: 16),
                          InfoBadge(
                            icon: Icon(Icons.star, color: Colors.white),
                            text: '4.5',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    left: 16,
                    child: publisherInfo(),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Category",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Icon(Icons.more_horiz),
                  ],
                ),
              ),
              Container(
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildCategoryIcon(
                        'assets/categories/arcade.png', context),
                    SizedBox(width: 16),
                    _buildCategoryIcon(
                        'assets/categories/sports.png', context),
                    SizedBox(width: 16),
                    _buildCategoryIcon(
                        'assets/categories/adventure.png', context),
                    SizedBox(width: 16),
                    _buildCategoryIcon('assets/categories/shooter.png', context),
                    SizedBox(width: 16),
                    _buildCategoryIcon('assets/categories/role-playing-games-rpg.png', context),
                    SizedBox(width: 16),
                    _buildCategoryIcon('assets/categories/card.png', context),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("For You",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Container(
                height: 220,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    PopularItem(
                      imageUrl: 'assets/p5s.png',
                      title: 'Final Fantasy 7 Remake Intergrade',
                      subtitle: 'Arcade',
                      publisherLogoUrl: 'assets/bc.png',
                      publisherName: 'Square Enix',
                      postedTime: 'Posted 35 min ago',
                      rating: 4.3,
                    ),
                    PopularItem(
                      imageUrl: 'assets/p5s.png',
                      title: 'Final Fantasy 7 Remake Intergrade',
                      subtitle: 'Arcade',
                      publisherLogoUrl: 'assets/bc.png',
                      publisherName: 'Square Enix',
                      postedTime: 'Posted 35 min ago',
                      rating: 4.3,
                    ),
                    PopularItem(
                      imageUrl: 'assets/p5s.png',
                      title: 'Final Fantasy 7 Remake Intergrade',
                      subtitle: 'Arcade',
                      publisherLogoUrl: 'assets/bc.png',
                      publisherName: 'Square Enix',
                      postedTime: 'Posted 35 min ago',
                      rating: 4.3,
                    ),
                  ],
                ),
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

  Widget _buildCategoryIcon(String imagePath, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GameDetailsPage(slug: 'tekken-8')),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF54748),
                  ),
                ),
                Image.asset(
                  imagePath,
                  width: 40,
                  height: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PopularItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String publisherLogoUrl;
  final String publisherName;
  final String postedTime;
  final double rating;

  PopularItem({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.publisherLogoUrl,
    required this.publisherName,
    required this.postedTime,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160, // Pastikan lebar tetap
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imageUrl,
                  height: 120,
                  width: 160,
                  fit: BoxFit.cover,
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
              maxLines: 2, // Batasi maksimal 2 baris
              overflow: TextOverflow
                  .ellipsis, // Tambahkan "..." jika teks terlalu panjang
            ),
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(publisherLogoUrl),
                radius: 12,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  publisherName,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Flexible(
            child: Text(
              postedTime,
              style: TextStyle(fontSize: 10, color: Colors.grey),
              maxLines: 1, // Batasi hanya 1 baris
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
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

class publisherInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/bc.png',
          width: 55,
          height: 55,
        ),
        SizedBox(width: 8),
        Text('Bandai Namco', style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
