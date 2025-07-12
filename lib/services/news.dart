import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/models/article_model.dart';
import 'dart:math';

import 'package:news_app/services/ApiKeys.dart';

class News {
  List<ArticleModel> news = [];

  Future<void> getNews() async {
    String getRandomLetter({bool uppercase = false}) {
      final random = Random();
      int codeUnit = uppercase
          ? random.nextInt(26) +
                65 // ASCII A-Z (65–90)
          : random.nextInt(26) + 97; // ASCII a-z (97–122)
      return String.fromCharCode(codeUnit);
    }

    String url =
        "https://newsapi.org/v2/everything?q=${getRandomLetter()}&from=2025-06-23&to=2025-06-23&sortBy=popularity&apiKey=$NEWS_API_KEY";
    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          ArticleModel articleModel = ArticleModel(
            title: element['title'],
            description: element['description'],
            url: element['url'],
            content: element['content'],
            urlToImage: element['urlToImage'],
          );
          news.add(articleModel);
        }
      });
    }
  }
}
