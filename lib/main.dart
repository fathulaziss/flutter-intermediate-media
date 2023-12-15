import 'package:flutter/material.dart';
import 'package:load_url_image/data/api/api_service.dart';
import 'package:load_url_image/provider/home_provider.dart';
import 'package:load_url_image/provider/upload_provider.dart';
import 'package:load_url_image/screen/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UploadProvider(ApiService()),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeScreen(),
      ),
    );
  }
}
