import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/api_models.dart/store_model.dart';
import 'package:hansa_lab/api_services/store_service.dart';
import 'package:hansa_lab/blocs/bloc_popup_drawer.dart';
import 'package:hansa_lab/providers/new_shop_provider.dart';
import 'package:provider/provider.dart';

class PopupFullRegistrNazvaniySeti extends StatefulWidget {
  final Color borderColor;
  final Color hintColor;
  final VoidCallback onTap;
  const PopupFullRegistrNazvaniySeti(
      {Key? key,
      required this.borderColor,
      required this.hintColor,
      required this.onTap})
      : super(key: key);

  @override
  State<PopupFullRegistrNazvaniySeti> createState() =>
      _PopupFullRegistrNazvaniySetiState();
}

class _PopupFullRegistrNazvaniySetiState
    extends State<PopupFullRegistrNazvaniySeti> {
  final streamController = StreamController<List<StoreModelData>>.broadcast();

  final blocPopupDrawer = BlocPopupDrawer();
  double radius = 54;
  String text = "Названия сети";
  final newShopText = TextEditingController(text: "");
  final textEditingController = TextEditingController();

  List<StoreModelData> all = [];
  List<StoreModelData> one = [];

  listen() {
    streamController.stream.listen((event) {
      if (textEditingController.text.isEmpty) {
        all = event;
        one = all;
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
    final blocStoreData = StoreData();
    blocStoreData.eventSink.add(StoreEnum.store);
    final nazvanieTextEditingController =
        Provider.of<TextEditingController>(context);

    final providerStreamController =
        Provider.of<StreamController<bool>>(context);

    return StreamBuilder<double>(
        initialData: isTablet ? 40 : 38,
        stream: blocPopupDrawer.dataStream,
        builder: (context, snapshotSizeDrawer) {
          return InkWell(
            onTap: () {
              widget.onTap();
              blocPopupDrawer.dataSink
                  .add(snapshotSizeDrawer.data! == (isTablet ? 40 : 38)
                      ? 283
                      : isTablet
                          ? 40
                          : 38);
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
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            text,
                            style: text == "Названия сети"
                                ? GoogleFonts.montserrat(
                                    fontSize: isTablet ? 13 : 10,
                                    color: widget.hintColor)
                                : GoogleFonts.montserrat(
                                    fontSize: isTablet ? 13 : 10,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                          ),
                        ),
                      ),
                      StreamBuilder<StoreModel>(
                          stream: blocStoreData.stream,
                          builder: (context, snapshotStore) {
                            if (snapshotStore.hasData) {
                              streamController.sink
                                  .add(snapshotStore.data!.data.list);

                              return Visibility(
                                visible: radius == 54 ? false : true,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
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
                                    TextButton(
                                      onPressed: () {
                                        providerStreamController.sink.add(true);
                                        nazvanieTextEditingController.text =
                                            "Другое";
                                        text = "Другое";

                                        blocPopupDrawer.dataSink.add(
                                            snapshotSizeDrawer.data! == 38
                                                ? 200
                                                : 38);
                                        radius = radius == 54 ? 10 : 54;
                                      },
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Другое",
                                          style: TextStyle(
                                              color: widget.hintColor,
                                              fontSize: 10),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 160,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: ListView.builder(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemCount: one.length,
                                          padding: const EdgeInsets.all(0),
                                          itemBuilder: (context, index) {
                                            final nazvanSeti = one[index];
                                            return TextButton(
                                              onPressed: () {
                                                providerStreamController.sink
                                                    .add(false);

                                                nazvanieTextEditingController
                                                        .text =
                                                    nazvanSeti.id.toString();
                                                text = nazvanSeti.name;

                                                blocPopupDrawer.dataSink.add(
                                                    snapshotSizeDrawer.data! ==
                                                            38
                                                        ? 200
                                                        : 38);
                                                radius = radius == 54 ? 10 : 54;
                                              },
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  nazvanSeti.name,
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
          );
        });
  }

  void search(String query) {
    final suggestions = all.where((nazvan) {
      final nazvanName = nazvan.name.toLowerCase();
      final input = query.toLowerCase();
      return nazvanName.startsWith(input) || nazvanName.contains(input);
    }).toList();

    setState(() {
      one = suggestions;
    });
  }
}
