import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/blocs/favourite_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class StackedStack extends StatelessWidget {
  const StackedStack(
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
      required this.imageOnTap})
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
  @override
  Widget build(BuildContext context) {
    final isFavouriteBLoC = FavouriteBLoC();
    final token = Provider.of<String>(context);
    bool fav = isFavourite;
    return Center(
      child: SizedBox(
        height: 360,
        width: 430,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                children: [
                  SizedBox(
                      width: 410,
                      height: 230,
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: imageOnTap,
                            child: SizedBox(
                              width: 410,
                              height: 230,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          height: 65,
                                          width: 65,
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
                                                textScaleFactor: 1.0,
                                                style: const TextStyle(
                                                  
                                                    fontSize: 11),
                                              ),
                                              Text(
                                                month,
                                                textScaleFactor: 1.0,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 9),
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
                  //  Spacer(),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 410,
                    height: 75.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color(0xffffffff)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                              softWrap: true,
                              style: GoogleFonts.montserrat(
                                  fontSize: 14, fontWeight: FontWeight.w800),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 23.w),
                            child: GestureDetector(
                              onTap: onTap,
                              child: Container(
                                alignment: Alignment.center,
                                width: 100,
                                height: 28,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                    color:
                                        const Color.fromARGB(255, 213, 0, 50),
                                    borderRadius: BorderRadius.circular(13)),
                                child: Text(
                                  buttonText,
                                  style: GoogleFonts.montserrat(
                                      fontSize: 12,
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
                ],
              ),
            ),
            StreamBuilder<bool>(
                initialData: false,
                stream: isFavouriteBLoC.stream,
                builder: (context, snapshot) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 115, right: 45),
                      child: InkWell(
                        onTap: () {
                          fav = !fav;
                          isFavouriteBLoC.sink.add(fav);
                          isFavouriteBLoC.getFavourite(token, isFavouriteURL);
                          if (fav) {
                            showTopSnackBar(
                              reverseCurve: Curves.elasticOut,
                              animationDuration:
                                  const Duration(milliseconds: 600),
                              displayDuration:
                                  const Duration(milliseconds: 600),
                              context,
                              const CustomSnackBar.success(
                                iconRotationAngle: 0,
                                iconPositionLeft: 30,
                               // messagePadding:
                                    //EdgeInsets.symmetric(horizontal: 80),
                                icon: Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                backgroundColor:
                                    Color.fromARGB(255, 213, 0, 50),
                                message: "Сохранено в избранном",
                              ),
                            );
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 52,
                          width: 52,
                          decoration: const BoxDecoration(
                              color: Color(0xfff1f1f1), shape: BoxShape.circle),
                          child: (fav)
                              ? const Icon(
                                  Icons.favorite,
                                  color: Color.fromARGB(255, 213, 0, 50),
                                  size: 30,
                                )
                              : const Icon(
                                  Icons.favorite_border_sharp,
                                  color: Color.fromARGB(255, 213, 0, 50),
                                  size: 30,
                                ),
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
