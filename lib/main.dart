import 'package:flutter/material.dart';
import 'package:graph_app/home_page.dart'; // Updated import
import 'package:graph_app/add_data_page.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modern Graph App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.indigo,
        ).copyWith(secondary: Colors.teal),
      ),
      home: HomePage(),
    );
  }
}
