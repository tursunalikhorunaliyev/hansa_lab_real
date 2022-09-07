import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlackPaintedCard extends StatelessWidget {
  const BlackPaintedCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => Positioned(
        child: Image.asset(
          'assets/bg.png',
        ),
      ),
    );
  }
}
