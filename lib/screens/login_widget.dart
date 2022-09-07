import 'package:flutter/material.dart';
import 'package:hansa_lab/extra/login_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class LoginWidget extends StatelessWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowIndicator();
            return false;
          },
          child: SingleChildScrollView(
            reverse: false,
            primary: false,
            child: Center(
              child: Stack(
                children: [
                  Padding(
                    padding:  EdgeInsets.only(top: 300.h),
                    child: Image.asset(
                     'assets/bg.png',
                    ),
                  ),
                Positioned(
                 left: 16.w,
                  top: 300.h,
                  child:  const LoginCard())
                ],
              ),
            ),
          ),
       
      );
  }
}