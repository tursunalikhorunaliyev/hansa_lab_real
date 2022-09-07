import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class PartIndicator extends StatelessWidget {
  PartIndicator({Key? key, required this.icon}) : super(key: key);
  Widget icon;
  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: isTablet ? 7.h : 10.h,
            bottom: isTablet ? 8 : 15.h,
          ),
          child: Container(
            width: 70.33333333333333,
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 213, 0, 50),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(21),
                    bottomRight: Radius.circular(21))),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.5),
              child: icon,
            ),
          ),
        ),
        Image.asset(
          "assets/#Статьи .png",
          width: 100,
        )
      ],
    );
  }
}
