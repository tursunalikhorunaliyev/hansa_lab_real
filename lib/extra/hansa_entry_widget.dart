import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/extra/voyti_ili_sozdat_accaunt.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class HansaEntry extends StatefulWidget {
  const HansaEntry({Key? key}) : super(key: key);

  @override
  State<HansaEntry> createState() => _HansaEntryState();
}

class _HansaEntryState extends State<HansaEntry> {
  double pos = 420;

  @override
  void initState() {
    timerWidget();
    super.initState();
  }

  timerWidget() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (timer.tick == 1) {
        setState(() {
          pos = 200;
        });
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: isTablet ? 445.h : 438.6666666666667.h,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.only(
                        top: 80.h,
                        left: isTablet ? 70.w : 40.w,
                        right: isTablet ? 70.w : 40.w),
                    child: Image.asset("assets/logoHansa.png")),
                Padding(
                  padding: EdgeInsets.only(
                      top: isTablet ? 20.h : 27.66666666666667.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "#Увидимся",
                        style: GoogleFonts.montserrat(
                            color: const Color.fromARGB(255, 59, 59, 59),
                            fontSize: isTablet ? 16.sp : 25.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "на",
                        style: GoogleFonts.montserrat(
                            color: const Color.fromARGB(255, 59, 59, 59),
                            fontSize: isTablet ? 16.sp : 25.sp,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "кухне",
                        style: GoogleFonts.montserrat(
                            color: const Color.fromARGB(255, 59, 59, 59),
                            fontSize: isTablet ? 16.sp : 25.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          pos == 420
              ? Positioned(
                  top: 240.h,
                  left: 27.w,
                  right: 27.w,
                  child:
                      Lottie.asset("assets/pre.json", width: 120, height: 120),
                )
              : const SizedBox(),
          Positioned(
            top: -58.h,
            child: isTablet
                ? Image.asset("assets/tabletTumLogo.png")
                : Image.asset(
                    "assets/Logo.png",
                    height: 133,
                    width: 133,
                  ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            top: pos.h,
            bottom: isTablet ? 25.h : 20.h,
            child: const VoytiIliSozdatAccaunt(),
          ),
        ],
      ),
    );
  }
}
