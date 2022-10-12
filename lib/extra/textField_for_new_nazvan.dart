import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TextFieldForNewNazvan extends StatelessWidget {
  final TextEditingController textEditingController;

  final Color borderColor;
  final Color hintColor;
  final VoidCallback onTap;

  const TextFieldForNewNazvan(
      {super.key,
      required this.textEditingController,
      required this.borderColor,
      required this.onTap,
      required this.hintColor});

  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 11, right: 9),
      child: SizedBox(
        height: isTablet ? 45 : 38,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFffffff),
            borderRadius: BorderRadius.circular(54),
          ),
          child: TextField(
            controller: textEditingController,
            onTap: () {
              onTap();
            },
            /*  onChanged: (value) {
                      if (value.isEmpty) {
                        isHint = true;
                        setState(() {});
                      } else if (value.length == 1) {
                        isHint = false;
                        setState(() {});
                      }
                    }, */
            cursorHeight: 15,
            style: GoogleFonts.montserrat(
                fontSize: isTablet ? 13 : 10,
                fontWeight: FontWeight.w500,
                color: Colors.black),
            decoration: InputDecoration(
              hintText: "Новый",
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 0.9,
                  color: Color(0xFF000000),
                ),
                borderRadius: BorderRadius.circular(54),
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: borderColor == const Color.fromARGB(255, 213, 0, 50)
                        ? 0.9
                        : 0.1,
                    color: borderColor,
                  ),
                  borderRadius: BorderRadius.circular(54)),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 2, horizontal: 13),
              hintStyle: GoogleFonts.montserrat(
                  fontWeight: isTablet ? FontWeight.normal : FontWeight.normal,
                  fontSize: isTablet ? 13 : 10,
                  color: hintColor),
            ),
          ),
        ),
      ),
    );
  }
}
