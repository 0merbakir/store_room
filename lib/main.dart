
import 'package:flutter/material.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar_item.dart';
import 'package:store_room/pages/search_page/search_page.dart';
import 'package:store_room/pages/store_page/store_page.dart';
import 'package:store_room/pages/profile_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BottomBar());
}

class BottomBar extends StatelessWidget {
  BottomBar({super.key});
  final _pageController = PageController();

  @protected
  @mustCallSuper
  void dispose() {
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:  
      ThemeData(
        primaryColor: Colors.blueAccent, // Setting primary color to blue
        
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: PageView(
          controller: _pageController,
          children: const <Widget>[
            SearchPage(),
            StorePage(),
            ProfilePage(),
          ],
        ),
        extendBody: true,
        bottomNavigationBar: RollingBottomBar(
          color: const Color.fromARGB(255, 234, 231, 229),
          controller: _pageController,
          flat: true,
          useActiveColorByDefault: false,
          items: const [
            RollingBottomBarItem(Icons.qr_code_scanner,
                label: 'Tara', activeColor: Colors.blueAccent),
            RollingBottomBarItem(
              Icons.store_mall_directory_rounded,
              label: 'Depo',
              activeColor: Color.fromARGB(255, 11, 11, 125),
            ),
            RollingBottomBarItem(Icons.person,
                label: 'Hesap', activeColor: Colors.blueAccent),
          ],
          enableIconRotation: true,
          onTap: (index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          },
        ),
      ),
    );
  }
}
