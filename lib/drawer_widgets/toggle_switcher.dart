import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToggleSwitch extends StatefulWidget {
  final double tickerSize;
  final double handlerWidth;
  final double handlerHeight;
  Color? colorCircle = Colors.green[600];
  bool? boxShadow = true;
  Color? colorContainer = Colors.grey[300];
  VoidCallback onButton;
  ToggleSwitch({
    Key? key,
    required this.tickerSize,
    required this.handlerWidth,
    required this.handlerHeight,
    required this.onButton,
    this.colorCircle,
    this.boxShadow,
    this.colorContainer,
  }) : super(key: key);

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  Alignment align = Alignment.centerLeft;

  @override
  Widget build(BuildContext context) {
    final switcher = Provider.of<TextEditingController>(context);
    return Center(
      child: SizedBox(
        height: widget.tickerSize,
        width: widget.handlerWidth,
        child: GestureDetector(
          onTap: () {
            setState(() {
              align = align == Alignment.centerRight
                  ? Alignment.centerLeft
                  : Alignment.centerRight;
            });
            if (align == Alignment.centerRight) {
              switcher.text = "1";
            } else {
              switcher.text = "0";
            }
            widget.onButton();
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: widget.handlerHeight,
                decoration: BoxDecoration(
                    color: widget.colorContainer,
                    borderRadius: BorderRadius.circular(10)),
              ),
              AnimatedAlign(
                alignment: align,
                duration: const Duration(milliseconds: 100),
                child: Container(
                  width: widget.tickerSize,
                  decoration: BoxDecoration(
                      color: align == Alignment.centerRight
                          ? widget.colorCircle
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
