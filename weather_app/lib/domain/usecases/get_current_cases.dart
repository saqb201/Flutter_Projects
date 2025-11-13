import 'package:weather_app/domain/repositories/weather_repo.dart';

import '../entities/weather.dart';

class GetCurrentWeather {
  final WeatherRepository repository;
  GetCurrentWeather(this.repository);

  Future<Weather> call(String city) => repository.getCurrentWeather(city);
}
