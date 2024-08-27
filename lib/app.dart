import 'package:flutter/material.dart';

import 'screens/main_screen/main_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Start Up Management',
      theme: ThemeData(
        fontFamily: 'Roboto',
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      home: const MainScreen(),
    );
  }
}
