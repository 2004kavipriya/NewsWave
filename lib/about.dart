import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        children: [
          buildHeader(),
          const SizedBox(height: 24.0),
          buildSection(
            title: 'News Feeds',
            description:
                'Stay informed with an extensive collection of news articles categorized into topics such as:\n'
                '- Spirituality: Insights and stories to enrich your inner self.\n'
                '- Education: Updates on learning, schools, and innovation.\n'
                '- Health: Tips and news on staying healthy and fit.\n'
                '- Crimes: Alerts and reports to ensure safety.\n'
                '- Entertainment: Discover the latest in movies, music, and more.',
            imagePath: 'images/feeds.jpeg',
            icon: Icons.article_outlined,
          ),
          buildSection(
            title: 'Trending',
            description:
                'Discover the most talked-about events from around the world in real-time. '
                'Our Trending section keeps you updated with the stories that are making headlines globally.',
            imagePath: 'images/trend.jpeg',
            icon: Icons.trending_up,
          ),
          buildSection(
            title: 'Klips',
            description:
                'Experience news in a more interactive way through video clips. Klips provides:\n'
                '- Short, engaging videos that summarize the latest news stories.\n'
                '- Visual content for users who prefer videos over text.',
            imagePath: 'images/klips.jpeg',
            icon: Icons.video_library_outlined,
          ),
          buildSection(
            title: 'Bilingual Support',
            description:
                'Enjoy the flexibility of reading news in your preferred language:\n'
                '- English: For a global audience.\n'
                '- Tamil: For regional relevance and connection.\n'
                'Switch effortlessly between languages for a personalized experience.',
            imagePath: 'images/bilingual.jpeg',
            icon: Icons.translate,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFD02805).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.newspaper,
            size: 48,
            color: Color(0xFFD02805),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'News App Features',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Discover what makes our app unique',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget buildSection({
    required String title,
    required String description,
    required String imagePath,
    required IconData icon,
    bool isLast = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Preview not available',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: const Color(0xFFD02805),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}