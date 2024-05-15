import 'package:flutter/material.dart';
import 'package:store_room/models/store_room.dart';
import 'package:store_room/pages/store_page/subpages/room_details_page.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartPie extends StatefulWidget {
  final StoreRoom storeRoom;
  const ChartPie({Key? key, required this.storeRoom}) : super(key: key);

  @override
  ChartPieState createState() => ChartPieState();
}

class ChartPieState extends State<ChartPie> {
  List<StoreData> chartData = [
    StoreData('Jan', 90),
    StoreData('Feb', 10),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => RoomDetailsPage(storeRoom: widget.storeRoom),
        // ));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: const Color.fromARGB(
                120, 245, 245, 245), // White-toned background
            border: Border.all(
              color: const Color.fromARGB(213, 23, 36, 121), // Border color
              width: 1, // Border width
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: GestureDetector(
              // Wrap the chart with GestureDetector
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      RoomDetailsPage(storeRoom: widget.storeRoom),
                ));
              },
              child: SfCircularChart(
                backgroundColor: Colors.transparent,
                onCreateShader: (ChartShaderDetails details) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(117, 90, 89, 89), // Top color with opacity
                      Color.fromARGB(255, 11, 11, 125), // Bottom color
                    ],
                    stops: [0.0, 0.3], // Gradient stops
                  ).createShader(details.outerRect); // Use details.bounds
                },
                onDataLabelRender: (DataLabelRenderArgs args) {
                  double value = double.parse(args.text!);
                  args.text = value.toStringAsFixed(0);
                },
                title: ChartTitle(
                  text: widget.storeRoom.title,
                  textStyle: const TextStyle(
                    color: Color.fromARGB(122, 9, 5, 44),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                palette: const <Color>[
                  Color.fromARGB(205, 11, 45, 181),
                  Color.fromARGB(105, 69, 58, 115),
                ],
                series: <CircularSeries<StoreData, String>>[
                  PieSeries<StoreData, String>(
                    selectionBehavior: SelectionBehavior(enable: false),
                    onPointTap: (tap) => {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            RoomDetailsPage(storeRoom: widget.storeRoom),
                      ))
                    },
                    // Disable selection behavior
                    explode: false, // Enable exploding slices

                    explodeOffset: '10%',
                    dataSource: chartData,
                    xValueMapper: (StoreData sales, _) => sales.year,
                    yValueMapper: (StoreData sales, _) => sales.sales,
                    name: 'Sales',
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      textStyle:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
