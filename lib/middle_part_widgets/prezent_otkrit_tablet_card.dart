import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/extra/custom_paint_clipper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrezentOtkritTabletCard extends StatefulWidget {
  PrezentOtkritTabletCard({
    Key? key,
    required this.title,
    required this.url,
    required this.onTap,
  }) : super(key: key);

  final String url;
  final String title;
  VoidCallback onTap;

  @override
  State<PrezentOtkritTabletCard> createState() =>
      _PrezentOtkritTabletCardState();
}

class _PrezentOtkritTabletCardState extends State<PrezentOtkritTabletCard> {
  late dynamic response;
  Future<void>? launched;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 390,
        width: 430,
        child: Stack(
          children: [
            Padding(padding: const EdgeInsets.only(left: 5,right: 5,bottom: 10 ),
            child: Column(children: [
                  InkWell(
            onTap: widget.onTap,
            child: SizedBox(
               width: 350,
                height: 230,
                child: GestureDetector(
                  onTap: widget.onTap,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.r),
                    child: CachedNetworkImage(
                      imageUrl: widget.url,
                      fit: BoxFit.cover,
                    ),
                  ),
                )),
          ),const SizedBox(
                    height: 10,
                  ),
          Padding(
            padding: EdgeInsets.only(top: 6.h, bottom: 5.h),
            child: SizedBox(
              width: 500,
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
                              width: 150.w,
                              height: 75.h,
                              color: const Color(0xff000004),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Container(
                          width: 180,
                          height: 70.h,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: GoogleFonts.montserrat(
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.bold,
                              fontSize: 9.sp,
                            ),
                          ),
                        ),
                      ),
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
                              minWidth: 60.w,
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
                                  fontSize: 7.sp,
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
            ],),)
          ],
        ),
      ),
    );
    
  }
}
