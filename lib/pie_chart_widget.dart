import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChartWidget extends StatelessWidget {
  final List<PieChartSectionData> pieSections;

  const PieChartWidget({Key? key, required this.pieSections}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SfCircularChart(
            title: ChartTitle(text: 'Distribution of Data'),
            legend: Legend(isVisible: true),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CircularSeries>[
              PieSeries<PieChartSectionData, String>(
                dataSource: pieSections,
                xValueMapper: (PieChartSectionData data, _) => data.title,
                yValueMapper: (PieChartSectionData data, _) => data.value,
                explode: true, // Add explosion effect
                explodeIndex: -1, // Index of the exploded slice
                dataLabelMapper: (PieChartSectionData data, _) => data.title,
                dataLabelSettings: DataLabelSettings(isVisible: true),
              )
            ],
          ),
        ),
        // Add legends here if not using the built-in legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: pieSections.map((section) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    color: section.color,
                  ),
                  SizedBox(width: 4),
                  Text(section.title ?? ''),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
