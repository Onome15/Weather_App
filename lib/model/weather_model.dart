class Weather {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final double minTemperature;
  final double maxTemperature;
  final String description;
  final double pressure;
  final double humidity;
  final String weather;
  final double wind;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.description,
    required this.minTemperature,
    required this.maxTemperature,
    required this.pressure,
    required this.humidity,
    required this.weather,
    required this.wind,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      minTemperature: json['main']['temp_min'].toDouble(),
      maxTemperature: json['main']['temp_max'].toDouble(),
      pressure: json['main']['pressure'],
      humidity: json['main']['humidity'],
      weather: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      wind: json['wind']['speed'].toDouble(),
    );
  }
}
