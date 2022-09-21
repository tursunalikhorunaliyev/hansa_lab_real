import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:hansa_lab/api_models.dart/model_glavniy_menu_user_info.dart';
import 'package:hansa_lab/blocs/bloc_change_profile.dart';
import 'package:hansa_lab/blocs/bloc_glavniy_menu_user_info.dart';
import 'package:hansa_lab/blocs/menu_events_bloc.dart';
import 'package:hansa_lab/classes/send_data_personal_update.dart';
import 'package:hansa_lab/classes/tap_favorite.dart';
import 'package:hansa_lab/drawer_widgets/drawer_stats.dart';
import 'package:hansa_lab/drawer_widgets/izbrannoe.dart';
import 'package:hansa_lab/drawer_widgets/nastroyka_widget.dart';
import 'package:hansa_lab/drawer_widgets/personalniy_daniy.dart';
import 'package:hansa_lab/drawer_widgets/referal_silka.dart';
import 'package:hansa_lab/drawer_widgets/text_icon.dart';
import 'package:hansa_lab/drawer_widgets/text_icon_card.dart';
import 'package:hansa_lab/enums/enum_action_view.dart';
import 'package:hansa_lab/extra/exit_account_dialog.dart';
import 'package:hansa_lab/extra/sobshit_o_problem.dart';
import 'package:hansa_lab/providers/fullname_provider.dart';
import 'package:hansa_lab/providers/provider_otpravit_rassilku.dart';
import 'package:hansa_lab/providers/provider_personal_textFields.dart';

class GlavniyMenyu extends StatefulWidget {
  const GlavniyMenyu({Key? key}) : super(key: key);

  @override
  State<GlavniyMenyu> createState() => _GlavniyMenyuState();
}

class _GlavniyMenyuState extends State<GlavniyMenyu> {
  GlobalKey<ScaffoldState> keyScaffold = GlobalKey();

  bool isFavourite = false;
  setFavourite(favourite) {
    setState(() {
      isFavourite = favourite;
    });
  }

  Future<dynamic> uploadImage({required String token}) async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    File file = File(image!.path);
    Dio dio = Dio();

