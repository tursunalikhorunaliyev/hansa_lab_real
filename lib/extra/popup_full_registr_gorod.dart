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
  final blocPopupDrawer = BlocPopupDrawer();
  double radius = 54;
  String text = "Город";

  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    final blocHansaCountry = HansaCountryBloC(1);

    blocHansaCountry.eventSink.add(CityEnum.city);
    final gorodTextEditingContyroller =
        Provider.of<TextEditingController>(context);

    return StreamBuilder<double>(
        initialData: 38,
        stream: blocPopupDrawer.dataStream,
        builder: (context, snapshotSizeDrawer) {
          return InkWell(
            onTap: () {
              widget.onTap();
              blocPopupDrawer.dataSink
                  .add(snapshotSizeDrawer.data! == 38 ? 200 : 38);
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
                      width:
                          widget.borderColor == const Color.fromARGB(255, 213, 0, 50)
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
                      StreamBuilder<CountryModel>(
                          stream: blocHansaCountry.stream,
                          builder: (context, snapshotCountry) {
                            if (snapshotCountry.hasData) {
                              return Expanded(
                                child: Visibility(
                                  visible: radius == 54 ? false : true,
                                  child: ListView.builder(
                                    itemCount:
                                        snapshotCountry.data!.data.list.length,
                                    padding: const EdgeInsets.all(0),
                                    itemBuilder: (context, index) {
                                      return TextButton(
                                        onPressed: () {
                                          gorodTextEditingContyroller.text =
                                              snapshotCountry
                                                  .data!.data.list[index].name;
                                          text = snapshotCountry
                                              .data!.data.list[index].name;
                                          blocPopupDrawer.dataSink.add(
                                              snapshotCountry.data! == 38
                                                  ? 200
                                                  : 38);
                                          radius = radius == 54 ? 10 : 54;
                                        },
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            snapshotCountry
                                                .data!.data.list[index].name,
                                            style: const TextStyle(
                                                color: Colors.black,
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
            ),
          );
        });
  }
}
