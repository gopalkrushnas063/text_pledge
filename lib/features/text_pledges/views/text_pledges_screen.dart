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
    {
      "title": "Discrimination",
      "description":
          "I pledge to know and learn about what discrimination is so that everyone feels safe and welcome in our communities.",
    },
    {
      "title": "Acts of Violence",
      "description":
          "I pledge to know and learn the signs that may lead to acts of violence with guns and weapons. I pledge to help Text Pledge reduce the number of injuries, homicides and suicides caused these objects.",
    },
    {
      "title": "Prevent Bullying and Cyberbullying",
      "description":
          "I pledge to report Bullying or Cyberbullying i may witness, to a trusted adult parent or teacher.",
    },
    {
      "title": "Raise Mental Health",
      "description":
          "I pledge to raise mental health awareness in my community or school and watch for warning signs or situations where someone may need assistance with mental illness.",
    },
    {
      "title": "Stop Domestic Violence and Assault",
      "description":
          "I pledge to watch for the signs of Domestic abuse or assault and to learn the signs and guide others for assistance that may be in need of it.",
    },
    {
      "title": "End Driving Under the Influence",
      "description":
          "I pledge to do my part in ending driving under the influence.Medications, Alcohol and other substances should not be used when driving a motor vehicle, I pledge to watch for the signs.",
    },
    {
      "title": "Stop Human Trafficking",
      "description":
          "I pledge to learn the signs of human trafficking and direct those that may need assistance to the right support.",
    },
    {
      "title": "Protect Animal Rights",
      "description":
          "I pledge to protect animals from abuse or cruelty and to do my part in protecting innocent animals.",
    },
    {
      "title": "Protecting the Environment",
      "description":
          "I pledge to do my part in protecting the environment and learn what I can do to make our world a better place.",
    },
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
