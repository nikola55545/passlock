import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:passlock/register.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'firebase_options.dart';
import 'home_page.dart';
import 'vault_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure widgets are initialized before using Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeTab(),
    Container(),
    VaultTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          _pages[_currentIndex],
          Align(
            alignment: Alignment.bottomCenter,
            child: CupertinoTabBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                if (index == 1) {
                  _openModalBottomSheet(context);
                } else {
                  setState(() {
                    _currentIndex = index;
                  });
                }
              },
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: FaIcon(
                    FontAwesomeIcons.house,
                    size: 24,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(
                    FontAwesomeIcons.plus,
                  ),
                  label: 'Add New',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(
                    FontAwesomeIcons.lock,
                    size: 24,
                  ),
                  label: 'Vault',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openModalBottomSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('This is the content of the Add New modal.'),
          ],
        ),
      ),
    );
  }
}
