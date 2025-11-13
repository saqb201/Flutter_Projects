import '../entities/weather.dart';

abstract class WeatherRepository {
  Future<Weather> getCurrentWeather(String city);
}
