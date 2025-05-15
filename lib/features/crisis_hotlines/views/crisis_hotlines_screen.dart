import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CrisisHotlinesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CrisisHotlinesScreen();
  }
}


class CrisisHotlinesScreen extends StatelessWidget {
  final List<Map<String, String>> hotlines = [
    {
      'title': 'Imminent Emergency, Health Crisis, Car Accident',
      'number': '911',
      'url': 'tel:911',
      'icon': 'assets/icons/ambulance.png',
    },
    {
      'title': 'Mental Health Crisis Helpline',
      'number': '1-800-985-5990 OR 988',
      'url': 'tel:18009855990',
      'icon': 'assets/icons/mental-health.png',
    },
    {
      'title':
          'Red Cross Emergency Communications Specialist (Military family support)',
      'number': '1-877-272-7337',
      'url': 'tel:18772727337',
      'icon': 'assets/icons/red-cross.png',
    },
    {
      'title': 'Suicide Hotline and Confidential Counselors (English)',
      'number': '988 OR 1-800-784-2433',
      'url': 'tel:988',
      'icon': 'assets/icons/suicide_hotline.png',
    },
    {
      'title': 'Suicide Hotline (Spanish)',
      'number': '1-888-624-9454',
      'url': 'tel:18886249454',
      'icon': 'assets/icons/suicide_hotline.png',
    },
    {
      'title': 'Drug and Alcohol Abuse Hotline',
      'number': '1-800-622-6384',
      'url': 'tel:18006226384',
      'icon': 'assets/icons/drug_abuse.png',
    },
    {
      'title': 'National Teen Dating Abuse Hotline',
      'number': '1-866-331-9474',
      'url': 'tel:18663319474',
      'icon': 'assets/icons/dating_abuse.png',
    },
    {
      'title': 'National Teen Pregnancy Hotline',
      'number': '1-800-238-4269',
      'url': 'tel:18002384269',
      'icon': 'assets/icons/teen_pregnancy.png',
    },
    {
      'title': 'National Domestic Abuse Hotline',
      'number': '1-800-799-7233',
      'url': 'tel:18007997233',
      'icon': 'assets/icons/domestic_abuse.png',
    },
    {
      'title': 'Human Trafficking & Victim Support Hotline',
      'number': '1-888-373-7888',
      'url': 'tel:18883737888',
      'icon': 'assets/icons/human_trafficking.png',
    },
    {
      'title': 'National Child Abuse Hotline',
      'number': '1-800-422-4453',
      'url': 'tel:18004224453',
      'icon': 'assets/icons/child_abuse.png',
    },
    {
      'title': 'Missing Child Hotline',
      'number': '1-800-843-5678',
      'url': 'tel:18008435678',
      'icon': 'assets/icons/missing_child.png',
    },
    {
      'title': 'Animal Abuse or Neglect',
      'number': 'Contact Local Animal Control',
      'url': '',
      'icon': 'assets/icons/animal_abuse.png',
    },
    {
      'title': 'United Way',
      'number': 'Call 211',
      'url': 'tel:211',
      'icon': 'assets/icons/united_way.png',
    },
    {
      'title': 'Poison Control & Drug Overdose',
      'number': '1-800-222-1222',
      'url': 'tel:18002221222',
      'icon': 'assets/icons/poison_control.png',
    },
  ];

  void _launchURL(String url) async {
    if (url.isNotEmpty && await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Color(
          0xFF536DFE,
        ), // Adjust the color to match your theme
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.webp', // Replace with your actual logo path
              height: 40, // Adjust size to fit nicely in the app bar
            ),
            SizedBox(width: 10), // Space between logo and text
            Text(
              'Crisis Hotlines (USA)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text for contrast
              ),
            ),
          ],
        ),
        centerTitle: true, // Centers the app bar content
      ),

      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: hotlines.length,
        itemBuilder: (context, index) {
          final hotline = hotlines[index];
          return Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 6.0,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(),
                      ),
                      child: Image.asset(
                        hotline['icon']!,
                        fit: BoxFit.contain,
                        width: 32.0,
                        height: 32.0,
                        errorBuilder: (
                          BuildContext context,
                          Object error,
                          StackTrace? stackTrace,
                        ) {
                          // Return a fallback widget when the image fails to load
                          return Icon(
                            Icons.error_outline,
                            size: 32.0,
                            color: Colors.red,
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hotline['title']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          GestureDetector(
                            onTap:
                                hotline['url']!.isNotEmpty
                                    ? () => _launchURL(hotline['url']!)
                                    : null,
                            child: Text(
                              hotline['number']!,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14.0,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
