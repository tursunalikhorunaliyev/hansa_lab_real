import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/extra/custom_paint_clipper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabletItemTreningi extends StatelessWidget {
  const TabletItemTreningi(
      {Key? key,
      required this.backgroundColor,
      required this.buttonTextColor,
      required this.buttonColor,
      required this.titleColor,
      required this.buttonText,
      required this.title,
      required this.onTap})
      : super(
          key: key,
        );

  final Color backgroundColor;
  final Color buttonTextColor;
  final Color buttonColor;
  final Color titleColor;
  final String buttonText;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 200.w,
          child: Stack(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.r),
                    child: ClipPath(
                      clipper: CustomPaintClipper(),
                      child: Container(
                        width: 150.w,
                        height: 71.h,
                        color: backgroundColor,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 7.w),
                      child: Container(
                        width: 100.w,
                        height: 65.h,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          title,
                          overflow: TextOverflow.fade,
                          style: GoogleFonts.montserrat(
                            color: titleColor,
                            fontSize: 7.sp,
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
                                alignment: Alignment.center,
                                width: 50.w,
                                height: 20.h,
                                color: buttonColor,
                                child: Center(
                                  child: Text(
                                    buttonText,
                                    style: GoogleFonts.montserrat(
                                      color: buttonTextColor,
                                      fontSize: 7.sp,
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
