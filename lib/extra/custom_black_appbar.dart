import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hansa_lab/extra/hamburger.dart';
import 'package:provider/provider.dart';

class CustomBlackAppBar extends StatelessWidget {
  const CustomBlackAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerScaffoldKey = Provider.of<GlobalKey<ScaffoldState>>(context);
    final providerChewieController = Provider.of<ChewieController>(context);

    return Container(
      height: 81.h,
      color: const Color(0xff333333),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
              providerChewieController
                ..seekTo(Duration.zero)
                ..pause();
              providerScaffoldKey.currentState!.openDrawer();
            },
            icon: const HamburgerIcon(
              color: Color(0xffffffff),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/hansa_white.png',
                height: 25.h,
                width: 214.w,
              ),
            ],
          ),
          Icon(
            Icons.search,
            size: 25.sp,
            color: const Color(0xffffffff),
          ),
        ],
      ),
    );
  }
}
