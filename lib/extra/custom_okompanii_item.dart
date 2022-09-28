import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CustomOKompaniiItem extends StatelessWidget {
  const CustomOKompaniiItem({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.onTap,
    required this.onTapImage,
    required this.onDownload,
  }) : super(key: key);
  final String imageUrl;
  final String title;
  final VoidCallback onTap;
  final VoidCallback onTapImage;
  final VoidCallback onDownload;
  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 5 : 20,
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: GestureDetector(
              onTap: onTapImage,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                height: 230,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: isTablet ? 10 : 12,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 100,
              color: const Color(0xffffffff),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 185,
                      child: Text(
                        title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          color: const Color(0xff272624),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        PhysicalModel(
                          shadowColor: Colors.grey.withOpacity(.5),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(64),
                          elevation: 5,
                          child: GestureDetector(
                            onTap: onTap,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(64),
                              child: Container(
                                padding: const EdgeInsets.all(7),
                                constraints: const BoxConstraints(
                                  minWidth: 90,
                                ),
                                color: const Color(0xff1c2c45),
                                child: Center(
                                  child: Text(
                                    "Смотреть",
                                    style: GoogleFonts.montserrat(
                                      color: const Color(0xffffffff),
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        PhysicalModel(
                          shadowColor: Colors.grey.withOpacity(.5),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(64),
                          elevation: 5,
                          child: GestureDetector(
                            onTap: onDownload,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(64),
                              child: Container(
                                padding: const EdgeInsets.all(7),
                                constraints: const BoxConstraints(
                                  minWidth: 90,
                                ),
                                color: const Color.fromARGB(255, 213, 0, 50),
                                child: Center(
                                  child: Text(
                                    "Скачать",
                                    style: GoogleFonts.montserrat(
                                      color: const Color(0xffffffff),
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: isTablet ? 0 : 12,
          ),
        ],
      ),
    );
  }
}
