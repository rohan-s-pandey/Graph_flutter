import 'package:flutter/material.dart';
import 'package:graph_app/add_data_page.dart';
import 'line_chart_widget.dart';
import 'bar_chart_widget.dart';
import 'pie_chart_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedChartIndex = 0;

  List<FlSpot> _lineData = [];
  List<BarChartGroupData> _barData = [];
  List<PieChartSectionData> _pieData = [];

  @override
  void initState() {
    super.initState();
    _loadChartData();
  }

  Future<void> _loadChartData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load line data
    String? lineDataString = prefs.getString('lineData');
    if (lineDataString != null) {
      List<dynamic> lineDataJson = jsonDecode(lineDataString);
      _lineData = lineDataJson
          .map((e) => FlSpot(e[0].toDouble(), e[1].toDouble()))
          .toList();
    }

    // Load bar data
    String? barDataString = prefs.getString('barData');
    if (barDataString != null) {
      List<dynamic> barDataJson = jsonDecode(barDataString);
      _barData = barDataJson.map((e) {
        return BarChartGroupData(
          x: e[0],
          barRods: [BarChartRodData(toY: e[1].toDouble())],
        );
      }).toList();
    }

    // Load pie data
    String? pieDataString = prefs.getString('pieData');
    if (pieDataString != null) {
      List<dynamic> pieDataJson = jsonDecode(pieDataString);
      _pieData = pieDataJson.map((e) {
        return PieChartSectionData(
          value: e[0].toDouble(),
          title: e[1],
          color: Colors
              .primaries[pieDataJson.indexOf(e) % Colors.primaries.length],
        );
      }).toList();
    }

    setState(() {}); // Refresh the UI after loading data
  }

  Future<void> _saveChartData() async {
    final prefs = await SharedPreferences.getInstance();

    // Save line data
    await prefs.setString(
        'lineData', jsonEncode(_lineData.map((e) => [e.x, e.y]).toList()));

    // Save bar data
    await prefs.setString('barData',
        jsonEncode(_barData.map((e) => [e.x, e.barRods[0].toY]).toList()));

    // Save pie data
    await prefs.setString('pieData',
        jsonEncode(_pieData.map((e) => [e.value, e.title]).toList()));
  }

  @override
  void dispose() {
    _saveChartData(); // Save data when disposing the page
    super.dispose();
  }

  Widget _buildSelectedChart() {
    switch (_selectedChartIndex) {
      case 0:
        return LineChartWidget(
          dataPoints: _lineData,
          xAxisLabel: '',
          yAxisLabel: '',
        );
      case 1: // Bar chart
        return BarChartWidget(
          barData: _barData,
          xAxisLabel: '',
          yAxisLabel: '',
          barLabels: [], // Populate if necessary
        );
      case 2:
        return PieChartWidget(pieSections: _pieData);
      default:
        return Container();
    }
  }

  void _onBottomNavBarTap(int index) {
    setState(() {
      _selectedChartIndex = index;
    });
  }

  void _updateChartData(List<FlSpot> lineData, List<BarChartGroupData> barData,
      List<PieChartSectionData> pieData) {
    setState(() {
      _lineData = lineData;
      _barData = barData;
      _pieData = pieData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modern Graphs'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddDataPage()),
              );

              if (result != null) {
                _updateChartData(
                  result['lineData'],
                  result['barData'],
                  result['pieData'],
                );
                await _saveChartData(); // Save after updating data
              }
            },
          ),
        ],
      ),
      body: Expanded(
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: Center(
            key: ValueKey<int>(_selectedChartIndex),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildSelectedChart(),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedChartIndex,
        onTap: _onBottomNavBarTap,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Line'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Bar'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Pie'),
        ],
      ),
    );
  }
}
