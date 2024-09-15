import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore import
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'vault_page.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation<int>? _animation; // Nullable animation
  bool _isAnimationInitialized = false; // Track animation initialization
  double _passwordStrength = 0.0; // Password strength

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Fetch the document count asynchronously
    FirebaseFirestore.instance.collection('credentials').get().then((snapshot) {
      int documentCount = snapshot.size; // This is the count of documents

      List passwords = snapshot.docs.map((doc) {
        return doc.data()['password'];
      }).toList();
      setState(() {
        // Initialize the animation with the fetched document count
        _animation = IntTween(
          begin: 0,
          end: documentCount,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOutCubic,
          ),
        );

        // Calculate the password strength
        _passwordStrength = _calculatePasswordStrength(passwords.join());
        print("Password strength: $_passwordStrength");

        _isAnimationInitialized = true; // Mark animation as initialized

        // Forward the animation
        _controller.forward();
      });
    });
  }

  double _calculatePasswordStrength(String password) {
    // Use a simple password strength evaluation or use a package to calculate the strength
    double strength = 0.0;

    // Example strength calculation (you can use a more sophisticated method/library)
    if (password.length >= 8) strength += 0.25;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.25;
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.25;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength += 0.25;

    return strength; // Returns strength as a fraction (0 to 1)
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xff10111B),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("My Vault",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        )),
                    Image.asset(
                      "res/usericon.png",
                      width: 42,
                      height: 42,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CupertinoTextField(
                          placeholder: "Search",
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
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff181A24),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Text("Vault Rating"),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              if (_isAnimationInitialized)
                                AnimatedBuilder(
                                  animation: _animation!,
                                  builder: (context, child) {
                                    return Text(
                                      '${_animation!.value}',
                                      style: const TextStyle(fontSize: 48),
                                    );
                                  },
                                )
                              else
                                const Text(
                                  '...', // Show loading text until animation is initialized
                                  style: TextStyle(fontSize: 48),
                                ),
                              const SizedBox(width: 10),
                              const Text("Accounts"),
                              const Spacer(),
                              AnimatedRadialGauge(
                                builder: (context, child, value) =>
                                    RadialGaugeLabel(
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  value: value,
                                ),
                                duration: const Duration(seconds: 3),
                                curve: Curves.elasticOut,
                                radius: 60,
                                value: _passwordStrength,
                                axis: const GaugeAxis(
                                    min: 0,
                                    max: 100,
                                    degrees: 270,
                                    style: GaugeAxisStyle(
                                      thickness: 15,
                                      segmentSpacing: 5,
                                      cornerRadius: Radius.circular(10),
                                      background: Colors.transparent,
                                    ),
                                    pointer: GaugePointer.triangle(
                                      position: GaugePointerPosition.center(
                                          offset: Offset(0, -37)),
                                      width: 15,
                                      height: 15,
                                      color: Color(0xff39393B),
                                      border: GaugePointerBorder(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    progressBar: null,
                                    segments: [
                                      GaugeSegment(
                                        from: 0,
                                        to: 33.3,
                                        color: Colors.red,
                                        cornerRadius: Radius.circular(10),
                                      ),
                                      GaugeSegment(
                                        from: 33.3,
                                        to: 66.6,
                                        cornerRadius: Radius.circular(10),
                                        color: Colors.yellow,
                                      ),
                                      GaugeSegment(
                                        from: 66.6,
                                        to: 100,
                                        cornerRadius: Radius.circular(10),
                                        color: Colors.green,
                                      ),
                                    ]),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    )),
              ),
              Container(
                height: 1,
                color: const Color(0xff39393B),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    const Text(
                      "Recent Credentials",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    //on tap
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(builder: (context) => VaultTab()),
                        );
                      },
                      child: const Text(
                        "View all",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildRecentCredentialsList(),
              const SizedBox(height: 50), // Add some space at the bottom
            ],
          ),
        ),
      ),
    );
  }

  // This function builds the recent credentials list
  Widget _buildRecentCredentialsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('credentials')
          .orderBy('created_at', descending: true)
          .limit(7)
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
              "No recent credentials found.",
              style: TextStyle(color: Colors.white),
            ),
          );
        }
        final credentials = snapshot.data!.docs;

        return Column(
          children: credentials.map((doc) {
            Map<String, dynamic> item = doc.data() as Map<String, dynamic>;
            int index = credentials.indexOf(doc);
            return Container(
              decoration: BoxDecoration(
                color: index % 2 == 0
                    ? const Color(0xff1F212E)
                    : const Color(0xff181A24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        Colors.primaries[index % Colors.primaries.length],
                    radius: 20,
                    child: Text(
                      item["name"]?[0] ?? '', // First letter of the name
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
                          item["name"] ?? 'No name',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item["website"] ?? 'No website',
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
        );
      },
    );
  }
}
