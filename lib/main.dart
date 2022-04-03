import 'package:flutter/material.dart';
import 'package:patterns_setstate/pages/create_page.dart';
import 'package:patterns_setstate/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        HomePage.id: (context) => const HomePage(),
        CreatePage.id: (context) => const CreatePage(),
      },
    );
  }
}

