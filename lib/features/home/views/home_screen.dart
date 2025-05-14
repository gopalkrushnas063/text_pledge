import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:text_pledge/features/Programs/views/programs_screen.dart';
import 'package:text_pledge/features/parent_permissions/views/parent_permission_screen.dart';
import 'package:text_pledge/features/student_registration/views/student_registartion_page.dart';
import 'package:text_pledge/features/text_pledges/views/text_pledges_screen.dart';

class HomeScreen extends StatelessWidget {
  final Color primaryColor = const Color(0xFF536DFE);
  final Color greenColor = const Color(0xFF388E3C);

  const HomeScreen({super.key});

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
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Top Header
            Container(
              color: primaryColor,
              padding: const EdgeInsets.only(
                top: 70, // Extra padding instead of SafeArea
                bottom: 20,
                left: 16,
                right: 16,
              ),
              width: double.infinity,
              child: Column(
                children: [
                  Image.asset('assets/images/logo.webp', height: 70),
                  const SizedBox(height: 5),
                  const Text(
                    '1 Pledge - Many Causes\nAccess Help lines\nTextpledge.us',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ),
            ),

            // Rest of your existing body content...
            // Buttons Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentRegistrationPage(),
                              ),
                            );
                          },
                          child: buildButton('Student Signup'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            //TextPledgesScreen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TextPledgesScreen(),
                              ),
                            );
                          },
                          child: buildButton('Text Pledges'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            //ParentPermissionPage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ParentPermissionPage(),
                              ),
                            );
                          },
                          child: buildButton('Parent Permission'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            //ProgramsScreen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProgramsScreen(),
                              ),
                            );
                          },
                          child: buildButton('Programs'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: greenColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Crisis Hotlines United States',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Image(
                          image: AssetImage('assets/images/us_flag.png'),
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Bottom Logo & Text
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.asset('assets/images/logo.webp'),
                  const SizedBox(height: 8),
                  const Text(
                    '1 Pledge -Many Causes\nAccess Help lines\nTextpledge.us',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String text) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
