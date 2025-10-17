import 'package:flutter/material.dart';
import 'view/todo_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MVVM Counter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoScreen(),
    );
  }
}
