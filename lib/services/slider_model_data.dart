// slider_model_data.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ApiKeys.dart';

class NewsSliderItem {
  final String title;
  final String imageUrl;

  NewsSliderItem({required this.title, required this.imageUrl});

  factory NewsSliderItem.fromJson(Map<String, dynamic> json) {
    return NewsSliderItem(
      title: json['title'] ?? 'No Title',
      imageUrl: json['urlToImage'] ?? '',
    );
  }
}

class SliderModelData {

  static final String _apiUrl = 'https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=$NEWS_API_KEY';

  static Future<List<NewsSliderItem>> fetchNewsItems() async {
    final response = await http.get(Uri.parse(_apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List articles = data['articles'];

      return articles
          .map((article) => NewsSliderItem.fromJson(article))
          .where((item) => item.imageUrl.isNotEmpty)
          .toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
