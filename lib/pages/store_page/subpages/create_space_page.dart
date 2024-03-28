import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_room2/models/store_room.dart';
import 'package:store_room2/pages/store_page/subpages/room_details_page.dart';
import 'package:store_room2/services/database_helper_store_room.dart';
import 'package:logger/logger.dart';

class CreateSpacePage extends StatefulWidget {
  const CreateSpacePage({super.key});

  @override
  State<CreateSpacePage> createState() => _CreateSpacePageState();
}

class _CreateSpacePageState extends State<CreateSpacePage> {
  final TextEditingController _areaNameController = TextEditingController();
  final TextEditingController _spaceController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Step 2

  var logger = Logger();

  Future<void> _submit() async {
    try {
      final newRoom = StoreRoom(
        id: UniqueKey().toString(),
        roomId: _areaNameController.text,
        space: _spaceController.text,
      );

      // Insert the new room into the database
      await StoreRoomDatabaseHelper.insertStoreRoom(newRoom);

      // Retrieve all stored rooms from the database
      final List<StoreRoom> allRooms =
          await StoreRoomDatabaseHelper.fetchAllStoreRooms();

      // Log all stored rooms
      allRooms.forEach((room) {
        logger.d(
            'Room ID: ${room.id}, Area Name: ${room.roomId}, Space: ${room.space}');
      });

      // Show a success message using SnackBar
      if(!mounted){
        
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alan başarıyla oluşturuldu.'),
          backgroundColor: Colors.green, // Set background color to green
        ),
      );

      // Clear input fields after successful submission
      _areaNameController.clear();
      _spaceController.clear();
    } catch (e) {
      // Handle any errors and log them
      logger.e('Error while submitting: $e');

      // Show an error message using SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alan oluşturulurken bir hata oluştu.'),
          backgroundColor: Colors.red, // Set background color to red
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            // Step 1: Wrap with Form
            key: _formKey, // Step 2: Assign GlobalKey<FormState>
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: TextFormField(
                    controller: _areaNameController,
                    decoration: InputDecoration(
                      hintText: "Alan adı",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      labelText: 'Alan',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Alan adı boş olamaz';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: TextFormField(
                    controller: _spaceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintText: "Hacim (cm³)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      labelText: 'Hacim',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Hacim boş olamaz';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      // Step 4: Validate the form before submitting
                      return;
                    } else {
                     // _submit();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const RoomDetailsPage(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 0, 48, 86)
                        .withOpacity(0.8), // Semi-transparent background color
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15), // Button border radius
                    ),
                    elevation: 2, // Button elevation
                    shadowColor:
                        const Color.fromARGB(185, 29, 2, 118), // Shadow color
                  ),
                  child: const Text(
                    'Alan Oluştur',
                    style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(
                            187, 13, 2, 93)), // Text style with black color
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
