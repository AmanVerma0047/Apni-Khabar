import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/category_article_model.dart';
import 'package:news_app/pages/article_view.dart';
import 'package:news_app/services/category_article_data.dart';

void main() {
  runApp(const CategoryArticlePage(category: 'business'));
}

class CategoryArticlePage extends StatefulWidget {
  final String category;
  const CategoryArticlePage({super.key, required this.category});

  @override
  State<CategoryArticlePage> createState() => _CategoryArticlePageState();
}

class _CategoryArticlePageState extends State<CategoryArticlePage> {
  List<CategoryArticleModel> categoryarticles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchCategoryArticles();
  }

  void fetchCategoryArticles() async {
    CategoryArticleData articleData = CategoryArticleData();
    await articleData.getCategoryArticle(widget.category);
    setState(() {
      categoryarticles = articleData.categoryarticles;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Apni',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    fontFamily:
                        'Georgia', // or 'Times New Roman', or your custom font
                  ),
                ),
                Text(
                  'Khabar',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 0, 179, 249),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    fontFamily:
                        'Georgia', // or 'Times New Roman', or your custom font
                  ),
                ),
              ],
            ),
            Text(
              'Your trusted tech news source',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : categoryarticles.isEmpty
          ? Center(child: Text('No articles found'))
          : SingleChildScrollView(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ArticleTile(
                    url: categoryarticles[index].url ?? '',
                    imageurl: categoryarticles[index].urlToImage ?? '',
                    title: categoryarticles[index].title ?? '',
                    desc: categoryarticles[index].description ?? '',
                  );
                },
              ),
            ),
    );
  }
}

class ArticleTile extends StatelessWidget {
  final String imageurl, title, desc, url;
  const ArticleTile({
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
