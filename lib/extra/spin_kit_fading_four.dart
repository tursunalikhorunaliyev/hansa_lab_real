import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpinKitFadingFourWidget extends StatelessWidget {
  const SpinKitFadingFourWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 78.66666.h),
        child: SpinKitFadingFour(
          shape: BoxShape.circle,
          size: 80.sp,
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90.r),
                color: index.isEven ? Colors.black : Colors.black,
              ),
            );
          },
        ),
      ),
    );
  }
}
