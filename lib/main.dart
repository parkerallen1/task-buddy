import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const TaskBuddyApp());
}

class TaskBuddyApp extends StatelessWidget {
  const TaskBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Buddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB4A7D6),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
          titleLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(fontSize: 24),
          bodyMedium: TextStyle(fontSize: 20),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
