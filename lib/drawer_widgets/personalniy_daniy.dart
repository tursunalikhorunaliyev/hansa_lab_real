import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/api_models.dart/model_personal.dart';
import 'package:hansa_lab/blocs/bloc_personal.dart';
import 'package:hansa_lab/blocs/data_burn_text_changer_bloc.dart';
import 'package:hansa_lab/classes/send_data_personal_update.dart';
import 'package:hansa_lab/drawer_widgets/popup_personal_doljnost.dart';
import 'package:hansa_lab/drawer_widgets/popup_personal_gorod.dart';
import 'package:hansa_lab/drawer_widgets/popup_personal_magazin.dart';
import 'package:hansa_lab/drawer_widgets/referal_silka.dart';
import 'package:hansa_lab/drawer_widgets/text_field_for_personal.dart';
import 'package:hansa_lab/providers/provider_personal_textFields.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;

import '../blocs/bloc_change_profile.dart';
import '../classes/tap_favorite.dart';

class PersonalniyDaniy extends StatefulWidget {
  const PersonalniyDaniy({Key? key}) : super(key: key);

  @override
  State<PersonalniyDaniy> createState() => _PersonalniyDaniyState();
}

class _PersonalniyDaniyState extends State<PersonalniyDaniy> {
  DateRangePickerController dateRangePickerController =
      DateRangePickerController();
  final blocDateBorn = DateBornTextBloC();

