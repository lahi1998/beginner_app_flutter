import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'View/home_screen.dart';
import 'Provider/home_screen_provider.dart';

// Entry point of the Flutter app
void main() {
  runApp(
    // Wrap the root widget with the ChangeNotifierProvider to provide the state
    ChangeNotifierProvider(
      create: (context) => HomeScreenProvider(), // Create instance of the provider
      child: const MyApp(), // Run the main app widget
    ),
  );
}

// MyApp widget: The main app widget
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Flutter demo",
      home: HomeScreen(), // Set HomeScreen as the initial screen
    );
  }
}
