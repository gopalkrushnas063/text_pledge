import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:text_pledge/features/Programs/widgets/pdf_viewer_screen.dart';

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
              color: Color(0xFF536DFE), // Blue
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
                        color: Color(0xFF536DFE),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(text: ' has chosen to introduce '),
                    TextSpan(
                      text: '"sensitive"',
                      style: TextStyle(
                        color: Color(0xFF536DFE),
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
              labelColor: Color(0xFF536DFE),
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
    {
      'title': 'STOP DISTRACTED DRIVING',
      'activityLink': 'assets/pdf/K1/Copy-of-Activity_DD_K1.pdf',
    },
    {
      'title': 'END DISCRIMINATION',
      'activityLink': 'assets/pdf/K1/Copy-of-Activity_Discrimination_K1.pdf',
    },
    {
      'title': 'END ACTS OF VIOLENCE',
      'activityLink': 'assets/pdf/K1/Copy-of-Activity_Discrimination_G2-G4.pdf',
    },
    {
      'title': 'RAISE MENTAL HEALTH',
      'activityLink': 'assets/pdf/K1/Copy-of-Activity_Mental_K1.pdf',
    },
    {
      'title': 'PROTECT ANIMAL RIGHTS',
      'activityLink': 'assets/pdf/K1/Copy-of-Activity_Animals_K1',
    },
    {
      'title': 'PROTECT THE ENVIRONMENT',
      'activityLink': 'assets/pdf/K1/Copy-of-Activity_Environment_K1.pdf',
    },
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
                                          (context) => FullScreenPdfViewer(
                                            pdfPath: item['activityLink'],
                                            isAsset: true,
                                          ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'View PDF',
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
