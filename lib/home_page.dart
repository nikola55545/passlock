import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class HomeTab extends StatelessWidget {
  final List<Map<String, String>> recentActivities = [
    {"title": "Login from new device", "subtitle": "2 hours ago"},
    {"title": "Password changed", "subtitle": "1 day ago"},
    {"title": "Vault backed up", "subtitle": "3 days ago"},
    {"title": "Security question added", "subtitle": "1 week ago"},
    {"title": "New account added", "subtitle": "2 weeks ago"},
  ];

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
                              const Text("131", style: TextStyle(fontSize: 48)),
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
                                value: 78,
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
                          Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.exclamationTriangle,
                                color: Colors.red,
                                size: 14,
                              ),
                              const SizedBox(width: 10),
                              const Text("Security Risks Detected: 8",
                                  style: TextStyle(fontSize: 14)),
                              const Spacer(),
                              CupertinoButton(
                                child: const Text("View",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  print("View");
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    )),
              ),
              Container(
                height: 1,
                color: const Color(0xff39393B),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xff181A24),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 20),
                  child: Row(
                    children: [
                      const Text("Recent Activity",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                      const Spacer(),
                      CupertinoButton(
                        child: const Text("View All",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                        onPressed: () {
                          print("View All");
                        },
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  children: recentActivities.map((item) {
                    int index = recentActivities.indexOf(item);
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
              const SizedBox(height: 50), // Add some space at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
