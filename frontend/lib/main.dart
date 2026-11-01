import 'package:flutter/material.dart';
import 'package:frontend/pages/page_login.dart';

const String baseUrl = 'http://10.237.186.105:3000';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Manajemen Data Siswa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const PageLogin(),
    );
  }
}