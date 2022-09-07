import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class IpadContainer extends StatelessWidget {
  final String title;
  final Color titleColor;
  final String buttonText;
  final VoidCallback onTap;
  final Color buttonTextColor;
  final Color buttonColor;
  const IpadContainer(
      {Key? key,
      required this.buttonTextColor,
      required this.buttonColor,
      required this.title,
      required this.titleColor,
      required this.buttonText,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Container(
            alignment: Alignment.topCenter,
            height: 120.h,
            width: 325.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: const Color.fromARGB(255, 213, 0, 50),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: SizedBox(
                width: 500,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                  softWrap: true,
                  style: GoogleFonts.montserrat(
                    color: titleColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 98.h, left: 54.w),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              alignment: Alignment.center,
              height: 55.h,
              width: 220.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.r),
                color: buttonColor,
              ),
              child: Text(
                buttonText,
                style: GoogleFonts.montserrat(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: buttonTextColor,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
