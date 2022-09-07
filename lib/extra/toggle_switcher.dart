import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToggleSwitch extends StatefulWidget {
  final double tickerSize;
  final double handlerWidth;
  final double handlerHeight;
  const ToggleSwitch(
      {Key? key,
      required this.tickerSize,
      required this.handlerWidth,
      required this.handlerHeight})
      : super(key: key);

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  Alignment align = Alignment.centerLeft;
  @override
  Widget build(BuildContext context) {
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
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: widget.handlerHeight,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              AnimatedAlign(
                alignment: align,
                duration: const Duration(milliseconds: 100),
                child: Container(
                  width: widget.tickerSize,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 184, 184, 184),
                        blurRadius: align == Alignment.centerLeft ? 0 : 10,
                        offset: align == Alignment.centerLeft
                            ? const Offset(0, 0)
                            : const Offset(0, 5),
                      )
                    ],
                    color: align == Alignment.centerRight
                        ? Colors.green[600]
                        : Colors.grey[350],
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
