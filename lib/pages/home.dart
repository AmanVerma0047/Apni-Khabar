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
  int activeindex = 0;

  @override
  void initState() {
    setState(() {
      categories = getCategories();
      _initData();
    });
    super.initState();
  }

  Future<void> _initData() async {
    await getNews(); // wait for both to complete
    await _loadNews();
  }

  getNews() async {
    News newsclass = News();
    await newsclass.getNews();
    articles = newsclass.news;
    setState(() {
      _loading = false;
    });
  }

  Future<void> _loadNews() async {
    try {
      final news = await SliderModelData.fetchNewsItems();
      setState(() {
        _newsItems = news;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading news: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await getNews();
                await _loadNews();
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Top News Carousal Section
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        bottom: 20.0,
                        top: 20.0,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Top News',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' - Show Latest Updates',
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color.fromARGB(255, 0, 179, 249),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Carousel Slider for Top News
                    _newsItems.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : CarouselSlider.builder(
                            itemCount: 5,
                            itemBuilder: (context, index, realIndex) {
                              return buildImage(
                                _newsItems[index].imageUrl,
                                index,
                                _newsItems[index].title,
                              );
                            },
                            options: CarouselOptions(
                              height: 200,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration: Duration(
                                milliseconds: 800,
                              ),
                              enlargeCenterPage: true,
                              onPageChanged: (index, reason) => setState(() {
                                activeindex = index;
                              }),
                            ),
                          ),
                    SizedBox(height: 10),
                    buildIndicator(),
                    SizedBox(height: 10),

                    // Categories Section
                    Padding(
                      padding: const EdgeInsets.all(15.0),
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
                                image: cat.image,
                                categoryName: cat.categoryName,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, bottom: 10.0),
                      child: Row(
                        children: [
                          // This is the title for the latest news section
                          Text(
                            'Latest News',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' - Trending Now',
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color.fromARGB(255, 0, 179, 249),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return BlogTile(
                          url: articles[index].url ?? '',
                          imageurl: articles[index].urlToImage ?? '',
                          title: articles[index].title ?? '',
                          desc: articles[index].description ?? '',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // Function to build the image widget for the carousel slider
  Widget buildImage(String imageUrl, int index, String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade300,
                child: Icon(Icons.broken_image, size: 60, color: Colors.grey),
              ),
            ),

            // Overlay with title
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black54, Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 2,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
    activeIndex: activeindex,
    count: 5,
    effect: WormEffect(
      dotHeight: 8,
      dotWidth: 8,
      activeDotColor: Colors.blue,
      dotColor: Colors.grey,
    ),
  );
}

//Categories section on top code!!
// ignore: must_be_immutable
class CategoryTile extends StatelessWidget {
  dynamic image, categoryName;
  CategoryTile({super.key, this.image, this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16),
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
            alignment: Alignment.center,
            width: 120,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black26,
            ),
            child: Text(
              categoryName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// blog tile with image, title, description, and url
// This tile will be used to display the latest news articles in a list format.

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
          MaterialPageRoute(builder: (context) => (ArticleView(blogUrl: url))),
        );
      },
      child: Material(
        elevation: 2,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 10.0, bottom: 10.0),
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
                    maxLines: 2,
                    title,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 5),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Text(
                    desc,
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
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
