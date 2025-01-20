import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TamilNewsScreen extends StatefulWidget {
  final String cityName;
  final Map<String, dynamic> cityNews;

  const TamilNewsScreen({super.key, required this.cityName, required this.cityNews});

  @override
  _TamilNewsScreenState createState() => _TamilNewsScreenState();
}

class _TamilNewsScreenState extends State<TamilNewsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<String> categories;

  @override
  void initState() {
    super.initState();
    categories = widget.cityNews.keys.toList();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _openLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open the link: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.cityName} News (Tamil)'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: categories.map((category) => Tab(text: category)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: categories.map((category) {
          List<dynamic> articles = widget.cityNews[category] ?? [];
          return articles.isEmpty
              ? Center(child: Text('No news available for $category'))
              : ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10.0),
                        leading: (article['image_url'] != null && article['image_url'].isNotEmpty)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  article['image_url'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : null,
                        title: Text(
                          article['title'] ?? 'No Title',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          article['summary'] ?? 'No Summary',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => _openLink(article['url']),
                      ),
                    );
                  },
                );
        }).toList(),
      ),
    );
  }
}