  @override
  Widget build(BuildContext context) {
    final blocChangeProfileProvider = Provider.of<BlocChangeProfile>(context);
    final scrollController = ScrollController();
    final providerPersonalDannieTextFilelds =
        Provider.of<ProviderPersonalTextFields>(context);
    final providerTapFavorite = Provider.of<TapFavorite>(context);
    final isTablet = Provider.of<bool>(context);
    final providerToken = Provider.of<String>(context);
    final blocPersonal = BlocPersonal();
    final personalInfoEditTextFieldsProvider =
        Provider.of<ProviderPersonalTextFields>(context);
    final providerSendDataPersonalUpdate =
        Provider.of<SendDataPersonalUpdate>(context);
    final box = Hive.box("savedUser");
    return Center(
      child: FutureBuilder<ModelPersonalMain>(
          future: blocPersonal.getData(providerToken),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              providerSendDataPersonalUpdate
                  .setMagazinId(snapshot.data!.modelPersonal1.store.id);

              providerSendDataPersonalUpdate
                  .setDoljnostId(snapshot.data!.modelPersonal1.job.id);

              providerSendDataPersonalUpdate
                  .setGorodId(snapshot.data!.modelPersonal1.cityId.id);

              personalInfoEditTextFieldsProvider.imyaController.text =
                  snapshot.data!.modelPersonal1.firstname;

              personalInfoEditTextFieldsProvider.familiyaController.text =
                  snapshot.data!.modelPersonal1.lastname;

              personalInfoEditTextFieldsProvider.dataRojdeniyaController.text =
                  snapshot.data!.modelPersonal1.bornedAt;

              personalInfoEditTextFieldsProvider.gorodController.text =
                  snapshot.data!.modelPersonal1.cityId.name;

              personalInfoEditTextFieldsProvider.addressController.text =
                  snapshot.data!.modelPersonal1.shopAddress;

              personalInfoEditTextFieldsProvider.doljnostController.text =
                  snapshot.data!.modelPersonal1.job.name;

              personalInfoEditTextFieldsProvider.telefonController.text =
                  snapshot.data!.modelPersonal1.phone;

              personalInfoEditTextFieldsProvider.storeName.text =
                  snapshot.data!.modelPersonal1.store.name;

              personalInfoEditTextFieldsProvider.countryTypeId =
                  snapshot.data!.modelPersonal1.countryType.id.toString();

              personalInfoEditTextFieldsProvider.cityId =
                  snapshot.data!.modelPersonal1.cityId.id.toString();

              personalInfoEditTextFieldsProvider.jobId =
                  snapshot.data!.modelPersonal1.job.id.toString();

              personalInfoEditTextFieldsProvider.storeId =
                  snapshot.data!.modelPersonal1.store.id.toString();

              return Column(
                children: [
                  Image.asset(
                    "assets/user_icons.png",
                    height: isTablet ? 50 : 37,
                    width: isTablet ? 50 : 37,
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  Text(
                    "Персональные данные",
                    style: GoogleFonts.montserrat(
                        fontSize: isTablet ? 16 : 13,
                        color: const Color(0xFFffffff)),
                  ),
                  SizedBox(
                    height: isTablet ? 40 : 25,
                  ),
                  TextFieldForPersonal(
                      text: "Имя",
                      controller:
                          personalInfoEditTextFieldsProvider.imyaController),
                  SizedBox(
                    height: isTablet ? 15 : 8,
                  ),
                  TextFieldForPersonal(
                      text: "Фамилия",
                      controller: personalInfoEditTextFieldsProvider
                          .familiyaController),
                  SizedBox(
                    height: isTablet ? 15 : 8,
                  ),
                  //==========================================================================================
                  GestureDetector(
                    onTap: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (context) {
                            return Container(
                                width: 360,
                                height: 400,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: SfDateRangePicker(
                                  controller: dateRangePickerController,
                                  selectionColor: Colors.pink[600],
                                  todayHighlightColor: Colors.pink[600],
                                  onSelectionChanged: (a) {
                                    String day = dateRangePickerController
                                                .selectedDate!.day
                                                .toString()
                                                .length ==
                                            1
                                        ? "0${dateRangePickerController.selectedDate!.day}"
                                        : dateRangePickerController
                                            .selectedDate!.day
                                            .toString();
                                    String month = dateRangePickerController
                                                .selectedDate!.month
                                                .toString()
                                                .length ==
                                            1
                                        ? "0${dateRangePickerController.selectedDate!.month}"
                                        : dateRangePickerController
                                            .selectedDate!.month
                                            .toString();
                                    String year = dateRangePickerController
                                        .selectedDate!.year
                                        .toString();

                                    personalInfoEditTextFieldsProvider
                                        .dataRojdeniyaController
                                        .text = "$year.$month.$day";

                                    blocDateBorn.streamSink
                                        .add("$year.$month.$day");
                                    Navigator.pop(context);
                                  },
                                ));
                          });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: isTablet ? 45 : 36,
                      width: isTablet ? 350 : 269,
                      decoration: BoxDecoration(
                          color: const Color(0xFF000000),
                          borderRadius: BorderRadius.circular(54)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Дата рождения",
                              style: GoogleFonts.montserrat(
                                  fontSize: isTablet ? 13 : 10,
                                  color: const Color(0xFF767676)),
                            ),
                            StreamBuilder<String>(
                                initialData: personalInfoEditTextFieldsProvider
                                    .dataRojdeniyaController.text,
                                stream: blocDateBorn.stream,
                                builder: (context, snapshot) {
                                  return Text(
                                    snapshot.data!,
                                    style: GoogleFonts.montserrat(
                                        color: const Color(0xFFffffff),
                                        fontSize: isTablet ? 13 : 10),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //=================================================================================================================
                  SizedBox(
                    height: isTablet ? 15 : 8,
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: AbsorbPointer(
                      absorbing: true,
                      child: (TextFieldForPersonal(
                          text: "E-mail",
                          controller: TextEditingController(
                              text: snapshot.data!.modelPersonal1.email))),
                    ),
                  ),
                  SizedBox(
                    height: isTablet ? 15 : 8,
                  ),
                  TextFieldForPersonal(
                      text: "Телефон",
                      keyboardType: TextInputType.phone,
                      controller:
                          personalInfoEditTextFieldsProvider.telefonController),
                  SizedBox(
                    height: isTablet ? 15 : 8,
                  ),
                  PopupPersonalMagazin(
                    controller: personalInfoEditTextFieldsProvider.storeName,
                  ),
                  SizedBox(
                    height: isTablet ? 15 : 8,
                  ),
                  PopupPersonalDoljnost(
                    controller:
                        personalInfoEditTextFieldsProvider.doljnostController,
                  ),
                  SizedBox(
                    height: isTablet ? 15 : 8,
                  ),
                  PopupPersonalGorod(
                      controller:
                          personalInfoEditTextFieldsProvider.gorodController),
                  SizedBox(
                    height: isTablet ? 15 : 8,
                  ),
                  TextFieldForPersonal(
                      text: "Адрес",
                      controller:
                          personalInfoEditTextFieldsProvider.addressController),
                  SizedBox(
                    height: isTablet ? 50 : 10,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: isTablet ? 40 : 10),
                    child: const ReferalSilka(),
                  ),
                  SizedBox(
                    height: isTablet ? 50 : 10,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(right: isTablet ? 60 : 120),
                        child: const Text(
                          'Изменить Пароль',
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                  SizedBox(
                    height: isTablet ? 50 : 10,
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: AbsorbPointer(
                      absorbing: true,
                      child: (TextFieldForPersonal(
                          hintText: "- Текущий пароль",
                          text: box.get("password"),
                          controller: personalInfoEditTextFieldsProvider
                              .oldPasswordController)),
                    ),
                  ),
                  SizedBox(
                    height: isTablet ? 50 : 8,
                  ),
                  AbsorbPointer(
                    absorbing: providerPersonalDannieTextFilelds.isEdit,
                    child: TextFieldForPersonal(
                        text: "Новый пароль",
                        controller: personalInfoEditTextFieldsProvider
                            .newPasswordController),
                  ),
                  SizedBox(
                    height: isTablet ? 20 : 8,
                  ),
                  AbsorbPointer(
                    absorbing: providerPersonalDannieTextFilelds.isEdit,
                    child: TextFieldForPersonal(
                        text: "Повторно введите новый пароль",
                        controller: personalInfoEditTextFieldsProvider
                            .newRePasswordController),
                  ),
                  SizedBox(
                    height: isTablet ? 20 : 2,
                  ),
                  if (!providerPersonalDannieTextFilelds.isEdit &&
                      providerPersonalDannieTextFilelds.errorText.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(
                          top: isTablet ? 40 : 0, left: isTablet ? 40 : 20),
                      child: Text(
                        providerPersonalDannieTextFilelds.errorText,
                        style: const TextStyle(color: Colors.red, fontSize: 10),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: isTablet ? 50 : 10,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: isTablet ? 40 : 0, left: isTablet ? 40 : 20),
                    child: StreamBuilder<ActionChange>(
                        initialData: ActionChange.personal,
                        stream: blocChangeProfileProvider.dataStream,
                        builder: (context, snapshot) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (providerPersonalDannieTextFilelds
                                        .getPasswordController.text.isEmpty ||
                                    providerPersonalDannieTextFilelds
                                        .getRePasswordController.text.isEmpty) {
                                  providerPersonalDannieTextFilelds
                                      .getPasswordController
                                      .clear();
                                  providerPersonalDannieTextFilelds
                                      .getRePasswordController
                                      .clear();
                                  providerPersonalDannieTextFilelds.errorText =
                                      '';
                                  providerPersonalDannieTextFilelds.isEdit =
                                      !providerPersonalDannieTextFilelds.isEdit;
                                } else if (providerPersonalDannieTextFilelds
                                        .getPasswordController
                                        .text
                                        .isNotEmpty &&
                                    providerPersonalDannieTextFilelds
                                        .getRePasswordController
                                        .text
                                        .isNotEmpty) {
                                  if (!providerPersonalDannieTextFilelds
                                      .isEdit) {
                                    if (providerPersonalDannieTextFilelds
                                            .getPasswordController.text ==
                                        providerPersonalDannieTextFilelds
                                            .getRePasswordController.text) {
                                      if (providerPersonalDannieTextFilelds
                                              .getPasswordController
                                              .text
                                              .isNotEmpty &&
                                          providerPersonalDannieTextFilelds
                                                  .getPasswordController
                                                  .text
                                                  .length >=
                                              6) {
                                        snapshot.data == ActionChange.personal
                                            ? blocChangeProfileProvider.dataSink
                                                .add(ActionChange.textIconCard)
                                            : blocChangeProfileProvider.dataSink
                                                .add(ActionChange.personal);
                                        if (snapshot.data ==
                                            ActionChange.personal) {
                                          scrollController.animateTo(0,
                                              duration: const Duration(
                                                  milliseconds: 400),
                                              curve: Curves
                                                  .fastLinearToSlowEaseIn);
                                          editPassword(
                                              providerToken,
                                              providerPersonalDannieTextFilelds
                                                  .getRePasswordController
                                                  .text);
                                          Hive.box("savedUser").put(
                                              "password",
                                              providerPersonalDannieTextFilelds
                                                  .getRePasswordController
                                                  .text);
                                          Hive.box("keyChain").put(
                                              "password",
                                              providerPersonalDannieTextFilelds
                                                  .getRePasswordController
                                                  .text);
                                          providerPersonalDannieTextFilelds
                                              .getPasswordController.text = '';
                                          providerPersonalDannieTextFilelds
                                              .getRePasswordController
                                              .text = '';
                                          providerPersonalDannieTextFilelds
                                              .errorText = '';
                                          providerPersonalDannieTextFilelds
                                              .isEdit = true;
                                        }
                                      } else if (providerPersonalDannieTextFilelds
                                              .getPasswordController
                                              .text
                                              .isEmpty ||
                                          providerPersonalDannieTextFilelds
                                                  .getPasswordController
                                                  .text
                                                  .length <
                                              6) {
                                        providerPersonalDannieTextFilelds
                                                .errorText =
                                            "Пароль должен содержать не менее 6 символов";
                                      }
                                    } else if (providerPersonalDannieTextFilelds
                                            .getPasswordController.text !=
                                        providerPersonalDannieTextFilelds
                                            .getRePasswordController.text) {
                                      providerPersonalDannieTextFilelds
                                              .errorText =
                                          'Введен неправильный пароль';
                                    }
                                  }
                                }
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: isTablet ? 40 : 30,
                              width: isTablet ? 200 : 140,
                              decoration: BoxDecoration(
                                color: !providerPersonalDannieTextFilelds.isEdit
                                    ? const Color(0xFFBDBDBD)
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(70),
                                boxShadow: [
                                  BoxShadow(
                                    color: isTablet
                                        ? const Color(0xFF2c2c2c)
                                        : const Color(0xFF333333)
                                            .withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Text(
                                !providerPersonalDannieTextFilelds.isEdit
                                    ? "Сохранить"
                                    : "Изменить",
                                style: GoogleFonts.montserrat(
                                    fontSize: isTablet ? 16 : 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFFffffff)),
                              ),
                            ),
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: isTablet ? 80 : 40,
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: SpinKitPulse(
                  color: Colors.white,
                ),
              );
            }
          }),
    );
  }

  Future<String> editPassword(
    String token,
    String newPassword,
  ) async {
    http.Response response = await http.post(
        Uri.parse("https://hansa-lab.ru/api/auth/change-password"),
        headers: {
          "token": token
        },
        body: {
          "new_password": newPassword,
        });
    return jsonEncode(response.body);
  }
}
