import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'englishnews.dart'; // Make sure this is correctly imported
import 'tamilnews.dart';   // Make sure this is correctly imported

class TamilNaduCitiesScreen extends StatefulWidget {
  const TamilNaduCitiesScreen({super.key});

  @override
  _TamilNaduCitiesScreenState createState() => _TamilNaduCitiesScreenState();
}

class _TamilNaduCitiesScreenState extends State<TamilNaduCitiesScreen> {
  final List<Map<String, String>> popularCities = [
    {"name": "Chennai", "image": "https://upload.wikimedia.org/wikipedia/commons/3/32/Chennai_Central.jpg"},
    {"name": "Coimbatore", "image": "https://pohcdn.com/guide/sites/default/files/styles/paragraph__live_banner__lb_image__1880bp/public/live_banner/Coimbatore.jpg"},
    {"name": "Madurai", "image": "https://static.wixstatic.com/media/36a61e_354a22be934b4cb4acfe746a47b83ebf~mv2_d_4368_2779_s_4_2.jpg/v1/fill/w_1000,h_636,al_c,q_85,usm_0.66_1.00_0.01/36a61e_354a22be934b4cb4acfe746a47b83ebf~mv2_d_4368_2779_s_4_2.jpg"},
    {"name": "Salem", "image": "https://primestorage.com/wp-content/uploads/2023/04/AdobeStock_373731940_Resized.jpg"},
    {"name": "Tiruppur", "image": "https://cdnbbsr.s3waas.gov.in/s3ec04e1fc9c082df6cfff8cbcfff2b5a7/uploads/2023/10/2023102746-1024x576.jpg"},
  ];

  final List<Map<String, String>> allCities = [
    {"name": "Tiruchirappalli", "image": "https://upload.wikimedia.org/wikipedia/commons/f/fb/Rock_Fortress_-_Tiruchirappalli_-_India.JPG"},
    {"name": "Vellore", "image": "https://thechennai.wordpress.com/wp-content/uploads/2011/06/vellore-fort.jpg?w=584"},
    {"name": "Thanjavur", "image": "https://mediaim.expedia.com/destination/1/c356c905de5af9245f36a4374bd5cbea.jpg"},
    {"name": "Tirunelveli", "image": "https://mediaim.expedia.com/destination/1/0d5f02078ac5e82d21510b06f4fa3e05.jpg"},
    {"name": "Kanchipuram", "image": "https://pix10.agoda.net/geo/city/30359/1_30359_02.jpg?ca=6&ce=1&s=1920x822"},
  ];

  // This function is now common for both sections
  Future<void> sendCityToBackend(BuildContext context, String cityName, String language) async {
    String url = language == 'Tamil' 
        ? 'http://192.168.122.158:5000/get_tamil_city_news'
        : 'http://192.168.122.158:5000/get_english_city_news';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'city': cityName}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => language == 'English'
                ? EnglishNewsScreen(cityName: cityName, cityNews: data)
                : TamilNewsScreen(cityName: cityName, cityNews: data),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load news. Please try again.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Network error. Please check your connection.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // This is the method to build the city card.
  Widget _buildCityCard(String name, String imageUrl) {
    return GestureDetector(
      onTap: () {
        // Make the language dynamic based on the city section clicked
        sendCityToBackend(context, name, 'English'); // You can change this to 'Tamil' as needed.
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Icon(Icons.image_not_supported, color: Colors.grey[600]),
                  );
                },
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'images/logo2.jpeg', // Make sure to add your logo image to assets folder
              height: 40, // Adjust height as needed
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            Text(
              'Choose your city',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        toolbarHeight: 80,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Popular Cities',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: popularCities.length,
                      itemBuilder: (context, index) {
                        return _buildCityCard(
                          popularCities[index]["name"]!,
                          popularCities[index]["image"]!,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'All Cities',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildCityCard(
                    allCities[index]["name"]!,
                    allCities[index]["image"]!,
                  );
                },
                childCount: allCities.length,
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }
}

