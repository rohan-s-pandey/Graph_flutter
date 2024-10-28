import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartWidget extends StatelessWidget {
  final List<PieChartSectionData> pieSections;

  const PieChartWidget({super.key, required this.pieSections});

  @override
  Widget build(BuildContext context) {
    // Calculate total value for percentage calculations
    double totalValue =
        pieSections.fold(0, (sum, section) => sum + section.value);

    return Column(
      children: [
        Expanded(
          child: SfCircularChart(
            title: const ChartTitle(text: 'Distribution of Data'),
            legend: const Legend(isVisible: true),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CircularSeries>[
              PieSeries<PieChartSectionData, String>(
                dataSource: pieSections,
                xValueMapper: (PieChartSectionData data, _) => data.title,
                yValueMapper: (PieChartSectionData data, _) => data.value,
                explode: true, // Add explosion effect
                explodeIndex: -1, // Index of the exploded slice
                dataLabelMapper: (PieChartSectionData data, _) {
                  final percentage =
                      ((data.value / totalValue) * 100).toStringAsFixed(1);
                  return '${data.title}: ${data.value} ($percentage%)';
                },
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              )
            ],
          ),
        ),
        _buildLegends(context),
      ],
    );
  }

  Widget _buildLegends(BuildContext context) {
    // Responsive design for legends
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: isSmallScreen
          ? Wrap(
              alignment: WrapAlignment.center,
              children: _buildLegendItems(),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildLegendItems(),
            ),
    );
  }

  List<Widget> _buildLegendItems() {
    return pieSections.map((section) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20,
              height: 20,
              color: section.color,
            ),
            const SizedBox(width: 4),
            Text(section.title ?? ''),
          ],
        ),
      );
    }).toList();
  }
}
