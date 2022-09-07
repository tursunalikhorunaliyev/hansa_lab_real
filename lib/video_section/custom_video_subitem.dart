import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CustomVideoSubItem extends StatelessWidget {
  const CustomVideoSubItem({Key? key, required this.title, required this.onTap})
      : super(key: key);
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.only(left: 40, right: 20, top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 213, 0, 50),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                        color: const Color(0xff33383f),
                        fontWeight: FontWeight.w600,
                        fontSize: isTablet ? 9.sp : 14.sp),
                  ),
                ],
              ),
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
                      constraints: BoxConstraints(
                        minWidth: 90.w,
                      ),
                      color: const Color.fromARGB(255, 213, 0, 50),
                      child: Center(
                        child: Text(
                          "Открыть раздел",
                          style: GoogleFonts.montserrat(
                            color: const Color(0xffffffff),
                            fontSize: isTablet ? 9.sp : 10.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
