import 'package:flutter/material.dart';
import 'package:store_room2/pages/search_page/views/scan_qr_code.dart';
import 'package:store_room2/pages/search_page/views/scanner_button.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Opacity(
              opacity: 0.7,
              child: Image.asset(
                'assets/images/search_screen_background.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            // Main Content
            Container(
              padding:  EdgeInsets.only(bottom: (MediaQuery.of(context).size.height*0.12)),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ScannerButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ScanQRCode(),
                      ));
                    },
                  ),
                  const SizedBox(
                      height:
                          16), // Add some spacing between the button and the text
                  const Text(
                    'Tara', // Your text
                    style: TextStyle(
                      color: Colors.white, // Text color
                      fontSize: 20, // Text size
                      fontWeight: FontWeight.bold, // Text weight
                    ),
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



