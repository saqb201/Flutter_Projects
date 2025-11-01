import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabasedb/Screens/auth_screen.dart';
import 'package:supabasedb/Screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://vqjsjzhyjgqsfqvdjrjt.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZxanNqemh5amdxc2ZxdmRqcmp0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE4Mzg4MjcsImV4cCI6MjA3NzQxNDgyN30.4DEY-2li62Ck6OG3HMH5e2mJcRHOIntTzvWL4WpWFO4',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    return MaterialApp(
      title: 'Animated Auth',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: session == null ? const AuthScreen() : const HomeScreen(),
    );
  }
}
