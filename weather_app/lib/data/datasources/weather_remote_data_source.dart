import 'package:dio/dio.dart';
import 'package:weather_app/core/constant/api_constant.dart';
import 'package:weather_app/core/error/exception.dart';
import '../models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getCurrentWeather(String city);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final Dio dio;
  WeatherRemoteDataSourceImpl(this.dio);

  @override
  Future<WeatherModel> getCurrentWeather(String city) async {
    // const apiKey = 'b085128c8f178205558ef9d489f9dbe5';
    try {
      final response = await dio.get(
        'https://api.allorigins.win/raw?url=https://api.openweathermap.org/data/2.5/weather',
        queryParameters: {
          'q': city,
          'appid': ApiConstants.apiKey,
          'units': 'metric',
        },
      );

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data);
      } else {
        throw ServerException('Error: ${response.statusMessage}');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
