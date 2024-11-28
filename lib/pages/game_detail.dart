import 'package:flutter/material.dart';

class GameDetailsPage extends StatefulWidget {
  @override
  _GameDetailsPageState createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends State<GameDetailsPage> {
  bool isBookmarked = false; // State to track if bookmarked

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Background image
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/tekken.png'), // Replace with your image path
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Top icons
                Positioned(
                  top: 40,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      // Back icon
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.5),
                          child: Icon(Icons.arrow_back, color: Colors.red),
                        ),
                      ),
                      Spacer(), // This will push the next icons to the right
                      // Send icon
                      GestureDetector(
                        onTap: () {
                          // Handle send icon tap
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.5),
                          child: Icon(Icons.send, color: Colors.red),
                        ),
                      ),
                      SizedBox(
                          width:
                              16), // Space between send icon and bookmark icon
                      // Bookmark icon
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isBookmarked =
                                !isBookmarked; // Toggle bookmark state
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.5),
                          child: Icon(
                            isBookmarked
                                ? Icons.bookmark
                                : Icons
                                    .bookmark_border, // Change icon based on state
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Game details below the image
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Game name and developer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TEKKEN 8',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Bandai Namco',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                      // Rating
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 20),
                            SizedBox(width: 4),
                            Text(
                              '4.3',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Icon categories
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CategoryBadge(
                          title: 'Arcade', icon: Icons.sports_esports),
                      CategoryBadge(title: '16+', icon: Icons.whatshot),
                      CategoryBadge(title: 'Multiplayer', icon: Icons.group),
                      CategoryBadge(title: 'Fighting', icon: Icons.sports_mma),
                    ],
                  ),
                  SizedBox(height: 24),
                  // PC Requirements header
                  Text(
                    'PC Requirements:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  // Minimum requirements
                  RequirementSection(title: 'Minimum:', requirements: [
                    'OS: Windows 10 64-bit',
                    'Processor: Intel Core i5-6600K / AMD Ryzen 5 1600',
                    'Memory: 8 GB RAM',
                    'Graphics: Nvidia GTX 1050Ti / AMD Radeon RX 380X',
                    'DirectX: Version 12',
                  ]),
                  SizedBox(height: 8),
                  // Recommended requirements
                  RequirementSection(title: 'Recommended:', requirements: [
                    'OS: Windows 10 64-bit',
                    'Processor: Intel Core i7 / AMD Ryzen 7',
                    'Memory: 16 GB RAM',
                    'Graphics: Nvidia RTX 3060 / AMD RX 6700 XT',
                    'DirectX: Version 12',
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryBadge extends StatelessWidget {
  final String title;
  final IconData icon;

  const CategoryBadge({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        SizedBox(height: 4),
        Text(title, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}

class RequirementSection extends StatelessWidget {
  final String title;
  final List<String> requirements;

  const RequirementSection({required this.title, required this.requirements});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        for (String requirement in requirements)
          Text('• $requirement', style: TextStyle(fontSize: 14)),
      ],
    );
  }
}
