// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class WeightChart extends StatefulWidget {
//   const WeightChart({super.key});

//   @override
//   State<WeightChart> createState() => _WeightChartState();
// }

// class _WeightChartState extends State<WeightChart> {
//   late List<WeightData> _chartData;

//   @override
//   void initState() {
//     _chartData = getChartData();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SfCartesianChart(
//       series: <ChartSeries>[
//         LineSeries<WeightData, int>(
//           dataSource: _chartData,
//           xValueMapper: (WeightData date, _) => date.date,
//           yValueMapper: (WeightData weight, _) => weight.weightNum,
//           dataLabelSettings: const DataLabelSettings(isVisible: true),
//         )
//       ],
//       primaryXAxis: NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
//     );
//   }

//   List<WeightData> getChartData() {
//     final List<WeightData> chartData = [
//       WeightData(1, 270),
//       WeightData(2, 265),
//       WeightData(3, 250),
//       WeightData(4, 220),
//     ];
//     return chartData;
//   }
// }

// class WeightData {
//   WeightData(this.date, this.weightNum);
//   final int date;
//   final int weightNum;
// }
