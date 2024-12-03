import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Weather App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _temperature;
  String? _condition;
  String? _location;
  String? _windSpeed;
  String? _humidity;
  String? _feelsLike;
  bool _isLoading = false;

  // API URL for weather data
  final String _url =
      'https://api.weatherapi.com/v1/current.json?key=a007bc81b7e348ad84360841243011&q=pabna';

  // Fetch weather data from API
  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(_url));

      // If the request is successful, parse the JSON data
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _location = data['location']['name'];
          _temperature = data['current']['temp_c'].toString();
          _condition = data['current']['condition']['text'];
          _windSpeed = data['current']['wind_kph'].toString();
          _humidity = data['current']['humidity'].toString();
          _feelsLike = data['current']['feelslike_c'].toString();
          _isLoading = false;
        });
      } else {
        // If the request fails
        setState(() {
          _location = null;
          _temperature = null;
          _condition = 'Failed to fetch weather data';
          _isLoading = false;
        });
      }
    } catch (e) {
      // Handle any errors
      setState(() {
        _location = null;
        _temperature = null;
        _condition = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather(); // Fetch the weather data when the app starts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator() // Show loading indicator while data is fetching
            : _location != null && _temperature != null && _condition != null
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location: $_location',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Temperature: $_temperature°C',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Condition: $_condition',
                          style: const TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Wind Speed: $_windSpeed km/h',
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Humidity: $_humidity%',
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Feels Like: $_feelsLike°C',
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  )
                : const Text(
                    'Failed to fetch weather data',
                    style: TextStyle(fontSize: 24, color: Colors.red),
                  ),
      ),
    );
  }
}