import 'package:flutter/material.dart';
import 'package:news_app/services/weather_data.dart';

void main() {
  runApp(MaterialApp(home: weatherPage()));
}

class weatherPage extends StatefulWidget {
  @override
  _weatherPageState createState() => _weatherPageState();
}

class _weatherPageState extends State<weatherPage> {
  final weatherService = WeatherService();

  // Add city list
  final List<String> cities = ["Delhi", "Mumbai", "London", "New York", "Tokyo",
    "Lucknow", "Bangalore", "Kolkata", "Chennai", "Hyderabad"];
  String selectedCity = "Lucknow";
  Map<String, dynamic>? weatherData;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    final data = await weatherService.getWeather(selectedCity);
    setState(() {
      weatherData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 174, 201, 248),
        title: DropdownButton<String>(
          value: selectedCity,
          icon: Icon(Icons.arrow_drop_down),
          underline: Container(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedCity = newValue;
                weatherData = null; // Clear current data to show loader
              });
              fetchWeather();
            }
          },
          items: cities.map<DropdownMenuItem<String>>((String city) {
            return DropdownMenuItem<String>(
              value: city,
              child: Text(
                "Weather in $city",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
        ),
        centerTitle: true,
      ),
      body: weatherData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Location
                  Text(
                    "${weatherData!['name']}, ${weatherData!['sys']['country']}",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),

                  // Weather Icon
                  Image.network(
                    "https://openweathermap.org/img/wn/${weatherData!['weather'][0]['icon']}@2x.png",
                    scale: 1.5,
                  ),

                  // Temperature
                  Text(
                    "${weatherData!['main']['temp']}°C",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),

                  // Description
                  Text(
                    "${weatherData!['weather'][0]['description'].toString().toUpperCase()}",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),

                  // Weather Details
                  Expanded(
                    child: ListView(
                      children: [
                        WeatherTile(
                          icon: Icons.thermostat,
                          label: 'Feels Like',
                          value: "${weatherData!['main']['feels_like']}°C",
                        ),
                        WeatherTile(
                          icon: Icons.water_drop,
                          label: 'Humidity',
                          value: "${weatherData!['main']['humidity']}%",
                        ),
                        WeatherTile(
                          icon: Icons.speed,
                          label: 'Pressure',
                          value: "${weatherData!['main']['pressure']} hPa",
                        ),
                        WeatherTile(
                          icon: Icons.air,
                          label: 'Wind Speed',
                          value: "${weatherData!['wind']['speed']} m/s",
                        ),
                        WeatherTile(
                          icon: Icons.cloud,
                          label: 'Cloudiness',
                          value: "${weatherData!['clouds']['all']}%",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class WeatherTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const WeatherTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, size: 30, color: Colors.blueAccent),
        title: Text(label, style: TextStyle(fontSize: 16)),
        trailing: Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
