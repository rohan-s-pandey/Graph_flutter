import 'package:flutter/material.dart';
import 'package:graph_app/add_data_page.dart';
import 'line_chart_widget.dart';
import 'bar_chart_widget.dart';
import 'pie_chart_widget.dart';
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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedChartIndex = 0;

  List<FlSpot> _lineData = [];
  List<BarChartGroupData> _barData = [];
  List<PieChartSectionData> _pieData = [];

  Widget _buildSelectedChart() {
    switch (_selectedChartIndex) {
      case 0:
        return LineChartWidget(
          dataPoints: _lineData,
          xAxisLabel: '',
          yAxisLabel: '',
        );
      case 1:
        return BarChartWidget(
          barData: _barData,
          xAxisLabel: '',
          yAxisLabel: '',
          barLabels: [],
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
                    result['lineData'], result['barData'], result['pieData']);
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
