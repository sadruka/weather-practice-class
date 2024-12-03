import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SevenDayForecast extends StatefulWidget {
  const SevenDayForecast({Key? key}) : super(key: key);

  @override
  State<SevenDayForecast> createState() => _SevenDayForecastState();
}

class _SevenDayForecastState extends State<SevenDayForecast> {
  List<dynamic>? _forecastData;
  bool _isLoading = false;

  // API URL for 7-day forecast data
  final String _url =
      'https://api.weatherapi.com/v1/forecast.json?key=a007bc81b7e348ad84360841243011&q=dhaka&days=7';

  // Fetch 7-day weather data from API
  Future<void> _fetchSevenDayForecast() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(_url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _forecastData = data['forecast']['forecastday'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _forecastData = null;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _forecastData = null;
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchSevenDayForecast(); // Fetch the 7-day forecast when the page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('7-Day Forecast'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _forecastData != null
              ? ListView.builder(
                  itemCount: _forecastData!.length,
                  itemBuilder: (context, index) {
                    final day = _forecastData![index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Image.network(
                          'https:${day['day']['condition']['icon']}',
                          width: 50,
                          height: 50,
                        ),
                        title: Text(
                          '${day['date']}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Max Temp: ${day['day']['maxtemp_c']}°C\n'
                          'Min Temp: ${day['day']['mintemp_c']}°C\n'
                          'Condition: ${day['day']['condition']['text']}',
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text(
                    'Failed to fetch 7-day forecast',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                ),
    );
  }
}