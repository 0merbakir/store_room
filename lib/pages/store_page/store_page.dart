import 'package:flutter/material.dart';
import 'package:store_room/models/store_room.dart';
import 'package:store_room/pages/store_page/views/add_shelf_button.dart';
import 'package:store_room/pages/store_page/subpages/create_space_page.dart';
import 'package:store_room/pages/store_page/views/pie_chart.dart';
import 'package:store_room/services/database_helper_store_room.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  List<StoreRoom> allstoreRooms = [];

  @override
  void initState() {
    super.initState();

    initializeStoreRooms();
  }

  void initializeStoreRooms() async {
    allstoreRooms = await fetchAllStoreRooms();
    setState(() {});
  }

  Future<List<StoreRoom>> fetchAllStoreRooms() async {
    return await StoreRoomDatabaseHelper.fetchAllStoreRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                const Color.fromARGB(255, 248, 248, 250)
                    .withOpacity(0.7), // Adjust the color and opacity as needed
                BlendMode.srcATop,
              ),
              child: Image.asset(
                'assets/images/store_room_background.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                bottom: (MediaQuery.of(context).size.height * 0.25),
                top: (MediaQuery.of(context).size.height * 0.001),
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(8),
              child: GridView.builder(
                // eleman sayısı
                itemCount: allstoreRooms.length,
                // elemanlara her yerden 5 oranında boşluk ver
                padding: const EdgeInsets.all(2),
                // yan yana eleman sayısı
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8, // Vertical margin between grid items
                  crossAxisSpacing: 8, // Horizontal margin between grid items
                ),
                itemBuilder: (BuildContext context, int index) {
                  return ChartPie(storeRoom: allstoreRooms[index]);
                },
              ),
            ),
            if (allstoreRooms.isEmpty)
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 63, 2, 87)
                            .withOpacity(0.07),
                         spreadRadius: 0.5,
                          blurRadius: 45, // Increase the blur radius
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Depolamaya Başla!',
                    style: TextStyle(
                      color: Color.fromARGB(196, 36, 2, 47),
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            Container(
              padding: EdgeInsets.only(
                bottom: (MediaQuery.of(context).size.height * 0.14),
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
