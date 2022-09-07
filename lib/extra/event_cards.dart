import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/api_models.dart/favourite_model.dart';
import 'package:hansa_lab/api_services/welcome_api.dart';
import 'package:hansa_lab/blocs/favourite_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventCards extends StatelessWidget {
  const EventCards(
      {Key? key,
      required this.buttonColor,
      required this.buttonText,
      required this.month,
      required this.title,
      required this.isDate,
      required this.day,
      required this.url,
      required this.isFavouriteURL,
      required this.isFavourite,
      required this.onTap,
      required this.imageOnTap,
      required this.index})
      : super(key: key);
  final String url;
  final String isFavouriteURL;
  final Color buttonColor;
  final String month;
  final String day;
  final String buttonText;
  final String title;
  final bool isDate;
  final bool isFavourite;
  final VoidCallback onTap;
  final VoidCallback imageOnTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isFavouriteBLoC = FavouriteBLoC();
    final token = Provider.of<String>(context);
    final isTablet = Provider.of<bool>(context);
    final providerWelcomeApi = Provider.of<WelcomeApi>(context);
    final favouriteModel = FavouriteModel(status: true, data: true);
    bool fav = isFavourite;
    return Padding(
      padding: EdgeInsets.only(
          bottom: isTablet ? 15.h : 10,
          left: isTablet ? 0 : 20,
          right: isTablet ? 0 : 20),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: isTablet ? 180 : 217),
            child: Container(
              width: isTablet ? 390 : double.infinity,
              height: isTablet ? 75.h : 93.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color(0xffffffff)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isTablet ? 7.w : 11),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        overflow: TextOverflow.fade,
                        style: GoogleFonts.montserrat(
                            fontSize: isTablet ? 14 : 12,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: isTablet ? 23.w : 23),
                      child: GestureDetector(
                        onTap: onTap,
                        child: Container(
                          alignment: Alignment.center,
                          width: isTablet ? 100 : 94,
                          height: isTablet ? 28 : 25,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              color: const Color.fromARGB(255, 213, 0, 50),
                              borderRadius: BorderRadius.circular(13)),
                          child: Text(
                            buttonText,
                            style: GoogleFonts.montserrat(
                                fontSize: isTablet ? 12 : 10,
                                color: const Color(0xffffffff),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
              width: isTablet ? 388 : double.infinity,
              height: isTablet ? 170 : 206,
              child: Stack(
                children: [
                  InkWell(
                    onTap: imageOnTap,
                    child: SizedBox(
                      width: isTablet ? 388 : double.infinity,
                      height: isTablet ? 170 : 206,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          imageUrl: url,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  isDate
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  height: isTablet ? 65 : 65,
                                  width: isTablet ? 65 : 65,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        day,
                                        style: TextStyle(
                                            fontSize: isTablet ? 14 : 11),
                                      ),
                                      Text(
                                        month,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: isTablet ? 9 : 9),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox(),
                ],
              )),
          Padding(
            padding: EdgeInsets.only(
              top: isTablet ? 150 : 181,
            ),
            child: Row(
              children: [
                Spacer(
                  flex: isTablet ? 15 : 9,
                ),
                StreamBuilder<bool>(
                    initialData: false,
                    stream: isFavouriteBLoC.stream,
                    builder: (context, snapshot) {
                      return InkWell(
                        onTap: () {
                          fav = !fav;
                          isFavouriteBLoC.sink.add(fav);
                          providerWelcomeApi.list[index].setBool(fav);
                          isFavouriteBLoC.getFavourite(token, isFavouriteURL);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: isTablet ? 45 : 55,
                          width: isTablet ? 45 : 55,
                          decoration: const BoxDecoration(
                              color: Color(0xfff1f1f1), shape: BoxShape.circle),
                          child: (fav)
                              ? const Icon(
                                  Icons.favorite,
                                  color: Color.fromARGB(255, 213, 0, 50),
                                )
                              : const Icon(
                                  Icons.favorite_border_sharp,
                                  color: Color.fromARGB(255, 213, 0, 50),
                                ),
                        ),
                      );
                    }),
                Spacer(
                  flex: isTablet ? 2 : 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
