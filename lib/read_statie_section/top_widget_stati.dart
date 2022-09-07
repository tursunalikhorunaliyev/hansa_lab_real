import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopWidgetStati extends StatefulWidget {
  const TopWidgetStati({Key? key}) : super(key: key);

  @override
  State<TopWidgetStati> createState() => _TopWidgetStatiState();
}

class _TopWidgetStatiState extends State<TopWidgetStati> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 395,
      height: 81,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Icon(
            Icons.menu,
            color: Color(0xff444444),
            size: 35,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Image.asset(
                  'assets/logoHansa.png',
                  height: 25,
                  width: 214,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  '#Увидимсянакухне ',
                  style: GoogleFonts.montserrat(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
          const Icon(
            Icons.search,
            size: 35,
          ),
        ],
      ),
    );
  }
}
