import 'package:flutter/material.dart';
import 'package:load_url_image/provider/audio_provider.dart';
import 'package:load_url_image/screen/audio_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AudioProvider(),
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const AudioScreen(),
      ),
    );
  }
}
