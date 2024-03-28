import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartPie extends StatefulWidget {
  const ChartPie({Key? key}) : super(key: key);

  @override
  ChartPieState createState() => ChartPieState();
}

class ChartPieState extends State<ChartPie> {
  List<StoreData> chartData = [
    StoreData('Jan', 80),
    StoreData('Feb', 20),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: const Color.fromARGB(255, 9, 9, 9).withOpacity(0.3),
        spreadRadius: 2,
        blurRadius: 5,
        offset: const Offset(0, 3),
      ),
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: SfCircularChart(
      backgroundColor: Colors.transparent,
      onDataLabelRender: (DataLabelRenderArgs args) {
        double value = double.parse(args.text!);
        args.text = value.toStringAsFixed(0);
      },
      title: const ChartTitle(
        text: 'Chart Name',
        textStyle: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255), // Text color
          fontSize: 12, // Text size
          fontWeight: FontWeight.bold, // Text weight
        ),
      ),
      palette: const [
        Color.fromARGB(205, 11, 45, 181),
        Color.fromARGB(156, 76, 75, 80)
      ],
      series: <CircularSeries<StoreData, String>>[
        PieSeries<StoreData, String>(
          selectionBehavior: SelectionBehavior(enable: true),
          explode: true,
          dataSource: chartData,
          xValueMapper: (StoreData sales, _) => sales.year,
          yValueMapper: (StoreData sales, _) => sales.sales,
          name: 'Sales',
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
          ),
        ),
      ],
    ),
  ),
);

  }
}

class StoreData {
  StoreData(this.year, this.sales);

  final String year;
  final double sales;
}

