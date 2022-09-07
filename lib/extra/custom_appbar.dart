import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 81.h,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Icon(
                Icons.menu,
                color: const Color(0xff444444),
                size: 25.sp,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 13.h),
                child: Image.asset(
                  'assets/logoHansa.png',
                  height: 25.h,
                  width: 214.w,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.h),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "#Увидимся",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff272624),
                        ),
                      ),
                      TextSpan(
                        text: "на",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.normal,
                          color: const Color(0xff272624),
                        ),
                      ),
                      TextSpan(
                        text: "кухне",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff272624),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Icon(
                Icons.search,
                size: 25.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
