import 'dart:developer';
import 'dart:io';

import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/blocs/bloc_sign.dart';
import 'package:hansa_lab/blocs/data_burn_text_changer_bloc.dart';
import 'package:hansa_lab/blocs/hansa_country_api.dart';
import 'package:hansa_lab/drawer_widgets/toggle_switcher.dart';
import 'package:hansa_lab/extra/popup_full_registr_doljnost.dart';
import 'package:hansa_lab/extra/popup_full_registr_gorod.dart';
import 'package:hansa_lab/extra/popup_full_registr_nazvaniy_seti.dart';
import 'package:hansa_lab/extra/text_field_for_full_reg.dart';
import 'package:hansa_lab/providers/new_shop_provider.dart';
import 'package:hansa_lab/providers/provider_for_flipping/flip_login_provider.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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
  bool isCollepsed = false;

  final dateRangeController = DateRangePickerController();
  final imyaTextEditingController = TextEditingController();
  final familiyaTextEditingController = TextEditingController();
  final emailTextFielController = TextEditingController();
  final phoneTextFieldController = TextEditingController();
  final adresTorgoviySetTextFielController = TextEditingController();
  final nazvaniyaTextFieldController = TextEditingController();
  final doljnostTextFieldController = TextEditingController();
  final gorodTextFieldController = TextEditingController();
  final firstToggle = TextEditingController(text: "0");
  final secondToggle = TextEditingController(text: "0");
  final thirdToggle = TextEditingController(text: "0");
  final fourthToggle = TextEditingController(text: "0");
  final dateBurnBloC = DateBornTextBloC();
  FocusNode node = FocusNode();
  @override
  Widget build(BuildContext context) {
    final flipLoginProvider = Provider.of<FlipLoginProvider>(context);
    final newShop = Provider.of<NewShopProvider>(context);
    final isTablet = Provider.of<bool>(context);
    final providerFlip = Provider.of<Map<String, FlipCardController>>(context);
    log("SignUp build");
    final blocCity = HansaCountryBloC(1);
    blocCity.eventSink.add(CityEnum.city);
    return SingleChildScrollView(
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
                        textEditingController: imyaTextEditingController,
                        text: "Имя",
                        height: isTablet ? 45 : 38,
                        size: isTablet ? 13 : 10,
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
                        textEditingController: familiyaTextEditingController,
                        text: "Фамилия",
                        height: isTablet ? 45 : 38,
                        size: isTablet ? 13 : 10,
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
                        textEditingController: emailTextFielController,
                        text: "Email",
                        height: isTablet ? 45 : 38,
                        size: isTablet ? 13 : 10,
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
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(54),
                          child: Container(
                            color: Colors.white,
                            height: 38,
                            child: Stack(
                              children: [
                                InternationalPhoneNumberInput(
                                  focusNode: node,
                                  initialValue: PhoneNumber(isoCode: 'RU'),
                                  onInputChanged: (value) {
                                    phoneTextFieldController.text =
                                        value.phoneNumber!;
                                  },
                                  inputDecoration: inputDecoration(
                                    isTablet,
                                    phoneIsEmpty
                                        ? const Color.fromARGB(255, 213, 0, 50)
                                        : Colors.black,
                                    phoneIsEmpty
                                        ? const Color.fromARGB(255, 213, 0, 50)
                                        : null,
                                  ),
                                  keyboardType: TextInputType.phone,
                                  selectorTextStyle: style(
                                      FontWeight.w500,
                                      isTablet,
                                      phoneIsEmpty
                                          ? const Color.fromARGB(
                                              255, 213, 0, 50)
                                          : Colors.black),
                                  textStyle: style(
                                      FontWeight.w500,
                                      isTablet,
                                      phoneIsEmpty
                                          ? const Color.fromARGB(
                                              255, 213, 0, 50)
                                          : Colors.black),
                                  selectorConfig: const SelectorConfig(
                                      leadingPadding: 0,
                                      useEmoji: false,
                                      showFlags: false,
                                      setSelectorButtonAsPrefixIcon: true,
                                      selectorType:
                                          PhoneInputSelectorType.BOTTOM_SHEET),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 35),
                                  child: GestureDetector(onTap: () {
                                    setState(() => phoneIsEmpty = false);
                                    node.requestFocus();
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            dateIsEmpty = false;
                            isCollepsed = !isCollepsed;
                          });
                          /* showCupertinoModalPopup(
                              context: context,
                              builder: (context) {
                                return Container(
                                    width: 360,
                                    height: 400,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: SfDateRangePicker(
                                      controller: dateRangeController,
                                      selectionColor:
                                          const Color.fromARGB(255, 213, 0, 50),
                                      todayHighlightColor:
                                          const Color.fromARGB(255, 213, 0, 50),
                                      onSelectionChanged: (a) {
                                        String day = dateRangeController
                                                    .selectedDate!.day
                                                    .toString()
                                                    .length ==
                                                1
                                            ? "0${dateRangeController.selectedDate!.day}"
                                            : dateRangeController
                                                .selectedDate!.day
                                                .toString();
                                        String month = dateRangeController
                                                    .selectedDate!.month
                                                    .toString()
                                                    .length ==
                                                1
                                            ? "0${dateRangeController.selectedDate!.month}"
                                            : dateRangeController
                                                .selectedDate!.month
                                                .toString();
                                        String year = dateRangeController
                                            .selectedDate!.year
                                            .toString();
                                        dateBurnBloC.streamSink
                                            .add("$day.$month.$year");
                                        Navigator.pop(context);
                                      },
                                    ));
                              }); */
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          alignment: Alignment.centerLeft,
                          width: isTablet ? 538 : 325,
                          height: isTablet
                              ? isCollepsed
                                  ? 483
                                  : 43
                              : isCollepsed
                                  ? 478
                                  : 38,
                          padding: EdgeInsets.only(top: isCollepsed ? 10 : 0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFffffff),
                            borderRadius:
                                BorderRadius.circular(isCollepsed ? 10 : 54),
                            border: Border.all(
                                width: dateIsEmpty ? 0.9 : 0.1,
                                color: dateIsEmpty
                                    ? const Color.fromARGB(255, 213, 0, 50)
                                    : Colors.black),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 14),
                                    child: StreamBuilder<String>(
                                        initialData: "Дата рождения",
                                        stream: dateBurnBloC.stream,
                                        builder: (context, snapshot) {
                                          return Text(
                                            snapshot.data!,
                                            style: snapshot.data ==
                                                    "Дата рождения"
                                                ? GoogleFonts.montserrat(
                                                    fontSize:
                                                        isTablet ? 13 : 10,
                                                    color: dateIsEmpty
                                                        ? const Color.fromARGB(
                                                            255, 213, 0, 50)
                                                        : const Color(
                                                            0xFF444444))
                                                : GoogleFonts.montserrat(
                                                    fontSize:
                                                        isTablet ? 13 : 10,
                                                    fontWeight: FontWeight.w500,
                                                    color: dateIsEmpty
                                                        ? const Color.fromARGB(
                                                            255, 213, 0, 50)
                                                        : Colors.black),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                              Visibility(
                                visible: isCollepsed,
                                child: Column(
                                  children: [
                                    Container(
                                        width: 360,
                                        height: 400,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: SfDateRangePicker(
                                          controller: dateRangeController,
                                          selectionColor: const Color.fromARGB(
                                              255, 213, 0, 50),
                                          todayHighlightColor:
                                              const Color.fromARGB(
                                                  255, 213, 0, 50),
                                          onSelectionChanged: (a) {
                                            String day = dateRangeController
                                                        .selectedDate!.day
                                                        .toString()
                                                        .length ==
                                                    1
                                                ? "0${dateRangeController.selectedDate!.day}"
                                                : dateRangeController
                                                    .selectedDate!.day
                                                    .toString();
                                            String month = dateRangeController
                                                        .selectedDate!.month
                                                        .toString()
                                                        .length ==
                                                    1
                                                ? "0${dateRangeController.selectedDate!.month}"
                                                : dateRangeController
                                                    .selectedDate!.month
                                                    .toString();
                                            String year = dateRangeController
                                                .selectedDate!.year
                                                .toString();
                                            dateBurnBloC.streamSink
                                                .add("$day.$month.$year");
                                          },
                                        )),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              isCollepsed = !isCollepsed;
                                            });
                                          },
                                          height: 30,
                                          minWidth: 300,
                                          color: const Color.fromARGB(
                                              255, 213, 0, 50),
                                          child: Text(
                                            "OK",
                                            style: GoogleFonts.montserrat(
                                                fontSize: 10,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
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
                      Provider(
                          create: (context) => doljnostTextFieldController,
                          child: PopupFullRegistrDoljnost(
                            borderColor: doljnostIsEmpty
                                ? const Color.fromARGB(255, 213, 0, 50)
                                : Colors.black,
                            hintColor: doljnostIsEmpty
                                ? const Color.fromARGB(255, 213, 0, 50)
                                : const Color(0xff444444),
                            onTap: () =>
                                setState(() => doljnostIsEmpty = false),
                          )),
                      const SizedBox(
                        height: 4,
                      ),
                      Provider(
                          create: (context) => gorodTextFieldController,
                          child: PopupFullRegistrGorod(
                            borderColor: gorodIsEmpty
                                ? const Color.fromARGB(255, 213, 0, 50)
                                : Colors.black,
                            hintColor: gorodIsEmpty
                                ? const Color.fromARGB(255, 213, 0, 50)
                                : const Color(0xff444444),
                            onTap: () => setState(() => gorodIsEmpty = false),
                          )),
                      const SizedBox(
                        height: 4,
                      ),
                      TextFieldForFullRegister(
                        textEditingController:
                            adresTorgoviySetTextFielController,
                        text: "Адрес торговой сети",
                        height: isTablet ? 45 : 38,
                        size: isTablet ? 13 : 10,
                        weight:
                            isTablet ? FontWeight.normal : FontWeight.normal,
                        borderColor: adressIsEmpty
                            ? const Color.fromARGB(255, 213, 0, 50)
                            : const Color(0xFF000000),
                        hintColor: adressIsEmpty
                            ? const Color.fromARGB(255, 213, 0, 50)
                            : const Color(0xFF444444),
                        onTap: () => setState(() => adressIsEmpty = false),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                textSwitch("Не выходить из приложения",
                                    isTablet ? 16 : 11),
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
                                    isTablet ? 16 : 11),
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
                                    isTablet ? 16 : 11),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                textSwitch("""Соглашаюсь на обработку 
персональных данных""", isTablet ? 16 : 11),
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
                                    onButton: () {},
                                  ),
                                ),
                              ],
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
                              FocusManager.instance.primaryFocus?.unfocus();
                              List<String> date =
                                  dateRangeController.selectedDate != null
                                      ? dateRangeController.selectedDate!
                                          .toIso8601String()
                                          .split("T")[0]
                                          .split("-")
                                      : ["", "", ""];
                              toSignUp(
                                lastname: familiyaTextEditingController.text,
                                firstname: imyaTextEditingController.text,
                                email: emailTextFielController.text,
                                bornedAt: "${date[2]}.${date[1]}.${date[0]}",
                                jobId: doljnostTextFieldController.text,
                                storeId: nazvaniyaTextFieldController.text,
                                shopnet: newShop.getNewShop.toString(),
                                shopadress:
                                    adresTorgoviySetTextFielController.text,
                                phone: phoneTextFieldController.text,
                                cityId: gorodTextFieldController.text,
                                isAgreeSms: secondToggle.text,
                                isAgreeIdentity: thirdToggle.text,
                                isAgreePersonal: fourthToggle.text,
                                providerFlip: providerFlip,
                              );

                              log(familiyaTextEditingController.text + "last");
                              log(imyaTextEditingController.text + "first");
                              log(emailTextFielController.text + "email");
                              log("${date[2]}.${date[1]}.${date[0]}bornedat");
                              log(doljnostTextFieldController.text + "jobid");
                              log(nazvaniyaTextFieldController.text +
                                  "storeid");
                              log(newShop.getNewShop.toString() + "shopnet");
                              log(adresTorgoviySetTextFielController.text +
                                  "shop adress");
                              log(phoneTextFieldController.text + "phone");
                              log(gorodTextFieldController.text + "cityid");
                              log(secondToggle.text + "isagreesms");
                              log(thirdToggle.text + "isagreeidenty");
                              log(fourthToggle.text + "isagreepersonal");
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
                                    fontSize: isTablet ? 18 : 12,
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
                      style: TextStyle(fontSize: 11, color: Color(0xFF989a9d)),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      "Support@hansa-lab.ru",
                      style: GoogleFonts.montserrat(
                          fontSize: 11,
                          color: const Color(0xFF989a9d),
                          fontWeight: FontWeight.w700),
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
    if (bornedAt.length < 3) setState(() => dateIsEmpty = true);
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
        shopadress.isNotEmpty) {
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
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Проверьте корректность заполненных данных"),
            backgroundColor: Color.fromARGB(255, 213, 0, 50),
          ));
        } else {
          providerFlip['signin']!.toggleCard();
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
}
