import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/data/repositories/weather_repositories_impl.dart';
import 'package:weather_app/domain/usecases/get_current_cases.dart';
import 'package:weather_app/presentation/provider/weather_provider.dart';
import 'data/datasources/weather_remote_data_source.dart';


List<ChangeNotifierProvider> buildProviders() {
  final dio = Dio();
  final remoteDataSource = WeatherRemoteDataSourceImpl(dio);
  final repository = WeatherRepositoryImpl(remoteDataSource);
  final useCase = GetCurrentWeather(repository);

  return [ChangeNotifierProvider(create: (_) => WeatherProvider(useCase))];
}
