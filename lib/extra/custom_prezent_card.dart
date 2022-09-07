import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/blocs/favourite_bloc.dart';
import 'package:hansa_lab/extra/custom_paint_clipper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CustomPrezentCard extends StatefulWidget {
  CustomPrezentCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.onTap,
  }) : super(key: key);
  final String imageUrl;
  final String title;
  VoidCallback onTap;
  @override
  State<CustomPrezentCard> createState() => _CustomPrezentCardState();
}

class _CustomPrezentCardState extends State<CustomPrezentCard> {
  Future<void>? launched;
  final isFavouriteBLoC = FavouriteBLoC();

  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);

    return Padding(
      padding: EdgeInsets.only(right: 18.w, left: 18.w, bottom: 10.h),
      child: Column(
        children: [
          InkWell(
            onTap: () {},
            child: GestureDetector(
              onTap: widget.onTap,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.r),
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  width: double.infinity,
                  height: 206.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 6.h, bottom: 5.h),
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: widget.onTap,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.r),
                          child: ClipPath(
                            clipper: CustomPaintClipper(),
                            child: Container(
                              width: 310.w,
                              height: 75.h,
                              color: const Color(0xff000004),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 18.w),
                        child: SizedBox(
                          width: isTablet ? 400 : 200,
                          child: Text(
                            widget.title,
                            overflow: TextOverflow.clip,
                            style: GoogleFonts.montserrat(
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.bold,
                              fontSize: isTablet ? 10.sp : 13.sp,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      PhysicalModel(
                        shadowColor: Colors.grey.withOpacity(.5),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(64.r),
                        elevation: 5.sp,
                        child: GestureDetector(
                          onTap: widget.onTap,
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            constraints: BoxConstraints(
                              minWidth: 90.w,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 213, 0, 50),
                              borderRadius: BorderRadius.circular(64.r),
                            ),
                            child: Center(
                              child: Text(
                                "Открыть",
                                style: GoogleFonts.montserrat(
                                  color: const Color(0xffffffff),
                                  fontSize: 10.sp,
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
        ],
      ),
    );
  }
}
