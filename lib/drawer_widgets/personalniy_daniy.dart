
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
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PersonalniyDaniy extends StatefulWidget {
  const PersonalniyDaniy({Key? key}) : super(key: key);

  @override
  State<PersonalniyDaniy> createState() => _PersonalniyDaniyState();
}

class _PersonalniyDaniyState extends State<PersonalniyDaniy> {
  TextEditingController imyaController = TextEditingController();
  TextEditingController familyaController = TextEditingController();
  TextEditingController dataRojController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telefonController = TextEditingController();
  TextEditingController magazinController = TextEditingController();
  TextEditingController doljnostController = TextEditingController();
  TextEditingController gorodController = TextEditingController();
  TextEditingController adresController = TextEditingController();
  DateRangePickerController dateRangePickerController =
      DateRangePickerController();
  final blocDateBorn = DateBornTextBloC();

  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    final providerToken = Provider.of<String>(context);

    final blocPersonal = BlocPersonal();

    final personalInfoEditTextFieldsProvider =
        Provider.of<ProviderPersonalTextFields>(context);
    final providerSendDataPersonalUpdate =
        Provider.of<SendDataPersonalUpdate>(context);

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
}
