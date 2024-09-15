import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'single_item.dart';

class VaultTab extends StatefulWidget {
  @override
  _VaultTabState createState() => _VaultTabState();
}

class _VaultTabState extends State<VaultTab> {
  TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();

    // Listen for changes in the search field
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                  const Text("My Credentials",
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
                      controller: _searchController,
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
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: const Color(0xff39393B),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('credentials')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No credentials found.",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  final credentials = snapshot.data!.docs;

                  // Filter the credentials based on the search input
                  final filteredCredentials = credentials.where((doc) {
                    Map<String, dynamic> item =
                        doc.data() as Map<String, dynamic>;
                    final name = item["name"]?.toLowerCase() ?? '';
                    final website = item["website"]?.toLowerCase() ?? '';
                    final searchLower = _searchText.toLowerCase();
                    return name.contains(searchLower) ||
                        website.contains(searchLower);
                  }).toList();

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Column(
                        children: filteredCredentials.map((doc) {
                          Map<String, dynamic> item =
                              doc.data() as Map<String, dynamic>;
                          int index = filteredCredentials.indexOf(doc);

                          return GestureDetector(
                            onTap: () {
                              // Navigate to the CredentialDetailsPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CredentialDetailsPage(
                                    username: item['username'] ?? 'No username',
                                    password: item['password'] ?? 'No password',
                                    website: item['website'] ?? 'No website',
                                    note: item['note'] ?? 'No note provided',
                                  ),
                                ),
                              );
                            },
                            child: Container(
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
                                    backgroundColor: Colors.primaries[
                                        index % Colors.primaries.length],
                                    radius: 20,
                                    child: Text(
                                      item["name"]?[0] ??
                                          '', // Ensure it's not null
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 20,
                                          textBaseline:
                                              TextBaseline.alphabetic),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item["name"] ??
                                              'No username', // Fallback value if null
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          item["website"] ??
                                              'No website', // Fallback value if null
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
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
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
          ],
        ),
      ),
    );
  }
}
