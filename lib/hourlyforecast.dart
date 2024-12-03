import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HourlyForecast extends StatefulWidget {
  const HourlyForecast({Key? key}) : super(key: key);

  @override
  State<HourlyForecast> createState() => _HourlyForecastState();
}

class _HourlyForecastState extends State<HourlyForecast> {
  List<dynamic>? _hourlyData;
  bool _isLoading = false;

  // API URL for hourly forecast data
  final String _url =
      'https://api.weatherapi.com/v1/forecast.json?key=a007bc81b7e348ad84360841243011&q=dhaka&days=1';

  // Fetch hourly weather data from API
  Future<void> _fetchHourlyForecast() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(_url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _hourlyData = data['forecast']['forecastday'][0]['hour'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _hourlyData = null;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hourlyData = null;
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchHourlyForecast(); // Fetch the hourly forecast when the page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hourly Forecast'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hourlyData != null
              ? ListView.builder(
                  itemCount: _hourlyData!.length,
                  itemBuilder: (context, index) {
                    final hour = _hourlyData![index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Image.network(
                          'https:${hour['condition']['icon']}',
                          width: 50,
                          height: 50,
                        ),
                        title: Text(
                          '${hour['time']}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Temperature: ${hour['temp_c']}°C\nCondition: ${hour['condition']['text']}',
                        ),
                        trailing: Text('${hour['wind_kph']} km/h'),
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text(
                    'Failed to fetch hourly forecast',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                ),
    );
  }
}