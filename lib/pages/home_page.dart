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
      backgroundColor: Colors.deepPurple[400],
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    constraints: BoxConstraints(maxWidth: 350),
                    labelText: 'Enter City Name',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _fetchWeather,
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.deepPurpleAccent[200]),
                  ),
                  child: const Text(
                    'Get Weather',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_isLoading) const CircularProgressIndicator(),
                if (_weather != null)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _weather!.cityName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          const Icon(
                            Icons.location_on,
                            color: Colors.amber,
                            size: 20,
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        getCurrentDate(),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      Text(getCurrentTime(),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          )),
                      const SizedBox(height: 10),
                      Lottie.asset(weatherAnimation(_weather!.weather),
                          height: 150),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${_weather!.weather},',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${_weather!.description}.',
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${_weather!.temperature}°C',
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent[200],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0))),
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        height: 150,
                        width: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    const Icon(
                                      Icons.wind_power,
                                      color: Colors.amber,
                                      size: 15,
                                    ),
                                    weatherDetails(
                                        title: 'minTemp',
                                        value: '${_weather!.minTemperature}°C'),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Icon(
                                      Icons.airline_stops,
                                      size: 15,
                                      color: Colors.amber,
                                    ),
                                    weatherDetails(
                                        title: 'FeelsLike',
                                        value: '${_weather!.feelsLike}°C'),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Icon(
                                      Icons.sunny,
                                      size: 15,
                                      color: Colors.amber,
                                    ),
                                    weatherDetails(
                                        title: 'maxTemp',
                                        value: '${_weather!.maxTemperature}°C'),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    const Icon(
                                      Icons.air,
                                      color: Colors.amber,
                                      size: 15,
                                    ),
                                    weatherDetails(
                                        title: 'Pressure',
                                        value: '${_weather!.pressure}hpA'),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Icon(
                                      Icons.wind_power_sharp,
                                      color: Colors.amber,
                                      size: 15,
                                    ),
                                    weatherDetails(
                                        title: 'Wind',
                                        value: '${_weather!.wind}m/s'),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Icon(
                                      Icons.water_drop,
                                      color: Colors.amber,
                                      size: 15,
                                    ),
                                    weatherDetails(
                                        title: 'Humidity',
                                        value: '${_weather!.humidity}%'),
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

  Column weatherDetails({required String title, required String value}) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
