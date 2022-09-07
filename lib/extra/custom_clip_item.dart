import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/extra/custom_paint_clipper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomClipItem extends StatelessWidget {
  const CustomClipItem({
    Key? key,
    required this.backgroundColor,
    required this.buttonTextColor,
    required this.buttonColor,
    required this.titleColor,
    required this.buttonText,
    required this.title,
    required this.onTap,
  }) : super(key: key);
  final Color backgroundColor;
  final Color buttonTextColor;
  final Color buttonColor;
  final Color titleColor;
  final String buttonText;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 11.h, bottom: 5.h),
      child: SizedBox(
        width: 325.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.r),
                  child: ClipPath(
                    clipper: CustomPaintClipper(),
                    child: Container(
                      constraints: BoxConstraints(
                          minHeight: 71,
                          minWidth: 300.w,
                          maxHeight: 101.h,
                          maxWidth: 300.w),
                      color: backgroundColor,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 18.w, top: 7, bottom: 7),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: 200,
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      softWrap: true,
                      style: GoogleFonts.montserrat(
                        color: titleColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    PhysicalModel(
                      shadowColor: Colors.grey.withOpacity(.5),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(64.r),
                      elevation: 5.sp,
                      child: GestureDetector(
                        onTap: onTap,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(64.r),
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            constraints: BoxConstraints(
                              minWidth: 90.w,
                            ),
                            color: buttonColor,
                            child: Center(
                              child: Text(
                                buttonText,
                                style: GoogleFonts.montserrat(
                                  color: buttonTextColor,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
