import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/view/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final Widget = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/news.png',
              fit: BoxFit.cover,
              height: height * .5,
              width: Widget * .9,
            ),
            SizedBox(height: height * 0.04),
            Text(
              'TOP HEADLINES',
              style: GoogleFonts.anton(
                letterSpacing: .6,
                color: Colors.deepOrangeAccent.shade700,
              ),
            ),
            SizedBox(height: height * 0.04),
            SpinKitChasingDots(color: Colors.blue, size: 40),
          ],
        ),
      ),
    );
  }
}
