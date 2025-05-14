import 'package:flutter/material.dart';
import 'package:text_pledge/features/home/views/home_screen.dart';
import 'package:text_pledge/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF536DFE),
      body: Center(
        child: Image.asset('assets/images/logo.webp', height: 120),
      ),
    );
  }
}
