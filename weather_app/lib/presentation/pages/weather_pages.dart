import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/weather_provider.dart';
import '../widgets/animated_weather_background.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _controller = TextEditingController(text: "London");

  @override
  void initState() {
    super.initState();
    // ✅ Fetch weather safely AFTER the widget tree is built
    Future.microtask(() {
      final provider = context.read<WeatherProvider>();
      provider.fetchWeather(_controller.text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ✅ Animated background (only if weather available)
          if (provider.weather != null)
            AnimatedWeatherBackground(condition: provider.weather!.condition)
          else
            Container(color: Colors.black),

          // ✅ Foreground UI
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Search box
                    TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white10,
                        hintText: 'Enter city',
                        hintStyle: const TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search, color: Colors.white),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            provider.fetchWeather(_controller.text.trim());
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ✅ Display different states
                    if (provider.isLoading)
                      const CircularProgressIndicator(color: Colors.white)
                    else if (provider.error != null)
                      Text(
                        provider.error!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 18,
                        ),
                      )
                    else if (provider.weather != null)
                      Column(
                        children: [
                          Text(
                            provider.weather!.cityName,
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${provider.weather!.temperature.toStringAsFixed(1)}°C',
                            style: Theme.of(context).textTheme.displayLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            provider.weather!.condition,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
