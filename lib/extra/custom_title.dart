import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CustomTitle extends StatelessWidget {
  const CustomTitle({Key? key, required this.imagePath, required this.title})
      : super(key: key);
  final String imagePath;
  final String title;

  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    return Container(
      decoration: const BoxDecoration(color: Color(0xffeaeaea), boxShadow: [
        BoxShadow(color: Color(0xffeaeaea), offset: Offset(0, -3))
      ]),
      child: Padding(
        padding: EdgeInsets.only(
          top: isTablet ? 7.h : 10.h,
          bottom: isTablet ? 8 : 10.h,
        ),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: isTablet ? 50.w : 70.w,
              height: isTablet ? 45.h : 42.h,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 213, 0, 50),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(64),
                      bottomRight: Radius.circular(64))),
              child: Image.asset(
                imagePath,
                height: isTablet ? 50 : 30.h,
                width: isTablet ? 70 : 30.w,
              ),
            ),
            SizedBox(
              width: 11.w,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "#",
                    style: GoogleFonts.montserrat(
                      fontSize: isTablet ? 11.sp : 14.sp,
                      color: const Color.fromARGB(255, 213, 0, 50),
                    ),
                  ),
                  TextSpan(
                    text: title,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet ? 15.sp : 20.sp,
                      color: const Color(0xff272624),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
