import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:text_pledge/pdf_viewer_screen.dart';

class ProgramsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Top Bar
            Container(
              padding: EdgeInsets.only(
                top: 70,
                left: 16,
                right: 16,
                bottom: 12,
              ),
              color: Color(0xFF4A4ED4), // Blue
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Image.asset('assets/images/logo.webp', height: 40),
                        SizedBox(height: 4),
                        Text(
                          "PROGRAMS",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Intro Text
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text.rich(
                TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  children: [
                    TextSpan(
                      text:
                          'All programs are age specific and designed for certain grade levels ',
                    ),
                    TextSpan(
                      text: 'Text Pledge',
                      style: TextStyle(
                        color: Color(0xFF4A4ED4),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(text: ' has chosen to introduce '),
                    TextSpan(
                      text: '"sensitive"',
                      style: TextStyle(
                        color: Color(0xFF4A4ED4),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text:
                          ' topics at the 5th and 6th grades student may participate in the programs in younger level, however age 12 is the recommended grade level to start pledges.',
                    ),
                  ],
                ),
              ),
            ),

            // Tabs
            TabBar(
              labelColor: Color(0xFF4A4ED4),
              unselectedLabelColor: Colors.grey,
              labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              tabs: [
                Tab(text: "Elementary"),
                Tab(text: "Middle & High School"),
              ],
            ),

            // Content
            Expanded(
              child: TabBarView(
                children: [ElementaryTab(), Center(child: Text("Coming Soon"))],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ElementaryTab extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
    {'title': 'STOP DISTRACTED DRIVING', 'activityLink': 'ActivityBook.pdf'},
    {'title': 'END DISCRIMINATION'},
    {'title': 'END ACTS OF VIOLENCE'},
    {'title': 'RAISE MENTAL HEALTH'},
    {'title': 'PROTECT ANIMAL RIGHTS'},
    {'title': 'PROTECT THE ENVIRONMENT'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: ExpansionTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tilePadding: EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                '${index + 1}. ${item['title']}',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              children:
                  item.containsKey('activityLink')
                      ? [
                        Padding(
                          padding: const EdgeInsets.only(left: 16, bottom: 12),
                          child: Row(
                            children: [
                              Text(
                                'Activity Book: ',
                                style: GoogleFonts.poppins(),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => PdfViewScreen(
                                            isFromUrl: true,
                                            path:
                                                'https://docs.google.com/file/d/1dsGGyuqvFAX87zpLtR7u38zxZCib2ArU/edit?singconverswall=malptolida',
                                          ),
                                    ),
                                  );
                                },
                                child: Text(
                                  item['activityLink'],
                                  style: GoogleFonts.poppins(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]
                      : [],
            ),
          ),
        );
      },
    );
  }
}
