import 'dart:async';
import 'dart:developer';

import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/blocs/bloc_number_country.dart';
import 'package:hansa_lab/blocs/bloc_sign.dart';
import 'package:hansa_lab/blocs/data_burn_text_changer_bloc.dart';
import 'package:hansa_lab/blocs/hansa_country_api.dart';
import 'package:hansa_lab/drawer_widgets/toggle_switcher.dart';
import 'package:hansa_lab/extra/popup_full_registr_doljnost.dart';
import 'package:hansa_lab/extra/popup_full_registr_gorod.dart';
import 'package:hansa_lab/extra/popup_full_registr_nazvaniy_seti.dart';
import 'package:hansa_lab/extra/popup_full_registr_number.dart';
import 'package:hansa_lab/extra/text_field_for_full_reg.dart';
import 'package:hansa_lab/providers/new_shop_provider.dart';
import 'package:hansa_lab/providers/provider_for_flipping/flip_login_provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/pdf_viewer.dart';

class FullRegistr extends StatefulWidget {
  const FullRegistr({Key? key}) : super(key: key);

  @override
  State<FullRegistr> createState() => _FullRegistrState();
}

class _FullRegistrState extends State<FullRegistr> {
  bool nameIsEmpty = false;
  bool lastnameIsEmpty = false;
  bool emailIsEmpty = false;
  bool phoneIsEmpty = false;
  bool dateIsEmpty = false;
  bool nazvaniyaIsEmpty = false;
  bool doljnostIsEmpty = false;
  bool gorodIsEmpty = false;
  bool adressIsEmpty = false;
  dynamic fourTogglehas = '';

  final imyaTextEditingController = TextEditingController();
  final familiyaTextEditingController = TextEditingController();
  final emailTextFielController = TextEditingController();
  final phoneTextFieldController = TextEditingController();

  // final adresTorgoviySetTextFielController = TextEditingController();
  final nazvaniyaTextFieldController = TextEditingController();

  // final doljnostTextFieldController = TextEditingController();
  final gorodTextFieldController = TextEditingController();
  final dataRojdeniyaController = TextEditingController();
  final numberCountryaController = TextEditingController();
  final firstToggle = TextEditingController(text: "0");
  final secondToggle = TextEditingController(text: "0");
  final thirdToggle = TextEditingController(text: "0");
  final fourthToggle = TextEditingController(text: "0");
  final dateBurnBloC = DateBornTextBloC();
  bool? isTap;
  int? regionId;
  FocusNode node = FocusNode();

  bool isHintDate = true;

