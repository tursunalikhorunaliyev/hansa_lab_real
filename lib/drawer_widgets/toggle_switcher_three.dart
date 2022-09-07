import 'package:flutter/material.dart';
import 'package:hansa_lab/classes/send_check_switcher.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToggleSwitcherThree extends StatefulWidget {
  const ToggleSwitcherThree({
    Key? key,
  }) : super(key: key);

  @override
  State<ToggleSwitcherThree> createState() => _ToggleSwitcherThreeState();
}

class _ToggleSwitcherThreeState extends State<ToggleSwitcherThree> {
  Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    final providerSendCheckSwitcher = Provider.of<SendCheckSwitcher>(context);
    alignment = providerSendCheckSwitcher.getBool == true
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Center(
      child: SizedBox(
        height: 21,
        width: 40,
        child: GestureDetector(
          onTap: () {
            setState(() {
              alignment = alignment == Alignment.centerRight
                  ? Alignment.centerLeft
                  : Alignment.centerRight;
            });
            if (alignment == Alignment.centerRight) {
              providerSendCheckSwitcher.setBool(true);
            } else {
              providerSendCheckSwitcher.setBool(false);
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                    color: const Color(0xFFdddddd),
                    borderRadius: BorderRadius.circular(10)),
              ),
              AnimatedAlign(
                alignment: alignment!,
                duration: const Duration(milliseconds: 100),
                child: Container(
                  width: 21,
                  decoration: BoxDecoration(
                      color: alignment! == Alignment.centerRight
                          ? const Color(0xFF25b049)
                          : Colors.grey[350],
                      borderRadius: BorderRadius.circular(25.r)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
