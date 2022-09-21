import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/blocs/login_clicked_bloc.dart';
import 'package:hansa_lab/providers/provider_for_flipping/flip_login_provider.dart';
import 'package:hansa_lab/providers/provider_for_flipping/login_clicked_provider.dart';
import 'package:provider/provider.dart';

class VoytiIliSozdatAccaunt extends StatelessWidget {
  const VoytiIliSozdatAccaunt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
/*     final provider = Provider.of<LoginClickedBloc>(context);
    final providerAnim = Provider.of<LoginAnimBloc>(context);
    final providerFlip = Provider.of<FlipCardController>(context);
 */

    final isTablet = Provider.of<bool>(context);
    final providerFlip = Provider.of<Map<String, FlipCardController>>(context);
    final flipLoginProvider = Provider.of<FlipLoginProvider>(context);

    final loginActionProvider = Provider.of<LoginClickedProvider>(context);

    return 
         Wrap(
          direction: Axis.vertical,
          alignment: WrapAlignment.center,
          spacing: isTablet ? -58.h : -50.h,
          children: [
            SizedBox(
              height: 40.h,
            ),
            GestureDetector(
              onTap: (() {
                loginActionProvider.changeLoginAction(LoginAction.signin);
                flipLoginProvider.changeIsClosed(true);
                providerFlip['login']!.toggleCard();
              }),
              child: Container(
                height: isTablet ? 50.h : 46.66666666666667.h,
                width: isTablet ? 220.w : 320.3333333333333.w,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(23.33333333333333.r),
                    border: Border.all(
                        color: const Color(0xFFa1b7c2),
                        width: isTablet ? 1.w : 2.w)),
                child: Center(
                  child: Text(
                    "Создать аккаунт",
                    style: GoogleFonts.montserrat(
                        color: const Color(0xFFa1b7c2),
                        fontSize: isTablet ? 10.sp : 12.66666666666667.sp),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: isTablet ? 25.h : 27.66666666666667.h,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 7),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: isTablet ? 1.h : 1.5.h,
                    width: isTablet ? 96.w : 140.w,
                    color: const Color(0xFFa1b7c2),
                  ),
                  Text("ИЛИ",
                      style: GoogleFonts.montserrat(
                          color: const Color(0xFFa1b7c2),
                          fontSize: isTablet ? 9.sp : 10.sp)),
                  Container(
                    height: isTablet ? 1.h : 1.5.h,
                    width: isTablet ? 96.w : 140.w,
                    color: const Color(0xFFa1b7c2),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 27.66666666666667.h,
            ),
            GestureDetector(
              onTap: () {
                loginActionProvider.changeLoginAction(LoginAction.login);
                flipLoginProvider.changeIsClosed(true);
                providerFlip['login']!.toggleCard();
              },
              child: Container(
                height: isTablet ? 50.h : 46.66666666666667.h,
                width: isTablet ? 220.w : 320.3333333333333.w,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 213, 0, 50),
                    borderRadius: BorderRadius.circular(23.33333333333333.r)),
                child: Center(
                  child: Text(
                    "Войти",
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: isTablet ? 10.sp : 12.66666666666667.sp),
                  ),
                ),
              ),
            ),
          ],
        );
  }

}
