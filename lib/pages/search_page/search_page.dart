import 'package:flutter/material.dart';
import 'package:store_room/pages/search_page/views/scanned_product_details.dart';
import 'package:store_room/pages/widgets/dragon_widget_icon.dart';
import 'package:store_room/pages/search_page/views/scan_qr_code.dart';
import 'package:store_room/pages/search_page/views/scanner_button.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? _scanResult;

  void _startQRScan(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScanQRCode()),
    );
    if (result != null) {
      setState(() {
        _scanResult = result as String;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Opacity(
              opacity: 0.8,
              child: Image.asset(
                'assets/images/search_screen_background.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  bottom: (MediaQuery.of(context).size.height * 0.12)),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 248, 249, 250)
                              .withOpacity(0.12),
                          spreadRadius: 0.5,
                          blurRadius: 45, // Increase the blur radius
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Tıkla ve Tara',
                      style: TextStyle(
                        color: Color.fromARGB(245, 255, 255, 255),
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  const DragonIconWidget(
                      imagePath: 'assets/images/dragon.png', text: 'Merhaba!'),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 248, 249, 250)
                              .withOpacity(0.12),
                          spreadRadius: 0.5,
                          blurRadius: 45, // Increase the blur radius
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                  ScannerButton(
                    onPressed: () {
                      _startQRScan(context);
                    },
                  ),
                ],
              ),
            ),
            if (_scanResult != null)
             ScannedProductDetails(code: _scanResult!),
          ],
        ),
      ),
    );
  }
}
