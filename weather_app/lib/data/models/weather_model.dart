import '../../domain/entities/weather.dart';

class WeatherModel extends Weather {
  const WeatherModel({
    required super.cityName,
    required super.temperature,
    required super.condition,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? '',
      temperature: (json['main']['temp'] as num?)?.toDouble() ?? 0.0,
      condition: json['weather']?[0]['main'] ?? 'Unknown',
    );
  }
}