    if (file == null) {
      log("File is null");
      return;
    } else {
      String fileName = file.path.split("/").last.substring(12);
      log(file.path);
      log(fileName);
      FormData formData = FormData.fromMap({
        "ProfileForm[imageFile]": await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: MediaType('image', 'png'),
          headers: {
            "type": ["image/png"],
          },
        ),
      });
      var response = await dio.post(
        "https://hansa-lab.ru/api/site/account-image",
        data: formData,
        options: Options(
          headers: {
            "accept": "*/*",
            "token": token,
            "Content-Type": "multipart/form-data",
          },
        ),
      );
      log("${response.statusMessage} - ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final blocChangeProfileProvider = Provider.of<BlocChangeProfile>(context);
    final isTablet = Provider.of<bool>(context);
    final providerToken = Provider.of<String>(context);
    final providerPersonalDannieTextFilelds =
        Provider.of<ProviderPersonalTextFields>(context);

    final menuProvider = Provider.of<MenuEventsBloC>(context);
    final providerTapFavorite = Provider.of<TapFavorite>(context);
    final fullname = Provider.of<FullnameProvider>(context);
    final blocGlavniyMenuUserInfo = BlocGlavniyMenuUserInfo(providerToken);

    blocGlavniyMenuUserInfo.eventSink.add(EnumActionView.view);
    final scafforlKeyProvider = Provider.of<GlobalKey<ScaffoldState>>(context);
    final providerSendDataPersonalUpdate =
        Provider.of<SendDataPersonalUpdate>(context);

    return Drawer(
      backgroundColor: const Color(0xFF333333),
     // width: isTablet ? 435 : 326,
      child: Column(
        children: [
          Container(
            height: isTablet ? 400 : 283,
            width: isTablet ? 450 : 324,
            decoration: const BoxDecoration(color: Color(0xFF333333)),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: isTablet ? 70 : 52, left: isTablet ? 40 : 26),
                  child: Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF2d2d2d),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                      shape: BoxShape.circle,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        menuProvider.eventSink.add(MenuActions.welcome);
                        scafforlKeyProvider.currentState!.closeDrawer();
                      },
                      child: Image.asset(
                        "assets/192.png",
                        height: isTablet ? 60 : 46,
                        width: isTablet ? 60 : 46,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: isTablet ? 60 : 39, left: isTablet ? 160 : 120),
                  child: SizedBox(
                    height: isTablet ? 100 : 80,
                    width: isTablet ? 100 : 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: StreamBuilder<ModelGlavniyMenuUserInfoMain>(
                          stream: blocGlavniyMenuUserInfo.dataStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return CachedNetworkImage(
                                imageUrl: snapshot.data!.data.link,
                                fit: BoxFit.fill,
                                placeholder: (context, url) {
                                  return const CircularProgressIndicator(
                                    color: Color.fromARGB(255, 213, 0, 50),
                                  );
                                },
                              );
                            } else {
                              return const CircularProgressIndicator(
                                color: Color.fromARGB(255, 213, 0, 50),
                              );
                            }
                          }),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    uploadImage(token: providerToken).then((value) {
                      blocGlavniyMenuUserInfo.eventSink
                          .add(EnumActionView.view);
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: isTablet ? 125 : 100,
                      left: isTablet ? 240 : 175,
                    ),
                    child: Container(
                      height: isTablet ? 33 : 26,
                      width: isTablet ? 33 : 26,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 213, 0, 50),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: const Color(0xFFffffff),
                        size: isTablet ? 20 : 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: isTablet ? 70 : 52, left: isTablet ? 320 : 247),
                  child: StreamBuilder<ActionChange>(
                      initialData: ActionChange.textIconCard,
                      stream: blocChangeProfileProvider.dataStream,
                      builder: (context, snapshot) {
                        return GestureDetector(
                          onTap: () {
                            snapshot.data == ActionChange.izboreny ||
                                    providerTapFavorite.getInt == 1
                                ? blocChangeProfileProvider.dataSink
                                    .add(ActionChange.textIconCard)
                                : blocChangeProfileProvider.dataSink
                                    .add(ActionChange.izboreny);
                            providerTapFavorite.setInt(0);
                          },
                          child: Container(
                            height: isTablet ? 60 : 46,
                            width: isTablet ? 60 : 46,
                            decoration: const BoxDecoration(
                              color: Color(0xFF686868),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF2d2d2d),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.favorite,
                              color: const Color(0xFFffffff),
                              size: isTablet ? 40 : 20,
                            ),
                          ),
                        );
                      }),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: StreamBuilder<ModelGlavniyMenuUserInfoMain>(
                        stream: blocGlavniyMenuUserInfo.dataStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            fullname.setName(snapshot.data!.data.fullname);
                            return Text(
                              snapshot.data!.data.fullname,
                              style: TextStyle(
                                  fontSize: isTablet ? 23 : 16,
                                  color: const Color(0xFFffffff)),
                            );
                          } else {
                            return const Center(
                              child: Text(
                                "Загрузка..",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            );
                          }
                        }),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: isTablet ? 245 : 165,
                  ),
                  child: StreamBuilder<ModelGlavniyMenuUserInfoMain>(
                      stream: blocGlavniyMenuUserInfo.dataStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                snapshot.data!.data.score.toString(),
                                style: GoogleFonts.montserrat(
                                    fontSize: isTablet ? 30 : 23,
                                    color:
                                        const Color.fromARGB(255, 213, 0, 50),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                ),
                Padding(
                  padding: EdgeInsets.only(top: isTablet ? 280 : 190),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "баллов",
                        style: GoogleFonts.montserrat(
                            fontSize: isTablet ? 20 : 16,
                            color: const Color(0xFFffffff),
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: isTablet ? 320 : 220, left: isTablet ? 118 : 90),
                  child: StreamBuilder<ActionChange>(
                      initialData: providerTapFavorite.getInt == 2
                          ? ActionChange.personal
                          : ActionChange.textIconCard,
                      stream: blocChangeProfileProvider.dataStream,
                      builder: (context, snapshot) {
                        log(snapshot.data!.name);
                        return GestureDetector(
                          onTap: () {
                            if (snapshot.data == ActionChange.personal) {
                              getData(
                                  providerToken,
                                  providerPersonalDannieTextFilelds
                                      .getImyaController.text,
                                  providerPersonalDannieTextFilelds
                                      .getFamiliyaController.text,
                                  providerPersonalDannieTextFilelds
                                      .getDataRojdeniyaController.text,
                                  providerPersonalDannieTextFilelds
                                      .getTelefonController.text,
                                  "1",
                                  providerSendDataPersonalUpdate.getGorodId
                                      .toString(),
                                  providerSendDataPersonalUpdate.getDoljnostId
                                      .toString(),
                                  providerSendDataPersonalUpdate.getMagazinId
                                      .toString(),
                                  providerPersonalDannieTextFilelds
                                      .getAddressController.text);
                              log(providerPersonalDannieTextFilelds
                                  .getDataRojdeniyaController.text);
                              blocGlavniyMenuUserInfo.eventSink
                                  .add(EnumActionView.view);
                            }

                            snapshot.data == ActionChange.personal
                                ? blocChangeProfileProvider.dataSink
                                    .add(ActionChange.textIconCard)
                                : blocChangeProfileProvider.dataSink
                                    .add(ActionChange.personal);

                            if (snapshot.data == ActionChange.nastroyka) {
                              blocChangeProfileProvider.dataSink
                                  .add(ActionChange.textIconCard);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: isTablet ? 40 : 30,
                            width: isTablet ? 200 : 140,
                            decoration: BoxDecoration(
                              color: snapshot.data == ActionChange.textIconCard
                                  ? const Color.fromARGB(255, 213, 0, 50)
                                  : snapshot.data == ActionChange.izboreny
                                      ? const Color.fromARGB(255, 213, 0, 50)
                                      : snapshot.data == ActionChange.statistik
                                          ? const Color.fromARGB(
                                              255, 213, 0, 50)
                                          : const Color(0xFF25b049),
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
                              snapshot.data == ActionChange.textIconCard
                                  ? "Редактировать"
                                  : snapshot.data == ActionChange.izboreny
                                      ? "Редактировать"
                                      : snapshot.data == ActionChange.statistik
                                          ? "Редактировать"
                                          : "Сохранить",
                              style: GoogleFonts.montserrat(
                                  fontSize: isTablet ? 16 : 12,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFFffffff)),
                            ),
                          ),
                        );
                      }),
                ),
                StreamBuilder<ActionChange>(
                  initialData: providerTapFavorite.getInt == 1
                      ? ActionChange.izboreny
                      : providerTapFavorite.getInt == 2
                          ? ActionChange.personal
                          : ActionChange.textIconCard,
                  stream: blocChangeProfileProvider.dataStream,
                  builder: (context, snapshot) {
                    return Visibility(
                      visible: snapshot.data == ActionChange.personal
                          ? true
                          : snapshot.data == ActionChange.izboreny
                              ? true
                              : snapshot.data == ActionChange.statistik
                                  ? true
                                  : snapshot.data == ActionChange.nastroyka
                                      ? true
                                      : false,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: isTablet ? 55 : 45,
                            top: isTablet ? 320 : 220),
                        child: GestureDetector(
                          onTap: () {
                            if (snapshot.data == ActionChange.izboreny) {
                              blocChangeProfileProvider.dataSink
                                  .add(ActionChange.textIconCard);
                            }
                            if (snapshot.data == ActionChange.personal) {
                              blocChangeProfileProvider.dataSink
                                  .add(ActionChange.textIconCard);
                            }
                            if (snapshot.data == ActionChange.statistik) {
                              blocChangeProfileProvider.dataSink
                                  .add(ActionChange.textIconCard);
                            }
                            if (snapshot.data == ActionChange.nastroyka) {
                              blocChangeProfileProvider.dataSink
                                  .add(ActionChange.textIconCard);
                            }
                          },
                          child: Container(
                            height: isTablet ? 40 : 30,
                            width: isTablet ? 40 : 30,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF25b049)),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Image.asset(
                                  "assets/free-icon-right-arrow-152352.png"),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),

/////////////////////////////////////menu
          StreamBuilder<ActionChange>(
              initialData: providerTapFavorite.getInt == 1
                  ? ActionChange.izboreny
                  : providerTapFavorite.getInt == 2
                      ? ActionChange.personal
                      : ActionChange.textIconCard,
              stream: blocChangeProfileProvider.dataStream,
              builder: (context, snapshot) {
                return Expanded(
                  child: Container(
                    decoration: const BoxDecoration(color: Color(0xFF2c2c2c)),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(
                          top: snapshot.data == ActionChange.izboreny ||
                                  snapshot.data == ActionChange.statistik
                              ? 0
                              : 30,
                          bottom: 20),
                      child: Column(
                        children: List.generate(
                          1,
                          (index) => Column(
                            children: [
                              snapshot.data == ActionChange.izboreny
                                  ? Wrap(
                                      children: [
                                        const Izbrannoe(),
                                        SizedBox(
                                          height: isTablet ? 700 : 509,
                                        ),
                                        const ReferalSilka(),
                                      ],
                                    )
                                  : snapshot.data == ActionChange.personal
                                      ? const PersonalniyDaniy()
                                      : snapshot.data == ActionChange.statistik
                                          ? Wrap(children: [
                                              const DrawerStats(),
                                              SizedBox(
                                                height: isTablet ? 600 : 460,
                                              ),
                                              const ReferalSilka()
                                            ])
                                          : snapshot.data ==
                                                  ActionChange.nastroyka
                                              ? ChangeNotifierProvider(
                                                  create: (context) =>
                                                      ProviderOtpravitRassilku(),
                                                  child:
                                                      const NastroykaWidget())
                                              : const Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 39),
                                                  child: TextIconCard(),
                                                ),
                              snapshot.data == ActionChange.personal
                                  ? SizedBox(
                                      height: isTablet ? 50 : 69,
                                    )
                                  : snapshot.data == ActionChange.statistik
                                      ? SizedBox(
                                          height: isTablet ? 140 : 30,
                                        )
                                      : SizedBox(
                                          height: isTablet ? 140 : 69,
                                        ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 39,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    blocChangeProfileProvider.dataSink
                                        .add(ActionChange.statistik);
                                  },
                                  child: const TextIcon(
                                    text: "Рейтинг",
                                    iconUrl:
                                        "assets/free-icon-rating-4569150.png",
                                  ),
                                ),
                              ),
                              snapshot.data == ActionChange.nastroyka
                                  ? const SizedBox(
                                      height: 0,
                                    )
                                  : SizedBox(height: isTablet ? 30 : 20),
                              snapshot.data == ActionChange.nastroyka
                                  ? const SizedBox(
                                      height: 0,
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(left: 39),
                                      child: GestureDetector(
                                        onTap: () {
                                          blocChangeProfileProvider.dataSink
                                              .add(ActionChange.nastroyka);
                                        },
                                        child: const TextIcon(
                                          text: "Настройки",
                                          iconUrl: "assets/icon.png",
                                        ),
                                      ),
                                    ),
                              SizedBox(
                                height: isTablet ? 30 : 20,
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    useRootNavigator: false,
                                    builder: (contextDialog) =>
                                        Provider<String>.value(
                                            value: providerToken.toString(),
                                            child: const SobshitOProblem()),
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 33),
                                  child: TextIcon(
                                    text: "Задать вопрос",
                                    iconUrl: "assets/question.png",
                                    size: 30,
                                    widthSize: 18,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: isTablet ? 30 : 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 39),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const ExitAccountDialog(),
                                    );
                                  },
                                  child: const TextIcon(
                                    text: "Выход из акаунта",
                                    iconUrl: "assets/iconiu.png",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> getData(
    String token,
    String firstname,
    String lastname,
    String bornedAt,
    String phone,
    String countryType,
    String cityId,
    String jobId,
    String storeId,
    String shopAddress,
  ) async {
    http.Response response = await http
        .post(Uri.parse("http://hansa-lab.ru/api/site/account"), headers: {
      "token": token
    }, body: {
      "firstname": firstname,
      "lastname": lastname,
      "borned_at": bornedAt,
      "phone": phone,
      "country_type": countryType,
      "city_id": cityId,
      "job_id": jobId,
      "store_id": storeId,
      "shop_address": shopAddress,
    });

    return jsonDecode(response.body);
  }
}
