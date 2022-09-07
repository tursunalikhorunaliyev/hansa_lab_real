import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTreningiVideo extends StatelessWidget {
  const CustomTreningiVideo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Column(
        children: [
          const SizedBox(
            height: 11,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 90,
              width: 325,
              color: const Color(0xffffffff),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      "Иммерсивное шоу\n\"Увидимся на кухне\"г.\nЕкатеринбург:     18.04.2019",
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(64),
                        child: Container(
                          height: 25,
                          width: 95,
                          color: const Color.fromARGB(255, 213, 0, 50),
                          child: Center(
                            child: Text(
                              "Скачать",
                              style: GoogleFonts.montserrat(
                                fontSize: 10,
                                color: const Color(0xffffffff),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
