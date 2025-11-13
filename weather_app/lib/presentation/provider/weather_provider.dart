import 'package:flutter/material.dart';
import 'package:weather_app/domain/usecases/get_current_cases.dart';
import '../../domain/entities/weather.dart';


class WeatherProvider extends ChangeNotifier {
  final GetCurrentWeather getCurrentWeather;

  WeatherProvider(this.getCurrentWeather);

  Weather? _weather;
  Weather? get weather => _weather;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchWeather(String city) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _weather = await getCurrentWeather(city);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
