import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AddDataPage extends StatefulWidget {
  @override
  _AddDataPageState createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  final List<TextEditingController> _lineDataXControllers = [];
  final List<TextEditingController> _lineDataYControllers = [];
  final List<TextEditingController> _barDataControllers = [];
  final List<TextEditingController> _barLabelsControllers = [];
  final List<TextEditingController> _pieDataControllers = [];
  final List<TextEditingController> _pieLabelsControllers = [];

  final _xAxisLabelController = TextEditingController();
  final _yAxisLabelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _addLineDataField();
    _addBarDataField();
    _addPieDataField();
  }

  void _addLineDataField() {
    _lineDataXControllers.add(TextEditingController());
    _lineDataYControllers.add(TextEditingController());
  }

  void _addBarDataField() {
    _barDataControllers.add(TextEditingController());
    _barLabelsControllers.add(TextEditingController());
  }

  void _addPieDataField() {
    _pieDataControllers.add(TextEditingController());
    _pieLabelsControllers.add(TextEditingController());
  }

  void _removeField(List<TextEditingController> xControllers,
      List<TextEditingController> yControllers, int index) {
    if (index > 0) {
      xControllers.removeAt(index);
      yControllers.removeAt(index);
    }
  }

  @override
  void dispose() {
    _lineDataXControllers.forEach((controller) => controller.dispose());
    _lineDataYControllers.forEach((controller) => controller.dispose());
    _barDataControllers.forEach((controller) => controller.dispose());
    _barLabelsControllers.forEach((controller) => controller.dispose());
    _pieDataControllers.forEach((controller) => controller.dispose());
    _pieLabelsControllers.forEach((controller) => controller.dispose());
    _xAxisLabelController.dispose();
    _yAxisLabelController.dispose();
    super.dispose();
  }

  void _submitData() {
    try {
      final lineData = List.generate(_lineDataXControllers.length, (index) {
        final xValue = _lineDataXControllers[index].text;
        final yValue = _lineDataYControllers[index].text;
        if (xValue.isEmpty || yValue.isEmpty) throw FormatException();
        return FlSpot(double.parse(xValue), double.parse(yValue));
      });

      final barData = List.generate(_barDataControllers.length, (index) {
        final barValue = _barDataControllers[index].text;
        if (barValue.isEmpty) throw FormatException();
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: double.parse(barValue),
              color: Colors.indigo,
            ),
          ],
          showingTooltipIndicators: [0],
        );
      });

      // Adding labels for each bar
      final barLabels =
          _barLabelsControllers.map((controller) => controller.text).toList();

      final pieData = List.generate(_pieDataControllers.length, (index) {
        final pieValue = _pieDataControllers[index].text;
        if (pieValue.isEmpty) throw FormatException();
        return PieChartSectionData(
          value: double.parse(pieValue),
          color: Colors.primaries[index % Colors.primaries.length],
          title: _pieLabelsControllers[index].text,
        );
      });

      Navigator.pop(context, {
        'lineData': lineData,
        'barData': barData,
        'barLabels': barLabels, // Pass bar labels here
        'pieData': pieData,
        'xAxisLabel': _xAxisLabelController.text,
        'yAxisLabel': _yAxisLabelController.text,
      });
    } catch (e) {
      if (e is FormatException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Please ensure all inputs are valid numbers.")),
        );
      } else {
        rethrow;
      }
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
      ),
    );
  }

  Widget _buildLineDataFields() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSectionHeader("Line Chart Data Points"),
            for (int i = 0; i < _lineDataXControllers.length; i++)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _lineDataXControllers[i],
                      decoration: InputDecoration(labelText: 'X${i + 1}'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _lineDataYControllers[i],
                      decoration: InputDecoration(labelText: 'Y${i + 1}'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                    onPressed: () => setState(() {
                      _removeField(
                          _lineDataXControllers, _lineDataYControllers, i);
                    }),
                  ),
                ],
              ),
            OutlinedButton(
              onPressed: () => setState(() => _addLineDataField()),
              child: Text('Add Line Data Point'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarDataFields() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSectionHeader("Bar Chart Data Points"),
            for (int i = 0; i < _barDataControllers.length; i++)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _barDataControllers[i],
                      decoration:
                          InputDecoration(labelText: 'Bar Height ${i + 1}'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _barLabelsControllers[i],
                      decoration: InputDecoration(labelText: 'Label ${i + 1}'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                    onPressed: () => setState(() {
                      if (_barDataControllers.length > 1) {
                        _barDataControllers.removeAt(i);
                        _barLabelsControllers.removeAt(i);
                      }
                    }),
                  ),
                ],
              ),
            OutlinedButton(
              onPressed: () => setState(() => _addBarDataField()),
              child: Text('Add Bar Data Point'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieDataFields() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSectionHeader("Pie Chart Data Points"),
            for (int i = 0; i < _pieDataControllers.length; i++)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _pieDataControllers[i],
                      decoration:
                          InputDecoration(labelText: 'Percentage ${i + 1}'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _pieLabelsControllers[i],
                      decoration: InputDecoration(labelText: 'Label ${i + 1}'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                    onPressed: () => setState(() {
                      if (_pieDataControllers.length > 1) {
                        _pieDataControllers.removeAt(i);
                        _pieLabelsControllers.removeAt(i);
                      }
                    }),
                  ),
                ],
              ),
            OutlinedButton(
              onPressed: () => setState(() => _addPieDataField()),
              child: Text('Add Pie Data Point'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Data'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _xAxisLabelController,
                      decoration: InputDecoration(labelText: 'X Axis Label'),
                    ),
                    TextField(
                      controller: _yAxisLabelController,
                      decoration: InputDecoration(labelText: 'Y Axis Label'),
                    ),
                  ],
                ),
              ),
            ),
            _buildLineDataFields(),
            _buildBarDataFields(),
            _buildPieDataFields(),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo[800],
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text('Submit Data', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
