import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlackCustomTitle extends StatelessWidget {
  const BlackCustomTitle(
      {Key? key, required this.imagePath, required this.title})
      : super(key: key);
  final String imagePath;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.h, bottom: 15.h),
      child: Row(
        children: [
          Container(
            width: 70.w,
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 213, 0, 50),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(64.r),
                bottomRight: Radius.circular(64.r),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 5.5.h, bottom: 5.5.h, right: 15.w),
              child: Image.asset(
                imagePath,
                height: 31.h,
                width: 31.w,
              ),
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
                    fontSize: 14.sp,
                    color: const Color.fromARGB(255, 213, 0, 50),
                  ),
                ),
                TextSpan(
                  text: title,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                    color: const Color(0xffffffff),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
