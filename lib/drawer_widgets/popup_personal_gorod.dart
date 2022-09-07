import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/api_models.dart/model_gorod.dart';
import 'package:hansa_lab/blocs/bloc_gorod.dart';
import 'package:hansa_lab/blocs/bloc_popup_drawer.dart';
import 'package:hansa_lab/classes/send_data_personal_update.dart';
import 'package:hansa_lab/enums/enum_action_view.dart';
import 'package:provider/provider.dart';

class PopupPersonalGorod extends StatefulWidget {
  final TextEditingController controller;

  const PopupPersonalGorod({Key? key, required this.controller}) : super(key: key);

  @override
  State<PopupPersonalGorod> createState() => _PopupPersonalGorodState();
}

class _PopupPersonalGorodState extends State<PopupPersonalGorod> {
  final blocPopupDrawer = BlocPopupDrawer();

  double radius = 54;
  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    final providerToken = Provider.of<String>(context);
        final providerSendDataPersonalUpdate =
        Provider.of<SendDataPersonalUpdate>(context);

    final blocGorod = BlocGorod(providerToken);

    blocGorod.eventSink.add(EnumActionView.view);
    return StreamBuilder<double>(
        initialData: isTablet ? 45  : 36,
        stream: blocPopupDrawer.dataStream,
        builder: (context, snapshot) {
          return InkWell(
            onTap: () {
              blocPopupDrawer.dataSink.add(snapshot.data! == (isTablet ? 45 : 36) ? 200 : (isTablet ? 45 : 36));
              radius = radius == 54 ? 10 : 54;
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              height: isTablet ? snapshot.data! : snapshot.data!,
              width: isTablet ? 350 : 269,
              decoration: BoxDecoration(
                  color: const Color(0xFF000000),
                  borderRadius: BorderRadius.circular(radius)),
              child: Padding(
                padding:  EdgeInsets.all(isTablet ? 14  : 11),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Город",
                            style: GoogleFonts.montserrat(
                                fontSize: isTablet ? 13 : 10,
                                color: const Color(0xFF767676)),
                          ),
                          Text(
                            widget.controller.text,
                            style: GoogleFonts.montserrat(
                                color: const Color(0xFFffffff), fontSize: isTablet ? 13  : 10),
                          )
                        ],
                      ),
                    ),
                    StreamBuilder<ModelGorodMain>(
                        stream: blocGorod.dataStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Expanded(
                              child: Visibility(
                                visible: radius == 54 ? false : true,
                                child: ListView.builder(
                                  itemCount:
                                      snapshot.data!.modelGorod2.list.length,
                                  itemBuilder: (context, index) {
                                    return MaterialButton(
                                      onPressed: () {
                                        providerSendDataPersonalUpdate.setGorodId(snapshot
                                            .data!.modelGorod2.list[index].id);
                                        widget.controller.text = snapshot
                                            .data!.modelGorod2.list[index].name;
                                        blocPopupDrawer.dataSink.add(
                                            snapshot.data! == (isTablet ? 45 : 36) ? 200 : (isTablet ? 45 : 36));
                                        radius = radius == 54 ? 10 : 54;
                                      },
                                      height: 30,
                                      minWidth: 10,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          snapshot.data!.modelGorod2.list[index]
                                              .name,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                        ),
                                      ),
                                    );
                                  },
                                ),
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
          );
        });
  }
}
