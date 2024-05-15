import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_room/models/store_room.dart';
import 'package:store_room/pages/store_page/subpages/room_details_page.dart';
import 'package:store_room/pages/widgets/dragon_widget_icon.dart';
import 'package:store_room/services/database_helper_store_room.dart';
import 'package:logger/logger.dart';

class CreateSpacePage extends StatefulWidget {
  const CreateSpacePage({super.key});

  @override
  State<CreateSpacePage> createState() => _CreateSpacePageState();
}

class _CreateSpacePageState extends State<CreateSpacePage> {
  final TextEditingController _areaNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  StoreRoom? newRoom;

  var logger = Logger();

  Future<void> _submit() async {
    try {
      newRoom = StoreRoom(
        id: UniqueKey().toString(),
        title: _areaNameController.text,
      );

      await StoreRoomDatabaseHelper.insertStoreRoom(newRoom!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alan başarıyla oluşturuldu.'),
          backgroundColor: Colors.green,
        ),
      );

      _areaNameController.clear();
    } catch (e) {
      logger.e('Error while submitting: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alan oluşturulurken bir hata oluştu.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'createSpace',
        onPressed: () {
          if (!_formKey.currentState!.validate()) {
            return;
          } else {
            _submit();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (ctx) => RoomDetailsPage(storeRoom: newRoom!),
              ),
            );
          }
        },
        icon: const Icon(Icons.create_rounded),
        label: const Text('Alan OLuştur'),
        backgroundColor: const Color.fromARGB(
            255, 238, 238, 240), // Set the background color
        foregroundColor: const Color.fromARGB(
            255, 90, 6, 215), // Set the foreground color (text color)
        elevation: 50,
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(25), // Make the button more circular
            side: const BorderSide(color: Color.fromARGB(28, 61, 43, 43))),
      ),
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    const DragonIconWidget(
                        imagePath: 'assets/images/dragon.png', text: ''),
                    Flexible(
                      child: Text(
                        '"Ürünlerinizi kolayca Organize Edin ve Saklayın".',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.06,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(138, 0, 0, 0),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                  ),
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
