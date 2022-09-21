import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/api_models.dart/rating_top_model.dart';
import 'package:hansa_lab/api_services/rating_top_api.dart';
import 'package:hansa_lab/drawer_widgets/drawer_stat_title.dart';
import 'package:hansa_lab/providers/fullname_provider.dart';
import 'package:provider/provider.dart';

class DrawerStats extends StatefulWidget {
  const DrawerStats({Key? key}) : super(key: key);

  @override
  State<DrawerStats> createState() => _DrawerStatsState();
}

class _DrawerStatsState extends State<DrawerStats> {
  bool isCollapsed = false;
  final scroll = ScrollController();
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<String>(context);
    final bloc = BlocRating();
    final isTablet = Provider.of<bool>(context);
    final fullname = Provider.of<FullnameProvider>(context);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
   
        color: const Color(0xFFffffff),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const DrawerStatTitle(
                  imagePath: "assets/free-icon-rating-4569150.png",
                  title: "Статистика",
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: InkWell(
                    onTap: () {
                      scroll.animateTo(0,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.fastLinearToSlowEaseIn);
                    },
                    child: const Icon(CupertinoIcons.chevron_up_circle_fill,
                        color: Color.fromARGB(255, 213, 0, 50), size: 25),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: isTablet ? 490 : 330,
              child: FutureBuilder<RatingTopModel>(
                  future: bloc.getStores(prov),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        controller: scroll,
                        child: DataTable(
                          headingRowHeight: 40,
                          columnSpacing: 10,
                          dataRowHeight: isTablet ? 45 : 30,
                          horizontalMargin: 1,
                          columns: [
                            DataColumn(
                              label: Text(
                                "Место",
                                style: GoogleFonts.montserrat(
                                  fontSize: isTablet ? 14 : 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Сеть",
                                style: GoogleFonts.montserrat(
                                  fontSize: isTablet ? 14 : 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Участник",
                                style: GoogleFonts.montserrat(
                                  fontSize: isTablet ? 14 : 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Баллы",
                                style: GoogleFonts.montserrat(
                                  fontSize: isTablet ? 14 : 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          rows: List.generate(
                              snapshot.data!.data.list.length, (index) {
                            bool thisUser = snapshot
                                    .data!.data.list[index].name ==
                                "${fullname.getName.split(' ').last} ${fullname.getName.split(' ').first}";
                            return DataRow(
                              color: MaterialStateProperty.all(
                                thisUser
                                    ? const Color.fromARGB(255, 213, 0, 50)
                                    : Colors.white,
                              ),
                              cells: [
                                DataCell(
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${index + 1}",
                                      style: GoogleFonts.montserrat(
                                          fontSize: isTablet ? 13 : 8,
                                          fontWeight: FontWeight.normal,
                                          color: thisUser
                                              ? Colors.white
                                              : const Color(0xff353433)),
                                    ),
                                  ),
                                ),
                                DataCell(Text(
                                  snapshot.data!.data.list[index].shopNet,
                                  style: GoogleFonts.montserrat(
                                      fontSize: isTablet ? 12 : 8,
                                      fontWeight: FontWeight.normal,
                                      color: thisUser
                                          ? Colors.white
                                          : const Color(0xff353433)),
                                )),
                                DataCell(Text(
                                  snapshot.data!.data.list[index].name,
                                  style: GoogleFonts.montserrat(
                                      fontSize: 8,
                                      fontWeight: FontWeight.normal,
                                      color: thisUser
                                          ? Colors.white
                                          : const Color(0xff353433)),
                                )),
                                DataCell(Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    snapshot.data!.data.list[index].score,
                                    style: GoogleFonts.montserrat(
                                        fontSize: 8,
                                        fontWeight: FontWeight.normal,
                                        color: thisUser
                                            ? Colors.white
                                            : const Color(0xff353433)),
                                  ),
                                )),
                              ],
                            );
                          }),
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: isTablet ? 530 : 330,
                        child: const SpinKitPulse(
                          color: Color.fromARGB(255, 213, 0, 50),
                        ),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
