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
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[200], // Warna latar belakang AppBar
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color.fromARGB(255, 239, 239, 239), width: 0.75), // Border putih
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/foto_profil.png', // Ganti dengan path gambar profil Anda
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 8,),
            Expanded(
              child: Text(
                'Welcome, User', // Ubah sesuai kebutuhan
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => SearchPage(),
                    transitionDuration: Duration.zero, // Durasi transisi 0
                    reverseTransitionDuration: Duration.zero, // Durasi transisi balik 0
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
              Container(
                height: screenHeight * 0.48, // Tentukan tinggi untuk carousel
                child: PageView(
                  controller: PageController(viewportFraction: 0.98), // Atur viewport untuk membuat efek seperti carousel
                  children: [
                    // Konten 1
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Gambar Game
                          Container(
                            height: screenHeight * 0.3,
                            width: screenWidth,
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
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              child: Image.asset(
                                'assets/tekken.png', // Gambar pertama
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Informasi Game
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // Judul Game
                                    Expanded(
                                      child: Text(
                                        "Tekken 5",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    // Rating
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.orange,
                                          size: 15,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "5",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5), // Jarak antar baris
                                Text(
                                  "Platforms: PS",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  "Genres: Action",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  "ESRB: 10",
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
                    // Konten 2
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Gambar Game
                          Container(
                            height: screenHeight * 0.3,
                            width: screenWidth,
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
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              child: Image.asset(
                                'assets/tekken.png', // Gambar kedua
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Informasi Game
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // Judul Game
                                    Expanded(
                                      child: Text(
                                        "Tekken 5",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    // Rating
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.orange,
                                          size: 15,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "5",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5), // Jarak antar baris
                                Text(
                                  "Platforms: PS",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  "Genres: Action",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  "ESRB: 10",
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
                    // Konten 3
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Gambar Game
                          Container(
                            height: screenHeight * 0.3,
                            width: screenWidth,
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
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              child: Image.asset(
                                'assets/tekken.png', // Gambar ketiga
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Informasi Game
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // Judul Game
                                    Expanded(
                                      child: Text(
                                        "Tekken 5",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    // Rating
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.orange,
                                          size: 15,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "5",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5), // Jarak antar baris
                                Text(
                                  "Platforms: PS",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  "Genres: Action",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  "ESRB: 10",
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
                height: screenHeight * 0.32,
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
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 16.0),
                child: Text("For You", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Container(
                height: screenHeight * 0.32,
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
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 16.0),
                child: Text("For You",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Container(
                height: screenHeight * 0.32,
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
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width * 0.4,
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
          SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2),
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
          SizedBox(height: 2),
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
