import 'package:weather_app/domain/repositories/weather_repo.dart';

import '../../domain/entities/weather.dart';
import '../datasources/weather_remote_data_source.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl(this.remoteDataSource);

  @override
  Future<Weather> getCurrentWeather(String city) {
    return remoteDataSource.getCurrentWeather(city);
  }
}
