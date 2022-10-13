import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/api_models.dart/country_model.dart';
import 'package:hansa_lab/blocs/bloc_number_country.dart';
import 'package:hansa_lab/blocs/bloc_popup_drawer.dart';
import 'package:hansa_lab/blocs/bloc_send_id.dart';
import 'package:hansa_lab/blocs/hansa_country_api.dart';
import 'package:provider/provider.dart';

class PopUpFullRegistrNumber extends StatefulWidget {
  final Color borderColor;
  final Color hintColor;
  final VoidCallback onTap;
  const PopUpFullRegistrNumber(
      {required this.borderColor,
      required this.hintColor,
      required this.onTap,
      super.key});

  @override
  State<PopUpFullRegistrNumber> createState() => _PopUpFullRegistrNumberState();
}

class _PopUpFullRegistrNumberState extends State<PopUpFullRegistrNumber> {
  TextEditingController textEditingController = TextEditingController();

  final blocPopupDrawer = BlocPopupDrawer();

  List<CountryModelData> allCities = [];
  List<CountryModelData> cities = [];

  List<String> ccs = ['Россия', 'Армения', 'Казахстан'];
  List<EnumCuntryNumber> ecs = [
    EnumCuntryNumber.rus,
    EnumCuntryNumber.armen,
    EnumCuntryNumber.kazak
  ];

  double radius = 54;
  String text = "Страна";

  @override
  Widget build(BuildContext context) {
    final providerNumberCountry = Provider.of<BlocNumberCountry>(context);
    final isTablet = Provider.of<bool>(context);
    final gorodTextEditingContyroller =
        Provider.of<TextEditingController>(context);
    final providerBlocSendId = Provider.of<BlocSendId>(context);

    return StreamBuilder<double>(
      initialData: 38,
      stream: blocPopupDrawer.dataStream,
      builder: (context, snapshotSizeDrawer) {
        return InkWell(
          onTap: () {
            widget.onTap();
            blocPopupDrawer.dataSink
                .add(snapshotSizeDrawer.data! == 38 ? 140 : 38);
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
                            style: text == "Страна"
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
                    Visibility(
                      visible: radius == 54 ? false : true,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 100,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.all(0),
                                itemCount: 3,
                                itemBuilder: (context, index) {
                                  return TextButton(
                                    onPressed: () {
                                      providerBlocSendId.dataSinkId
                                          .add(ccs[index].contains("Россия")
                                              ? 1
                                              : ccs[index].contains("Казахстан")
                                                  ? 2
                                                  : 3);
                                      providerBlocSendId.eventSink
                                          .add(CityEnum.city);

                                      gorodTextEditingContyroller.text =
                                          ccs[index];
                                      text = ccs[index];
                                      blocPopupDrawer.dataSink.add(
                                          snapshotSizeDrawer.data! == 38
                                              ? 140
                                              : 38);
                                      providerNumberCountry.sink
                                          .add(ecs[index]);
                                      radius = radius == 54 ? 10 : 54;
                                      setState(() {});
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        ccs[index],
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 10),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
