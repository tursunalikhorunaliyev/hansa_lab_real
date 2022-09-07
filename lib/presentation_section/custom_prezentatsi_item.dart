import 'package:flutter/material.dart';
import 'package:hansa_lab/extra/custom_clip_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomPrezentatsiItem extends StatelessWidget {
  const CustomPrezentatsiItem({
    Key? key,
    required this.imageUrl,
    required this.backgroundColor,
    required this.buttonTextColor,
    required this.buttonColor,
    required this.titleColor,
    required this.buttonText,
    required this.title,
  }) : super(key: key);
  final String imageUrl;
  final Color backgroundColor;
  final Color buttonTextColor;
  final Color buttonColor;
  final Color titleColor;
  final String buttonText;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:  EdgeInsets.only(left: 25.w, right: 25.w, top: 6.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.asset(
              imageUrl,
              width: 325.w,
              height: 157.h,
              fit: BoxFit.cover,
            ),
          ),
        ),
        CustomClipItem(
          backgroundColor: backgroundColor,
          buttonTextColor: buttonTextColor,
          buttonColor: buttonColor,
          titleColor: titleColor,
          buttonText: buttonText,
          title: title,
          onTap: (){},
        ),
      ],
    );
  }
}
