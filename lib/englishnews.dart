import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Import the separate screens
import 'trending.dart';
import 'klips.dart';
import 'about.dart';

class EnglishNewsScreen extends StatefulWidget {
  final String cityName;
  final Map<String, dynamic> cityNews;

  const EnglishNewsScreen({super.key, required this.cityName, required this.cityNews});

  @override
  _EnglishNewsScreenState createState() => _EnglishNewsScreenState();
}

class _EnglishNewsScreenState extends State<EnglishNewsScreen> with SingleTickerProviderStateMixin {
  bool isTamilNews = false;
  late Map<String, dynamic> currentNews;
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    currentNews = widget.cityNews;
    _tabController = TabController(length: currentNews.keys.length, vsync: this);
  }

  Future<void> fetchTamilNews() async {
    String url = 'http://192.168.122.158:5000/get_tamil_city_news';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'city': widget.cityName}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          currentNews = data;
          isTamilNews = true;
          _tabController = TabController(length: currentNews.keys.length, vsync: this);
        });
      } else {
        print('Failed to load Tamil news: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchEnglishNews() async {
    String url = 'http://192.168.122.158:5000/get_english_city_news';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'city': widget.cityName}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          currentNews = data;
          isTamilNews = false;
          _tabController = TabController(length: currentNews.keys.length, vsync: this);
        });
      } else {
        print('Failed to load English news: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return currentNews.isNotEmpty
            ? TabBarView(
                controller: _tabController,
                children: currentNews.keys.map((category) {
                  List<dynamic> articles = currentNews[category] ?? [];
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      var article = articles[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {},
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (article['image_url'] != null &&
                                    article['image_url'].isNotEmpty)
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                    child: Image.network(
                                      article['image_url'],
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        article['title'] ?? 'No Title',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        article['summary'] ?? 'No Summary',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          height: 1.4,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              )
            : const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD02805)),
                ),
              );
      case 1:
        return TrendingScreen();
      case 2:
        return KlipsScreen();
      case 3:
        return AboutPage();
      default:
        return const Center(child: Text('Page Not Found'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'images/logo2.jpeg', // Make sure to add your logo image to the assets folder
            fit: BoxFit.contain,
          ),
        ),
        leadingWidth: 100, // Adjust this value based on your logo size
        bottom: _selectedIndex == 0 && currentNews.isNotEmpty
            ? PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: const Color(0xFFD02805),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: const Color(0xFFD02805),
                    indicatorWeight: 3,
                    tabs: currentNews.keys.map((category) {
                      return Tab(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            category,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              )
            : null,
        actions: [
          if (_selectedIndex == 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text(
                    "தமிழ்",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Switch(
                    value: isTamilNews,
                    onChanged: (value) {
                      setState(() {
                        if (value) {
                          fetchTamilNews();
                        } else {
                          fetchEnglishNews();
                        }
                      });
                    },
                    activeColor: const Color(0xFFD02805),
                    inactiveTrackColor: Colors.grey.withOpacity(0.3),
                    inactiveThumbColor: Colors.white,
                  ),
                ],
              ),
            ),
        ],
      ),
      body: _buildSelectedScreen(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              activeIcon: Icon(Icons.article),
              label: 'News Feeds',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up_outlined),
              activeIcon: Icon(Icons.trending_up),
              label: 'Trending',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_library_outlined),
              activeIcon: Icon(Icons.video_library),
              label: 'Klips',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info_outline),
              activeIcon: Icon(Icons.info),
              label: 'About Us',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFFD02805),
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          onTap: _onItemTapped,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: 0,
        ),
      ),
    );
  }
}
