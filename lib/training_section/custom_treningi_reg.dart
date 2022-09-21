import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/extra/custom_double_clip_item.dart';

class CustomTreningiReg extends StatelessWidget {
  const CustomTreningiReg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 155,
          width: 325,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  "assets/event-default.png",
                  height: 155,
                  width: 325,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, top: 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "7 Июля 11:00 Москва",
                      style: GoogleFonts.montserrat(
                        fontSize: 12.5,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Сервисное обслуживание HANSA",
                      style: GoogleFonts.montserrat(
                        fontSize: 12.5,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Ведущие",
                      style: GoogleFonts.montserrat(
                        fontSize: 8,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 11),
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff666666),
                              ),
                              child: Center(
                                child: Text(
                                  "АА",
                                    textScaleFactor: 1.0,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    color: const Color(0xffffffff),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 35,
                            width: 35,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xff666666),
                            ),
                            child: Center(
                              child: Text(
                                "ЕБ",
                                  textScaleFactor: 1.0,
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  color: const Color(0xffffffff),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const CustomDoubleClipItem(
          backgroundColor: Color.fromARGB(255, 213, 0, 50),
          buttonTextColor: Color(0xffffffff),
          buttonColor: Color(0xff232323),
          titleColor: Color(0xffffffff),
          stbuttonText: "Задать вопрос ведущему",
          ndbuttonText: "Пройти тестирование",
          title: "Вебинар начнется: \nЧерез 1 неделю \nНачало: 7 Июля 2022",
          //////////////////////////// nnnnnn
          linkPDF: "",
          linkPDFSkachat: "",
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 25),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(64),
            child: GestureDetector(
              child: Container(
                height: 30,
                width: 215,
                color: const Color(0xff25b049),
                child: Center(
                  child: Text(
                    "Зарегистрироваться",
                      textScaleFactor: 1.0,
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      color: const Color(0xffffffff),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Text(
          "Проводите свои мероприятия.\nЗарегистрируйтесь, чтобы получить все\nпремиум опции и проводить встречи\nи вебинары",
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            fontSize: 12.5,
            color: const Color(0xff767676),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
