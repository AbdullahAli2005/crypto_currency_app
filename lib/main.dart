// 11:40
import 'package:cypto_currency_app/pages/home_page.dart';
import 'package:cypto_currency_app/pages/login_page.dart';
import 'package:cypto_currency_app/pages/splash_screen.dart';
import 'package:cypto_currency_app/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await registerService();
  await registerControllers();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
        textTheme: GoogleFonts.quicksandTextTheme(),
      ),
      routes: {
        "/splash": (BuildContext context) => const SplashScreen(),
        "/login": (context) => const LoginSignupScreen(),
        "/home": (context) => const HomePage()
      },
      initialRoute: "/splash",
    );
  }
}
