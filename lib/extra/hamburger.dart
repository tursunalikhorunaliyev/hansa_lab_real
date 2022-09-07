import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HamburgerIcon extends StatelessWidget {
  final Color color;
  const HamburgerIcon({
    this.color = Colors.black,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Divider(
          endIndent: isTablet ? 0 : 8,
          height: isTablet ? 8 : 5,
          thickness: isTablet ? 3 : 2,
          color: color,
        ),
        Divider(
          endIndent: isTablet ? 8 : 15,
          height: isTablet ? 8 : 5,
          thickness: isTablet ? 3 : 2,
          color: color,
        ),
        Divider(
          endIndent: isTablet ? 0 : 8,
          height: isTablet ? 8 : 5,
          thickness: isTablet ? 3 : 2,
          color: color,
        ),
        Divider(
          endIndent: isTablet ? 8 : 15,
          height: isTablet ? 8 : 5,
          thickness: isTablet ? 3 : 2,
          color: color,
        ),
      ],
    );
  }
}
