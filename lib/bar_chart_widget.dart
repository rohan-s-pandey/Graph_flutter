import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarChartWidget extends StatelessWidget {
  final List<BarChartGroupData> barData;
  final String xAxisLabel;
  final String yAxisLabel;
  final List<String> barLabels;

  const BarChartWidget({
    Key? key,
    required this.barData,
    required this.xAxisLabel,
    required this.yAxisLabel,
    required this.barLabels,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String trendMessage = _calculateTrendMessage(barData);

    return Column(
      children: [
        Expanded(
          child: BarChart(
            BarChartData(
              barGroups: barData,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
              ),
              // Other chart properties...
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            trendMessage,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center, // Center the text for better UI
          ),
        ),
      ],
    );
  }

  String _calculateTrendMessage(List<BarChartGroupData> data) {
    if (data.length < 2) {
      return 'Not enough data to determine trend';
    }

    List<double> values = data.map((group) => group.barRods[0].toY).toList();

    bool isOverallIncreasing = true;
    bool hasSingleDrop = false;
    int dropIndex = -1;

    for (int i = 1; i < values.length; i++) {
      if (values[i] < values[i - 1]) {
        // If we have already seen a drop
        if (hasSingleDrop) {
          isOverallIncreasing = false; // More than one drop
          break;
        } else {
          hasSingleDrop = true; // Mark the first drop
          dropIndex = i;
        }
      }
    }

    if (isOverallIncreasing) {
      if (hasSingleDrop) {
        return 'Values are increasing except at value ${dropIndex}';
      } else {
        return 'Values are steadily increasing';
      }
    } else {
      // Resetting for a decreasing check
      isOverallIncreasing = false;
      hasSingleDrop = false;
      dropIndex = -1;

      for (int i = 1; i < values.length; i++) {
        if (values[i] > values[i - 1]) {
          // If we have already seen an increase
          if (hasSingleDrop) {
            isOverallIncreasing = false; // More than one increase
            break;
          } else {
            hasSingleDrop = true; // Mark the first increase
            dropIndex = i;
          }
        }
      }

      if (hasSingleDrop) {
        return 'Values are decreasing except at value ${dropIndex}';
      } else {
        return 'Values are steadily decreasing';
      }
    }

    // Handling start and end scenarios
    if (values.first < values.last) {
      return 'Value was increased from ${values.first} to ${values.last} and then started decreasing';
    } else {
      return 'Value was decreased from ${values.first} to ${values.last} and then started increasing';
    }
  }
}
