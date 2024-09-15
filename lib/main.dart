import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:passlock/register.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'firebase_options.dart';
import 'home_page.dart';
import 'vault_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
//import firestore package
import 'package:cloud_firestore/cloud_firestore.dart';

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
      debugShowCheckedModeBanner: false,
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
    // Controllers to capture input data
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController websiteController = TextEditingController();
    TextEditingController noteController = TextEditingController();
    TextEditingController nameController = TextEditingController();

    showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      builder: (context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text('Add New Credential'),
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.pop(context); // Close modal
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: CupertinoColors.destructiveRed),
            ),
          ),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () async {
              // Get user inputs from controllers
              String username = usernameController.text;
              String password = passwordController.text;
              String website = websiteController.text;
              String note = noteController.text;
              String name = nameController.text;

              // Save data to Firestore
              try {
                await FirebaseFirestore.instance.collection('credentials').add({
                  'username': username,
                  'password': password,
                  'website': website,
                  'note': note,
                  'created_at': FieldValue.serverTimestamp(),
                  'name': name,
                });

                Navigator.pop(context);

                //show alert dialog
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text('Success'),
                    content: const Text('Credential saved successfully!'),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              } catch (e) {
                // Handle Firestore errors
                print('Error saving to Firestore: $e');
              }
            },
            child: const Text('Save'),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          color: const Color(0xff181A24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                  height: 50), // Add spacing for the content below the header

              CupertinoTextField(
                controller: nameController,
                placeholder: 'Name',
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
              const SizedBox(height: 20),
              // Username field
              CupertinoTextField(
                controller: usernameController,
                placeholder: 'Username',
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
              const SizedBox(height: 20),

              // Password field
              CupertinoTextField(
                controller: passwordController,
                placeholder: 'Password',
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                obscureText: true,
              ),
              const SizedBox(height: 20),

              // Website URL field
              CupertinoTextField(
                controller: websiteController,
                placeholder: 'Website URL',
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
              const SizedBox(height: 20),

              // Note field with larger height
              CupertinoTextField(
                controller: noteController,
                placeholder: 'Note',
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                maxLines: 5,
                minLines: 5, // Set minimum lines to increase the height
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
