import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({Key? key}) : super(key: key);
  final Color iconColor = const Color(0xffa5a5ae);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {},
            child: Icon(
              CupertinoIcons.chevron_left_circle,
              size: 25.sp,
              color: iconColor,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Icon(
              CupertinoIcons.search,
              size: 25.sp,
              color: iconColor,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Icon(
              CupertinoIcons.heart,
              size: 25.sp,
              color: iconColor,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Icon(
              CupertinoIcons.person,
              size: 25.sp,
              color: iconColor,
            ),
          ),
          GestureDetector(
            child: Icon(
              CupertinoIcons.home,
              size: 25.sp,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
