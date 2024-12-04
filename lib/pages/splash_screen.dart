import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      // Navigate to the login screen after 3 seconds
      Get.offNamed("/login");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
        height: MediaQuery.of(context).size.height*0.42,
        // width: MediaQuery.of(context).size.width,
        child: Image.asset(
          'assets/CryptoVault.png', // Your splash image path
          fit: BoxFit.cover,
        ),
      ),
      ),
    );
  }
}
