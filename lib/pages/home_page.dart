import 'package:app/model/weather_model.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../service/weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _cityController = TextEditingController();
  Weather? _weather;
  bool _isLoading = false;

  void _fetchWeather() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final weather = await _weatherService.fetchData(_cityController.text);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    return DateFormat('EEEE d, MMMM yyyy.').format(now); // Format: 10 Oct 2024
  }

  String getCurrentTime() {
    DateTime now = DateTime.now();
    return DateFormat('hh:mm a').format(now); // Format: 04:30 PM
  }

  String weatherAnimation(String? weather) {
    if (weather == null) return 'assets/sunny.json';
    switch (weather.toLowerCase()) {
      case 'clouds':
      case 'fogs':
      case 'dust':
      case 'haze':
      case 'smoke':
      case 'mist':
        return 'assets/cloudy.json';
      case 'rain':
      case 'shower rain':
      case 'drizzle':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    constraints: BoxConstraints(maxWidth: 350),
                    labelText: 'Enter City Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _fetchWeather,
                  child: Text('Get Weather'),
                ),
                SizedBox(height: 16),
                if (_isLoading) CircularProgressIndicator(),
                if (_weather != null)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _weather!.cityName,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const Icon(Icons.location_on)
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(getCurrentTime(),
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      Text(getCurrentDate()),
                      SizedBox(height: 10),
                      Lottie.asset(weatherAnimation(_weather!.weather),
                          height: 150),
                      Text(
                        '${_weather!.weather},',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _weather!.description,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${_weather!.temperature}°C',
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        height: 150,
                        width: 250,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Icon(
                                      Icons.wind_power,
                                      color: Colors.cyan[100],
                                      size: 15,
                                    ),
                                    Text('${_weather!.minTemperature}°C'),
                                    const Text(
                                      'minTemp',
                                      style: TextStyle(fontSize: 12),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Icon(
                                      Icons.sunny,
                                      size: 15,
                                      color: Colors.cyan[100],
                                    ),
                                    Text('${_weather!.maxTemperature}°C'),
                                    const Text(
                                      'maxTemp',
                                      style: TextStyle(fontSize: 12),
                                    )
                                  ],
                                )
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Icon(
                                      Icons.air,
                                      color: Colors.cyan[100],
                                      size: 15,
                                    ),
                                    Text('${_weather!.pressure}Hg'),
                                    const Text(
                                      'Pressure',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Icon(
                                      Icons.water_drop,
                                      color: Colors.cyan[100],
                                      size: 15,
                                    ),
                                    Text('${_weather!.humidity}%'),
                                    const Text(
                                      'humidity',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
