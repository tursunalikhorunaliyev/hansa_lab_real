import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/api_models.dart/country_model.dart';
import 'package:hansa_lab/blocs/bloc_popup_drawer.dart';
import 'package:hansa_lab/blocs/hansa_country_api.dart';
import 'package:provider/provider.dart';

class PopupFullRegistrGorod extends StatefulWidget {
  final Color borderColor;
  final Color hintColor;
  final VoidCallback onTap;
  const PopupFullRegistrGorod(
      {Key? key,
      required this.borderColor,
      required this.hintColor,
      required this.onTap})
      : super(key: key);

  @override
  State<PopupFullRegistrGorod> createState() => _PopupFullRegistrGorodState();
}

class _PopupFullRegistrGorodState extends State<PopupFullRegistrGorod> {
  TextEditingController textEditingController = TextEditingController();
  final streamController = StreamController<List<CountryModelData>>.broadcast();

  final blocPopupDrawer = BlocPopupDrawer();

  List<CountryModelData> allCities = [];
  List<CountryModelData> cities = [];

  double radius = 54;
  String text = "Город";

  listen() {
    streamController.stream.listen((event) {
      if (textEditingController.text.isEmpty) {
        allCities = event;
        cities = allCities;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    listen();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    final blocHansaCountry = HansaCountryBloC(1);

    blocHansaCountry.eventSink.add(CityEnum.city);

    final gorodTextEditingContyroller =
        Provider.of<TextEditingController>(context);

    return StreamBuilder<double>(
        initialData: isTablet ? 40  : 38,
        stream: blocPopupDrawer.dataStream,
        builder: (context, snapshotSizeDrawer) {
          return InkWell(
            onTap: () {
              widget.onTap();
              blocPopupDrawer.dataSink
                  .add(snapshotSizeDrawer.data! == (isTablet ? 40  : 38) ? (isTablet ? 280  : 250) : (isTablet ? 40  : 38));
              radius = radius == 54 ? 10 : 54;
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 11, right: 9),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                height: isTablet
                    ? snapshotSizeDrawer.data!
                    : snapshotSizeDrawer.data!,
                width: isTablet ? double.infinity : 360,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(radius),
                  border: Border.all(
                      width: widget.borderColor ==
                              const Color.fromARGB(255, 213, 0, 50)
                          ? 0.9
                          : 0.1,
                      color: widget.borderColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 12),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                text,
                                style: text == "Город"
                                    ? GoogleFonts.montserrat(
                                        fontSize: isTablet ? 13 : 10,
                                        color: widget.hintColor)
                                    : GoogleFonts.montserrat(
                                        fontSize: isTablet ? 13 : 10,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                              )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        StreamBuilder<CountryModel>(
                            stream: blocHansaCountry.stream,
                            builder: (context, snapshotCountry) {
                              if (snapshotCountry.hasData) {
                                streamController.sink
                                    .add(snapshotCountry.data!.data.list);
                                return Visibility(
                                  visible: radius == 54 ? false : true,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 40,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10, top: 5),
                                          child: TextField(
                                            style: const TextStyle(fontSize: 13),
                                            controller: textEditingController,
                                            onChanged: (value) => search(value),
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 10),
                                                hintText: "Поиск",
                                                hintStyle:
                                                    const TextStyle(fontSize: 13),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10))),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        height: 165,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemCount: cities.length,
                                            padding: const EdgeInsets.all(0),
                                            itemBuilder: (context, index) {
                                              final book = cities[index];
                                              return InkWell(
                                                onTap: () {
                                                  gorodTextEditingContyroller
                                                      .text = book.id.toString();
                                                  text = book.name;
                                                  blocPopupDrawer.dataSink.add(
                                                      snapshotSizeDrawer.data! ==
                                                              38
                                                          ? (isTablet ? 280  : 250)
                                                          : 38);
                                                  radius = radius == 54 ? 10 : 54;
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Text(
                                                    book.name,
                                                    textScaleFactor: 1.0,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            })
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void search(String query) {
    final suggestions = allCities.where((city) {
      final cityName = city.name.toLowerCase();
      final input = query.toLowerCase();
      return cityName.startsWith(input) || cityName.contains(input);
    }).toList();

    setState(() {
      cities = suggestions;
    });
  }
}
