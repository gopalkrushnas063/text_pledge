import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class TextPledgesScreen extends StatefulWidget {
  @override
  _TextPledgesScreenState createState() => _TextPledgesScreenState();
}

class _TextPledgesScreenState extends State<TextPledgesScreen> {
  final Color primaryColor = const Color(0xFF536DFE);
  final Color greenColor = const Color(0xFF388E3C);
  int expandedIndex = 0;

  final List<Map<String, String>> pledges = [
    {
      "title": "Distracted Driving",
      "description":
          "I pledge to avoid having distractions in the motor vehicle when I am in it, and to know the warning signs of distracted driving.",
    },
    {"title": "Discrimination", "description": ""},
    {"title": "Acts of Violence", "description": ""},
    {"title": "Prevent Bullying and Cyberbullying", "description": ""},
    {"title": "Raise Mental Health", "description": ""},
    {"title": "Stop Domestic Violence and Assault", "description": ""},
    {"title": "End Driving Under the Influence", "description": ""},
    {"title": "Stop Human Trafficking", "description": ""},
    {"title": "Protect Animal Rights", "description": ""},
    {"title": "Protecting the Environment", "description": ""},
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: primaryColor,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Color(0xFFEDEDED),
        body: Column(
          children: [
            // Header
            // Header with Back Button
            Container(
              width: double.infinity,
              color: Color(0xFF3B4CCA),
              padding: const EdgeInsets.only(
                top: 70,
                bottom: 20,
                left: 16,
                right: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back_ios, color: Colors.white),
                      ),
                      Spacer(), // Pushes logo and text to center
                      Column(
                        children: [
                          Image.asset('assets/images/logo.webp', height: 60),
                          SizedBox(height: 10),
                          Text(
                            "TEXT PLEDGES",
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      Spacer(), // Keeps the layout balanced
                      SizedBox(width: 24), // Placeholder for symmetry
                    ],
                  ),
                ],
              ),
            ),

            // Pledges List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: pledges.length,
                itemBuilder: (context, index) {
                  final isExpanded = index == expandedIndex;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 6,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            expandedIndex = index == expandedIndex ? -1 : index;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Blue square number box
                                  Container(
                                    width: 30,
                                    height: 30,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF3B4CCA),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      "${index + 1}",
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),

                                  // Title and icon
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          pledges[index]["title"]!,
                                          style: GoogleFonts.inter(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        if (expandedIndex == index &&
                                            pledges[index]["description"]!
                                                .isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 10.0,
                                              right: 8,
                                            ),
                                            child: Text(
                                              pledges[index]["description"]!,
                                              style: GoogleFonts.inter(
                                                color: Colors.black87,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),

                                  // Expand/Collapse icon
                                  Icon(
                                    expandedIndex == index
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
}
