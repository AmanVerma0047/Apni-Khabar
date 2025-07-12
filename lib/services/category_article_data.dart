import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/models/category_article_model.dart';
import 'ApiKeys.dart';


class CategoryArticleData {
  List<CategoryArticleModel> categoryarticles = [];

  Future<void> getCategoryArticle(String category) async {

    String url =
        "https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=$NEWS_API_KEY";
    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          CategoryArticleModel articleModel = CategoryArticleModel(
            title: element['title'],
            description: element['description'],
            url: element['url'],
            content: element['content'],
            urlToImage: element['urlToImage'],
          );
          categoryarticles.add(articleModel);
        }
      });
    }
  }
}
