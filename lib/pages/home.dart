import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/models/category_model.dart';
import 'package:news_app/pages/article_view.dart';
import 'package:news_app/pages/category_article_page.dart';
import 'package:news_app/services/data.dart';
import 'package:news_app/services/news.dart';
import 'package:news_app/services/slider_model_data.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = [];
  List<NewsSliderItem> _newsItems = [];
  List<ArticleModel> articles = [];

  bool _loading = true;
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    _initData();
  }

  Future<void> _initData() async {
    await Future.wait([
      _loadTopNews(),
      _loadLatestNews(),
    ]);
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  Future<void> _loadLatestNews() async {
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
  }

  Future<void> _loadTopNews() async {
    try {
      final news = await SliderModelData.fetchNewsItems();
      _newsItems = news;
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading top news')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _initData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 TOP NEWS TITLE
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Text(
                        'Top News',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),

                    // 🔹 TOP NEWS CAROUSEL
                    _newsItems.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : CarouselSlider.builder(
                            itemCount: _newsItems.length,
                            itemBuilder: (context, index, realIndex) {
                              final item = _newsItems[index];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ArticleView(
                                        blogUrl: item.url ?? '',
                                      ),
                                    ),
                                  );
                                },
                                child: _buildCarouselItem(
                                  item.imageUrl,
                                  item.title,
                                ),
                              );
                            },
                            options: CarouselOptions(
                              height: 200,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              onPageChanged: (index, reason) {
                                setState(() => activeIndex = index);
                              },
                            ),
                          ),

                    const SizedBox(height: 10),
                    _buildIndicator(),

                    // 🔹 CATEGORIES
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: SizedBox(
                        height: 70,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final cat = categories[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CategoryArticlePage(
                                      category: cat.categoryName!,
                                    ),
                                  ),
                                );
                              },
                              child: CategoryTile(
                                image: cat.image ?? '',
                                categoryName: cat.categoryName ?? '',
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // 🔹 LATEST NEWS TITLE
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: Text(
                        'Latest News',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),

                    // 🔹 LATEST NEWS LIST
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          articles.length > 10 ? 10 : articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        return BlogTile(
                          imageurl: article.urlToImage ?? '',
                          title: article.title ?? '',
                          desc: article.description ?? '',
                          url: article.url ?? '',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // 🔹 CAROUSEL ITEM UI
  Widget _buildCarouselItem(String imageUrl, String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (_, __, ___) => Container(
                color: Colors.grey.shade300,
                child: const Icon(Icons.broken_image, size: 60),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black54, Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 INDICATOR
  Widget _buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: _newsItems.length,
        effect: const WormEffect(
          dotHeight: 8,
          dotWidth: 8,
          activeDotColor: Colors.blue,
        ),
      );
}

// ---------------- CATEGORY TILE ----------------
class CategoryTile extends StatelessWidget {
  final String image;
  final String categoryName;

  const CategoryTile({
    super.key,
    required this.image,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              image,
              width: 120,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: 120,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              categoryName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- BLOG TILE ----------------
class BlogTile extends StatelessWidget {
  final String imageurl, title, desc, url;

  const BlogTile({
    super.key,
    required this.imageurl,
    required this.title,
    required this.desc,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArticleView(blogUrl: url),
          ),
        );
      },
      child: Material(
        elevation: 2,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin:
                  const EdgeInsets.only(left: 20, right: 10, bottom: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: imageurl,
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Text(
                    desc,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
