import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/blocs/favourite_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class StackedStackObuch extends StatefulWidget {
  const StackedStackObuch(
      {Key? key,
      required this.buttonColor,
      required this.bottomButtonText,
      required this.title,
      required this.url,
      required this.isFavourite,
      required this.linkPDF,
      required this.isFavouriteURL})
      : super(key: key);

  final String url;
  final Color buttonColor;
  final String bottomButtonText;
  final String title;
  final bool isFavourite;
  final String linkPDF;
  final String isFavouriteURL;

  @override
  State<StackedStackObuch> createState() => _StackedStackObuchState();
}

class _StackedStackObuchState extends State<StackedStackObuch> {
  late dynamic response;

  Future<void>? launched;

  @override
  Widget build(BuildContext context) {
    final isFavouriteBLoC = FavouriteBLoC();
    final token = Provider.of<String>(context);
    bool fav = widget.isFavourite;
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
                  InkWell(
                    onTap: () {
                      setState(() {
                        launched = _launchInBrowser(
                            Uri.parse("http://${widget.linkPDF}"));
                      });
                    },
                    child: SizedBox(
                        width: 410,
                        height: 230,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.r),
                          child: CachedNetworkImage(
                            imageUrl: widget.url,
                            fit: BoxFit.cover,
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 410,
                    height: 75.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        color: const Color(0xffffffff)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.title,
                              overflow: TextOverflow.fade,
                              style: GoogleFonts.montserrat(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 23.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      launched = _launchInBrowser(Uri.parse(
                                          "http://${widget.linkPDF}"));
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 100,
                                    height: 28,
                                    decoration: BoxDecoration(
                                        color: widget.buttonColor,
                                        borderRadius:
                                            BorderRadius.circular(13.r)),
                                    child: Text(
                                      widget.bottomButtonText,
                                      style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          color: const Color(0xffffffff),
                                          fontWeight: FontWeight.w500),
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
                          isFavouriteBLoC.getFavourite(
                              token, widget.isFavouriteURL);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 52,
                          width: 52,
                          decoration: BoxDecoration(
                              color: const Color(0xfff1f1f1),
                              borderRadius: BorderRadius.circular(90.w)),
                          child: fav
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

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}
