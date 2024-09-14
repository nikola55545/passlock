import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class VaultTab extends StatelessWidget {
  final List<Map<String, String>> credentials = [
    {"title": "Google Account", "subtitle": "email@gmail.com"},
    {"title": "Facebook Account", "subtitle": "email@facebook.com"},
    {"title": "Twitter Account", "subtitle": "email@twitter.com"},
    {"title": "GitHub Account", "subtitle": "email@github.com"},
    {"title": "LinkedIn Account", "subtitle": "email@linkedin.com"},
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xff10111B),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Vault",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      )),
                  GestureDetector(
                    onTap: () {
                      _openModalBottomSheet(context);
                    },
                    child: const FaIcon(
                      FontAwesomeIcons.plus,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CupertinoTextField(
                        placeholder: "Search Credentials",
                        decoration: BoxDecoration(
                          color: const Color(0xff181A24),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefix: const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: FaIcon(
                            FontAwesomeIcons.search,
                            size: 16,
                            color: Color(0xff39393B),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: const Color(0xff39393B),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    children: credentials.map((item) {
                      int index = credentials.indexOf(item);
                      return Container(
                        decoration: BoxDecoration(
                          color: index % 2 == 0
                              ? const Color(0xff1F212E)
                              : const Color(0xff181A24),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: //randomColor(),
                                  Colors.primaries[
                                      index % Colors.primaries.length],
                              radius: 20,
                              child: Text(
                                item["title"]![0], // First letter of the title
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item["title"]!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    item["subtitle"]!,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const FaIcon(
                              FontAwesomeIcons.chevronRight,
                              color: Colors.grey,
                              size: 16,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openModalBottomSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => Container(
        color: const Color(0xff181A24),
        padding: const EdgeInsets.all(16),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Credential',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'This is where you can add a new credential.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            // Add more widgets here for your modal content
          ],
        ),
      ),
    );
  }
}
