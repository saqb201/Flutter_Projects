import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:weather_app/data/repositories/weather_repositories_impl.dart';
import 'package:weather_app/domain/usecases/get_current_cases.dart';
import 'package:weather_app/presentation/pages/weather_pages.dart';
import 'presentation/provider/weather_provider.dart';
import 'data/datasources/weather_remote_data_source.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Setup dependencies manually
    final dio = Dio();
    final remoteDataSource = WeatherRemoteDataSourceImpl(dio);
    final repository = WeatherRepositoryImpl(remoteDataSource);
    final getCurrentWeather = GetCurrentWeather(repository);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(getCurrentWeather),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData.dark(useMaterial3: true),
        home: const WeatherPage(), // ✅ Wrapped properly
      ),
    );
  }
}