  var dateFormatter = MaskTextInputFormatter(
    mask: "##/##/####",
  );
  var numberFormat = MaskTextInputFormatter(mask: "(###) ### ## ##");
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final flipLoginProvider = Provider.of<FlipLoginProvider>(context);
    final isTablet = Provider.of<bool>(context);
    final newShop = Provider.of<NewShopProvider>(context);
    final providerFlip = Provider.of<Map<String, FlipCardController>>(context);
    final providerNumberCountry = Provider.of<BlocNumberCountry>(context);
    final blocCity = HansaCountryBloC(null);
    blocCity.eventSink.add(CityEnum.city);
    return SingleChildScrollView(
      controller: scrollController,
      child: Center(
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: EdgeInsets.only(top: isTablet ? 446 : 274, bottom: 84),
                child: Container(
                  width: isTablet ? 556 : 346,
                  decoration: BoxDecoration(
                      color: const Color(0xFFf2f2f2),
                      borderRadius: BorderRadius.circular(isTablet ? 16 : 5)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                flipLoginProvider.changeIsClosed(false);
                                providerFlip['login']!.toggleCard();
                              },
                              child: const Icon(
                                Icons.close_rounded,
                                size: 30,
                                color: Color(0xFF8c8c8b),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: isTablet ? 75 : 82),
                        child: Text(
                          "Регистрация",
                          style: GoogleFonts.montserrat(
                              fontSize: isTablet ? 28 : 24,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      TextFieldForFullRegister(
                        textEditingController: familiyaTextEditingController,
                        text: "Фамилия",
                        height: isTablet ? 45 : 38,
                        size: isTablet ? 16 : 13,
                        weight:
                            isTablet ? FontWeight.normal : FontWeight.normal,
                        borderColor: lastnameIsEmpty
                            ? const Color.fromARGB(255, 213, 0, 50)
                            : const Color(0xFF000000),
                        hintColor: lastnameIsEmpty
                            ? const Color.fromARGB(255, 213, 0, 50)
                            : const Color(0xFF444444),
                        onTap: () => setState(() => lastnameIsEmpty = false),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFieldForFullRegister(
                        textEditingController: imyaTextEditingController,
                        text: "Имя",
                        height: isTablet ? 45 : 38,
                        size: isTablet ? 16 : 13,
                        weight:
                            isTablet ? FontWeight.normal : FontWeight.normal,
                        borderColor: nameIsEmpty
                            ? const Color.fromARGB(255, 213, 0, 50)
                            : const Color(0xFF000000),
                        hintColor: nameIsEmpty
                            ? const Color.fromARGB(255, 213, 0, 50)
                            : const Color(0xFF444444),
                        onTap: () => setState(() => nameIsEmpty = false),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      TextFieldForFullRegister(
                        textEditingController: emailTextFielController,
                        text: "Email",
                        height: isTablet ? 45 : 38,
                        size: isTablet ? 16 : 13,
                        weight:
                            isTablet ? FontWeight.normal : FontWeight.normal,
                        borderColor: emailIsEmpty
                            ? const Color.fromARGB(255, 213, 0, 50)
                            : const Color(0xFF000000),
                        hintColor: emailIsEmpty
                            ? const Color.fromARGB(255, 213, 0, 50)
                            : const Color(0xFF444444),
                        onTap: () => setState(() => emailIsEmpty = false),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 11, right: 9),
                        child: Container(
                          height: isTablet ? 45 : 38,
                          decoration: BoxDecoration(
                            color: const Color(0xFFffffff),
                            borderRadius: BorderRadius.circular(54),
                          ),
                          child: TextField(
                            inputFormatters: [dateFormatter],
                            onTap: () {
                              setState(() => dateIsEmpty = false);
                            },
                            cursorHeight: 15,
                            style: GoogleFonts.montserrat(
                                fontSize: isTablet ? 16 : 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                            controller: dataRojdeniyaController,
                            decoration: InputDecoration(
                              hintText: "Дата рождения",
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 0.9,
                                  color: dateIsEmpty
                                      ? const Color.fromARGB(255, 213, 0, 50)
                                      : const Color(0xFF000000),
                                ),
                                borderRadius: BorderRadius.circular(54),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: dateIsEmpty ? 0.9 : 0.1,
                                    color: dateIsEmpty
                                        ? const Color.fromARGB(255, 213, 0, 50)
                                        : const Color(0xFF000000),
                                  ),
                                  borderRadius: BorderRadius.circular(54)),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 13),
                              hintStyle: GoogleFonts.montserrat(
                                fontWeight: isTablet
                                    ? FontWeight.normal
                                    : FontWeight.normal,
                                fontSize: isTablet ? 16 : 13,
                                color: dateIsEmpty
                                    ? const Color.fromARGB(255, 213, 0, 50)
                                    : const Color(0xFF444444),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      // Provider(
                      //     create: (context) => doljnostTextFieldController,
                      //     child: PopupFullRegistrDoljnost(
                      //       borderColor: doljnostIsEmpty
                      //           ? const Color.fromARGB(255, 213, 0, 50)
                      //           : Colors.black,
                      //       hintColor: doljnostIsEmpty
                      //           ? const Color.fromARGB(255, 213, 0, 50)
                      //           : const Color(0xff444444),
                      //       onTap: () =>
                      //           setState(() => doljnostIsEmpty = false),
                      //     )),
                      // const SizedBox(
                      //   height: 4,
                      // ),
                      Provider(
                          create: (context) => nazvaniyaTextFieldController,
                          child: PopupFullRegistrNazvaniySeti(
                            borderColor: nazvaniyaIsEmpty
                                ? const Color.fromARGB(255, 213, 0, 50)
                                : Colors.black,
                            hintColor: nazvaniyaIsEmpty
                                ? const Color.fromARGB(255, 213, 0, 50)
                                : const Color(0xff444444),
                            onTap: () =>
                                setState(() => nazvaniyaIsEmpty = false),
                          )),
                      const SizedBox(
                        height: 4,
                      ),
                      // TextFieldForFullRegister(
                      //   textEditingController:
                      //       adresTorgoviySetTextFielController,
                      //   text: "Адрес торговой сети",
                      //   height: isTablet ? 45 : 38,
                      //   size: isTablet ? 16 : 13,
                      //   weight:
                      //       isTablet ? FontWeight.normal : FontWeight.normal,
                      //   borderColor: adressIsEmpty
                      //       ? const Color.fromARGB(255, 213, 0, 50)
                      //       : const Color(0xFF000000),
                      //   hintColor: adressIsEmpty
                      //       ? const Color.fromARGB(255, 213, 0, 50)
                      //       : const Color(0xFF444444),
                      //   onTap: () => setState(() => adressIsEmpty = false),
                      // ),
                      // const SizedBox(
                      //   height: 4,
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(left: 11, right: 9),
                        child: Container(
                            height: isTablet ? 45 : 38,
                            decoration: BoxDecoration(
                              color: const Color(0xFFffffff),
                              borderRadius: BorderRadius.circular(54),
                            ),
                            child: StreamBuilder<EnumCuntryNumber>(
                                stream: providerNumberCountry.stream,
                                builder: (context, snapshot) {
                                  return TextField(
                                    inputFormatters: [numberFormat],
                                    onTap: () {
                                      setState(() => dateIsEmpty = false);
                                    },
                                    cursorHeight: 15,
                                    style: GoogleFonts.montserrat(
                                        fontSize: isTablet ? 16 : 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                    controller: phoneTextFieldController,
                                    decoration: InputDecoration(
                                      hintText: "Телефон",
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 13, left: 17),
                                        child: Text(
                                          snapshot.data == EnumCuntryNumber.rus
                                              ? '+7 '
                                              : snapshot.data ==
                                                      EnumCuntryNumber.kazak
                                                  ? '+7 '
                                                  : snapshot.data ==
                                                          EnumCuntryNumber.armen
                                                      ? '+374 '
                                                      : '+7 ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: phoneIsEmpty
                                                ? const Color.fromARGB(
                                                    255, 213, 0, 50)
                                                : const Color(0xFF444444),
                                          ),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 0.9,
                                          color: dateIsEmpty
                                              ? const Color.fromARGB(
                                                  255, 213, 0, 50)
                                              : const Color(0xFF000000),
                                        ),
                                        borderRadius: BorderRadius.circular(54),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: dateIsEmpty ? 0.9 : 0.1,
                                            color: dateIsEmpty
                                                ? const Color.fromARGB(
                                                    255, 213, 0, 50)
                                                : const Color(0xFF000000),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(54)),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 13),
                                      hintStyle: GoogleFonts.montserrat(
                                        fontWeight: isTablet
                                            ? FontWeight.normal
                                            : FontWeight.normal,
                                        fontSize: isTablet ? 16 : 13,
                                        color: dateIsEmpty
                                            ? const Color.fromARGB(
                                                255, 213, 0, 50)
                                            : const Color(0xFF444444),
                                      ),
                                    ),
                                  );
                                })),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Provider(
                          create: (context) => numberCountryaController,
                          child: PopUpFullRegistrNumber(
                            borderColor: gorodIsEmpty
                                ? const Color.fromARGB(255, 213, 0, 50)
                                : Colors.black,
                            hintColor: gorodIsEmpty
                                ? const Color.fromARGB(255, 213, 0, 50)
                                : const Color(0xff444444),
                            id: (id) {
                              setState(() {
                                regionId = id;
                              });
                            },
                            onClick: () {
                              setState(() {
                                numberCountryaController.clear();
                              });
                            },
                            onTap: (val) {
                              setState(() {
                                gorodIsEmpty = false;
                              });
                            },
                          )),
                      const SizedBox(
                        height: 4,
                      ),
                      if (numberCountryaController.text.isNotEmpty)
                        Provider(
                            create: (context) => gorodTextFieldController,
                            child: PopupFullRegistrGorod(
                              id: regionId!,
                              borderColor: gorodIsEmpty
                                  ? const Color.fromARGB(255, 213, 0, 50)
                                  : Colors.black,
                              hintColor: gorodIsEmpty
                                  ? const Color.fromARGB(255, 213, 0, 50)
                                  : const Color(0xff444444),
                              onTap: () => setState(() {
                                gorodIsEmpty = false;
                              }),
                              // text: ,
                            )),
                      const SizedBox(
                        height: 24,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                textSwitch("Не выходить из приложения",
                                    isTablet ? 16 : 13),
                                Provider(
                                  create: (context) => firstToggle,
                                  child: ToggleSwitch(
                                    handlerWidth: 40,
                                    handlerHeight: 12,
                                    tickerSize: 21,
                                    colorCircle: Colors.green[600],
                                    colorContainer: Colors.grey[300],
                                    onButton: () {},
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 17,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                textSwitch("Согласен на СМС и Email рассылку",
                                    isTablet ? 16 : 13),
                                Provider(
                                  create: (context) => secondToggle,
                                  child: ToggleSwitch(
                                    handlerWidth: 40,
                                    handlerHeight: 12,
                                    tickerSize: 21,
                                    colorCircle: Colors.green[600],
                                    colorContainer: Colors.grey[300],
                                    onButton: () {},
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 17,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                textSwitch("Подтверждаю подлиность данных",
                                    isTablet ? 16 : 13),
                                Provider(
                                  create: (context) => thirdToggle,
                                  child: ToggleSwitch(
                                    handlerWidth: 40,
                                    handlerHeight: 12,
                                    tickerSize: 21,
                                    colorCircle: Colors.green[600],
                                    colorContainer: Colors.grey[300],
                                    onButton: () {},
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 17,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                      color: fourTogglehas == 1
                                          ? Colors.red
                                          : Colors.white24)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      textSwitch("Соглашаюсь на обработку",
                                          isTablet ? 16 : 13),
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const PDFViewer(
                                                          pdfUrlForPDFViewer:
                                                              "https://hansa-lab.ru/storage/privacy.pdf"),
                                                ),
                                              );
                                            });
                                          },
                                          child: const Text(
                                            "персональных данных",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 13),
                                          )),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 75,
                                  ),
                                  Provider(
                                    create: (context) => fourthToggle,
                                    child: ToggleSwitch(
                                      handlerWidth: 40,
                                      handlerHeight: 12,
                                      tickerSize: 21,
                                      colorCircle: Colors.green[600],
                                      colorContainer: Colors.grey[300],
                                      onButton: () => setState(() {
                                        if (int.parse(fourthToggle.text) == 1) {
                                          fourTogglehas = 0;
                                        } else {
                                          fourTogglehas = 1;
                                        }
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                            left: 11,
                            right: 9,
                            top: isTablet ? 30 : 25,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              dynamic day;
                              dynamic month;
                              dynamic year;
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (dataRojdeniyaController.text.isNotEmpty) {
                                day = dataRojdeniyaController.text
                                    .substring(0, 2);
                                month = dataRojdeniyaController.text
                                    .substring(3, 5);
                                year =
                                    dataRojdeniyaController.text.substring(6);
                              }
                              if (int.parse(fourthToggle.text) == 1) {
                                fourTogglehas = 0;
                              } else {
                                fourTogglehas = 1;
                              }
                              toSignUp(
                                lastname: familiyaTextEditingController.text,
                                firstname: imyaTextEditingController.text,
                                email: emailTextFielController.text,
                                bornedAt: "$day.$month.$year",
                                // jobId: doljnostTextFieldController.text,//commented
                                jobId: " ",
                                storeId: nazvaniyaTextFieldController.text,
                                shopnet: newShop.getNewShop.toString(),
                                // shopadress: adresTorgoviySetTextFielController.text, // commented
                                shopadress: " ",
                                phone: phoneTextFieldController.text,
                                cityId: gorodTextFieldController.text,
                                isAgreeSms: secondToggle.text,
                                isAgreeIdentity: thirdToggle.text,
                                isAgreePersonal: fourthToggle.text,
                                providerFlip: providerFlip,
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: isTablet ? 60 : 46,
                              width: isTablet ? 525 : 325,
                              decoration: BoxDecoration(
                                color: const Color(0xFF25b049),
                                borderRadius: BorderRadius.circular(70),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 15),
                                  ),
                                ],
                              ),
                              child: Text(
                                "Зарегистрироваться",
                                style: GoogleFonts.montserrat(
                                    fontSize: isTablet ? 18 : 14,
                                    color: const Color(0xFFffffff)),
                              ),
                            ),
                          )),
                      const SizedBox(
                        height: 60,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: isTablet ? 355 : 215,
                left: isTablet ? 177 : 107,
                child: isTablet
                    ? Image.asset("assets/tabletTumLogo.png")
                    : Image.asset(
                        "assets/Logo.png",
                        height: 133,
                        width: 133,
                      ),
              ),
              Positioned(
                bottom: 10,
                left: 40,
                right: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "По всем вопросам пишите на",
                      textScaleFactor: 1.0,
                      style: TextStyle(fontSize: 12, color: Color(0xFF989a9d)),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          launchUrl(Uri.parse('https://support@hansa-lab.ru'));
                        });
                      },
                      child: Text(
                        "Support@hansa-lab.ru",
                        style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: const Color(0xFF989a9d),
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textSwitch(String text, double size) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
          fontSize: size,
          color: const Color(0xFFa1b7c2),
          fontWeight: FontWeight.w500),
    );
  }

  toSignUp(
      {required String lastname,
      required String firstname,
      required String email,
      required String bornedAt,
      required String jobId,
      required String storeId,
      required String shopnet,
      required String shopadress,
      required String phone,
      String countrytype = "1",
      required String cityId,
      required String isAgreeSms,
      required String isAgreeIdentity,
      required String isAgreePersonal,
      required dynamic providerFlip}) {
    if (firstname.isEmpty) setState(() => nameIsEmpty = true);
    if (lastname.isEmpty) setState(() => lastnameIsEmpty = true);
    if (email.isEmpty) setState(() => emailIsEmpty = true);
    if (shopadress.isEmpty) setState(() => adressIsEmpty = true);
    if (phone.length < 5) setState(() => phoneIsEmpty = true);
    if (bornedAt.length != 10) setState(() => dateIsEmpty = true);
    if (storeId.isEmpty && shopnet.isEmpty) {
      setState(() => nazvaniyaIsEmpty = true);
    }
    if (jobId.isEmpty) setState(() => doljnostIsEmpty = true);
    if (cityId.isEmpty) setState(() => gorodIsEmpty = true);
    if (firstname.isNotEmpty &&
        lastname.isNotEmpty &&
        email.isNotEmpty &&
        phone.length > 5 &&
        bornedAt.length > 3 &&
        (storeId.isNotEmpty || shopnet.isNotEmpty) &&
        jobId.isNotEmpty &&
        cityId.isNotEmpty &&
        shopadress.isNotEmpty &&
        fourthToggle.text != 1) {
      BlocSignUp()
          .signUp(
        lastname,
        firstname,
        email,
        bornedAt,
        jobId,
        storeId,
        shopnet,
        shopadress,
        phone,
        "1",
        cityId,
        secondToggle.text,
        thirdToggle.text,
        fourthToggle.text,
      )
          .then((value) {
        if (value['status'] as bool == false) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(value["message"]["email"][0].toString()),
            backgroundColor: const Color.fromARGB(255, 213, 0, 50),
          ));
          setState(() {
            emailIsEmpty = true;
          });
        } else {
          providerFlip['signin']!.toggleCard();
          scrollController.animateTo(0,
              duration: const Duration(milliseconds: 100), curve: Curves.ease);
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Заполните пустые поля"),
        backgroundColor: Color.fromARGB(255, 213, 0, 50),
      ));
    }
  }

  InputDecoration inputDecoration(bool isTablet, Color color, var hintColor) {
    return InputDecoration(
      hintText: "(223) 232-13-12",
      // isDense: true,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: .9, color: color),
        borderRadius: BorderRadius.circular(54),
      ),
      focusedErrorBorder: outlineInputBorder(
        color == const Color.fromARGB(255, 213, 0, 50) ? 0.9 : .1,
        Colors.black,
      ),
      enabledBorder: outlineInputBorder(
          color == const Color.fromARGB(255, 213, 0, 50) ? 0.9 : 0.2, color),
      errorBorder: outlineInputBorder(
          color == const Color.fromARGB(255, 213, 0, 50) ? 0.9 : .1, color),
      contentPadding: const EdgeInsets.symmetric(vertical: 2),
      hintStyle: TextStyle(color: hintColor),
    );
  }

  OutlineInputBorder outlineInputBorder(double width, Color color) {
    return OutlineInputBorder(
        borderSide: BorderSide(width: width, color: color),
        borderRadius: BorderRadius.circular(54));
  }

  TextStyle style(FontWeight fontWeight, bool isTablet, Color color) {
    return GoogleFonts.montserrat(
      fontWeight: fontWeight,
      fontSize: isTablet ? 13 : 10,
      color: color,
    );
  }

  _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}
