import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ApiKeys.dart';
class WeatherService {
  final String apiKey = WEATHER_API_KEY;

  Future<Map<String, dynamic>?> getWeather(String city) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to load weather data: ${response.statusCode}');
      return null;
    }
  }
}
