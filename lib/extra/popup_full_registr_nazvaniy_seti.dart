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
  final blocPopupDrawer = BlocPopupDrawer();
  double radius = 54;
  String text = "Названия сети";
  final newShopText = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    final newShop = Provider.of<NewShopProvider>(context);
    final blocStoreData = StoreData();
    blocStoreData.eventSink.add(StoreEnum.store);
    final nazvanieTextEditingController =
        Provider.of<TextEditingController>(context);

    return StreamBuilder<double>(
        initialData: 38,
        stream: blocPopupDrawer.dataStream,
        builder: (context, snapshotSizeDrawer) {
          return InkWell(
            onTap: () {
              widget.onTap();
              blocPopupDrawer.dataSink
                  .add(snapshotSizeDrawer.data! == 38 ? 250 : 38);
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
                      const SizedBox(
                        height: 10,
                      ),
                      StreamBuilder<StoreModel>(
                          stream: blocStoreData.stream,
                          builder: (context, snapshotStore) {
                            if (snapshotStore.hasData) {
                              return Visibility(
                                visible: (radius > 50) ? false : true,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 40,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10, top: 5),
                                        child: TextField(
                                          style: const TextStyle(fontSize: 13),
                                          controller: newShopText,
                                          decoration: InputDecoration(
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      borderSide: BorderSide(
                                                          color: Colors.green)),
                                              suffixIcon: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                ),
                                                child: MaterialButton(
                                                  onPressed: () {
                                                    if (newShopText
                                                        .text.isNotEmpty) {
                                                      newShop.setNewShop(
                                                          newShopText.text);
                                                      text = newShopText.text;
                                                      nazvanieTextEditingController
                                                          .text = "";
                                                      blocPopupDrawer.dataSink
                                                          .add(snapshotStore
                                                                      .data! ==
                                                                  38
                                                              ? 200
                                                              : 38);
                                                      radius = radius == 54
                                                          ? 10
                                                          : 54;
                                                    }
                                                  },
                                                  height: 30,
                                                  minWidth: 30,
                                                  color: Colors.green,
                                                  child: Text(
                                                    "OK",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontSize: 10,
                                                            color:
                                                                Colors.white),
                                                  ),
                                                ),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 10),
                                              hintText: "Новый",
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
                                      height: 160,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: ListView.builder(
                                          physics: const BouncingScrollPhysics(),
                                          itemCount: snapshotStore
                                              .data!.data.list.length,
                                          padding: const EdgeInsets.all(0),
                                          itemBuilder: (context, index) {
                                            return TextButton(
                                              onPressed: () {
                                                newShop.setNewShop(snapshotStore
                                                    .data!.data.list[index].id
                                                    .toString());

                                                nazvanieTextEditingController
                                                        .text =
                                                    snapshotStore.data!.data
                                                        .list[index].id
                                                        .toString();
                                                text = snapshotStore.data!.data
                                                    .list[index].name;

                                                blocPopupDrawer.dataSink.add(
                                                    snapshotStore.data! == 38
                                                        ? 200
                                                        : 38);
                                                radius = radius == 54 ? 10 : 54;
                                              },
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  snapshotStore.data!.data
                                                      .list[index].name,
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
}
