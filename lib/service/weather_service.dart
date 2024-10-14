import 'dart:convert';

// import 'package:app/key.dart';
import 'package:app/model/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<Weather> fetchData(city) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=a725c4ea786081ddc11ba6becc71fa5a&units=metric'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      final data = jsonDecode(response.body);
      return Weather.fromJson(data);
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load data');
    }
  }
}
