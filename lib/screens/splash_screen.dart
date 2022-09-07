import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/screens/hansa_zagruzka.dart';
import 'package:hansa_lab/screens/welcome_screen.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final box = Hive.box("savedUser");

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  checkUser() async {
    if (box.get("isSaved") != null && box.get("isSaved")! as bool) {
      Map<String, dynamic> map =
          await login(box.get("username"), box.get("password"));
      await Future.delayed(const Duration(seconds: 1));
      goToHome(await map["data"]["token"]);
    } else {
      await Future.delayed(const Duration(seconds: 2));
      goToHansaZagruzka();
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    String gate = "https://hansa-lab.ru/api/auth/login";
    http.Response response = await http.post(Uri.parse(gate),
        body: {"username": username, "password": password});
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logoHansa.png",
              height: 50.h,
              width: 280.w,
            ),
            Padding(
              padding: EdgeInsets.only(top: isTablet ? 20.h : 24.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "#Увидимся",
                    style: GoogleFonts.montserrat(
                        color: const Color.fromARGB(255, 59, 59, 59),
                        fontSize: isTablet ? 16.sp : 23.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "на",
                    style: GoogleFonts.montserrat(
                        color: const Color.fromARGB(255, 59, 59, 59),
                        fontSize: isTablet ? 16.sp : 23.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "кухне",
                    style: GoogleFonts.montserrat(
                        color: const Color.fromARGB(255, 59, 59, 59),
                        fontSize: isTablet ? 16.sp : 23.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  goToHome(token) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Provider(
                create: (context) => token.toString(),
                child: const WelcomeScreen())));
  }

  goToHansaZagruzka() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const HansaZagruzka()));
  }
}
