import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SozdatAccaunt extends StatefulWidget {
  const SozdatAccaunt({Key? key}) : super(key: key);

  @override
  State<SozdatAccaunt> createState() => _SozdatAccauntState();
}

class _SozdatAccauntState extends State<SozdatAccaunt> {
  final controller = FlipCardController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
   backgroundColor: const Color(0xFF30353b),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowIndicator();
          return false;
        },
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset(
                'assets/2.png',
                fit: BoxFit.fill,
              ),
              Padding(
                padding: EdgeInsets.only(top: 300.h),
                child: Image.asset(
                  'assets/bg.png',
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                bottom: 41,
                left: 92,
                right: 92,
                child: Column(children: [
                  Text(
                    "По всем вопросам пришите на",
                    style: GoogleFonts.montserrat(
                        fontSize: 11, color: Colors.grey),
                  ),
                  Text(
                    "Support@hansa-lab.ru",
                    style: GoogleFonts.montserrat(
                        fontSize: 11,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
