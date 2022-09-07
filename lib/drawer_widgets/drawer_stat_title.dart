import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerStatTitle extends StatelessWidget {
  const DrawerStatTitle(
      {Key? key, required this.imagePath, required this.title})
      : super(key: key);
  final String imagePath;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 15),
      child: Row(
        children: [
          Container(
            width: 70,
            alignment: Alignment.centerRight,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 213, 0, 50),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(64),
                bottomRight: Radius.circular(64),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 5.5, bottom: 5.5, right: 15),
              child: Image.asset(
                imagePath,
                color: const Color(0xFFffffff),
                height: 31,
                width: 31,
              ),
            ),
          ),
          const SizedBox(
            width: 11,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "#",
                  style: GoogleFonts.montserrat(
                    color: const Color.fromARGB(255, 213, 0, 50),
                  ),
                ),
                TextSpan(
                  text: title,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff272624),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
