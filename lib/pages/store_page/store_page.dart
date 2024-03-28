import 'package:flutter/material.dart';
import 'package:store_room2/pages/store_page/views/add_shelf_button.dart';
import 'package:store_room2/pages/store_page/subpages/create_space_page.dart';
import 'package:store_room2/pages/store_page/views/pie_chart.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/images/store_room_background.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                bottom: (MediaQuery.of(context).size.height * 0.25),
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(8),
              child: GridView.builder(
                // eleman sayısı
                itemCount: 5,
                // elemanlara her yerden 5 oranında boşluk ver
                padding: const EdgeInsets.all(2),
                // yan yana eleman sayısı
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8, // Vertical margin between grid items
                  crossAxisSpacing: 8, // Horizontal margin between grid items
                ),
                itemBuilder: (BuildContext context, int index) {
                  return ChartPie();
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                bottom: (MediaQuery.of(context).size.height * 0.15),
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AddShelfButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CreateSpacePage(),
                      ));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
