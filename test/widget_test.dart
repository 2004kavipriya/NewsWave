import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const HairExtensionApp());
}

class HairExtensionApp extends StatelessWidget {
  const HairExtensionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const ProductPage(),
    );
  }
}

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chennai Beauty Box'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: const ProductCard(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              label: Text('New'),
              child: Icon(Icons.event),
            ),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'Videos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection),
            label: 'Klips',
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  const ProductCard({super.key});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://www.example.com/video.mp4', // Replace with your video URL
    )..initialize().then((_) {
        setState(() {}); // Refresh to show the initialized player
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: NetworkImage('https://via.placeholder.com/50'),
            ),
            title: const Text('Chennai Beauty Box'),
            subtitle: Text(
              'Kolathur • 4 hours ago',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey[300],
            child: _controller.value.isInitialized
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                        }
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                        if (!_controller.value.isPlaying)
                          const Icon(Icons.play_circle_outline, size: 64),
                      ],
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hair Extension (synthetic)',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Available in Chennai Beauty Box Cosmetics',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Rs. 450',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          const SocialButtons(),
        ],
      ),
    );
  }
}

class SocialButtons extends StatefulWidget {
  const SocialButtons({super.key});

  @override
  State<SocialButtons> createState() => _SocialButtonsState();
}

class _SocialButtonsState extends State<SocialButtons> {
  bool isLiked = false;
  bool isBookmarked = false;
  int likeCount = 0;
  int shareCount = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInteractiveButton(
            icon: isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
            color: isLiked ? Colors.blue : Colors.grey,
            count: likeCount,
            onTap: () {
              setState(() {
                isLiked = !isLiked;
                likeCount += isLiked ? 1 : -1;
              });
            },
          ),
          _buildInteractiveButton(
            icon: Icons.search,
            color: Colors.grey,
            onTap: () {},
          ),
          _buildInteractiveButton(
            icon: Icons.share_outlined,
            color: Colors.grey,
            count: shareCount,
            onTap: () {
              setState(() {
                shareCount++;
              });
            },
          ),
          _buildInteractiveButton(
            icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: isBookmarked ? Colors.purple : Colors.grey,
            onTap: () {
              setState(() {
                isBookmarked = !isBookmarked;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveButton({
    required IconData icon,
    required Color color,
    int? count,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Icon(icon, color: color),
            if (count != null) ...[
              const SizedBox(width: 4),
              Text(
                count.toString(),
                style: TextStyle(color: color),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
