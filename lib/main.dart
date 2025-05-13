import 'package:flutter/material.dart';

void main() => runApp(TextPledgeApp());

class TextPledgeApp extends StatelessWidget {
  const TextPledgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TextPledgeHome(),
    );
  }
}

class TextPledgeHome extends StatelessWidget {
  final Color primaryColor = Color(0xFF536DFE);
  final Color greenColor = Color(0xFF388E3C);

  TextPledgeHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header
            Container(
              color: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 20),
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

            // Buttons Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: buildButton('Student Signup')),
                      const SizedBox(width: 12),
                      Expanded(child: buildButton('Text Pledges')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: buildButton('Parent Permission')),
                      const SizedBox(width: 12),
                      Expanded(child: buildButton('Programs')),
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
