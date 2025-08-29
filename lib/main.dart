import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home.dart';
import 'provider/status_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => StatusProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserFetcherPage(),
    );
  }
}
