import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/api_models.dart/model_glavniy_menu_user_info.dart';
import 'package:hansa_lab/blocs/bloc_glavniy_menu_user_info.dart';
import 'package:hansa_lab/enums/enum_action_view.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ReferalSilka extends StatelessWidget {
  const ReferalSilka({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    final providerToken = Provider.of<String>(context);

    final blocGlavniyMenuUserInfo = BlocGlavniyMenuUserInfo(providerToken);

    blocGlavniyMenuUserInfo.eventSink.add(EnumActionView.view);
    return Wrap(
      children: [
        Padding(
          padding: EdgeInsets.only(left: isTablet ? 30 : 82),
          child: Text(
            "Реферальная ссылка",
            style: GoogleFonts.montserrat(
                fontSize: isTablet ? 17 : 13, color: const Color(0xFFaaaaaa)),
          ),
        ),
        SizedBox(
          height: isTablet ? 30 : 10,
        ),
        Divider(
          color: const Color(0xFF444444),
          thickness: 2,
          indent: isTablet ? 10 : 72,
          endIndent: isTablet ? 10 : 26,
        ),
        SizedBox(
          height: isTablet ? 20 : 19,
        ),
        Wrap(
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: isTablet ? 30 : 82),
              child: StreamBuilder<ModelGlavniyMenuUserInfoMain>(
                  stream: blocGlavniyMenuUserInfo.dataStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data!.data.refLink,
                        style: GoogleFonts.montserrat(
                            fontSize: isTablet ? 17 : 10,
                            color: const Color(0xFFffffff)),
                      );
                    } else {
                      return Text(
                        "Загрузка..",
                        style: GoogleFonts.montserrat(
                            fontSize: isTablet ? 17 : 10, color: const Color(0xFFffffff)),
                      );
                    }
                  }),
            ),
            const SizedBox(
              width: 30,
            ),
            StreamBuilder<ModelGlavniyMenuUserInfoMain>(
              stream: blocGlavniyMenuUserInfo.dataStream,
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return InkWell(
                  onTap: () {
                    Share.share(snapshot.data!.data.refLink);
                    
                  },
                  child: Image.asset(
                    "assets/free-icon-sharethis-1532422.png",
                    height: isTablet ? 30 : 20,
                    width: isTablet ? 30 : 20,
                  ),
                );

                }
                else{
                  return const SizedBox();
                }
                
              }
            ),
            SizedBox(
              height: isTablet ? 60 : 0,
            ),
            Divider(
              color: const Color(0xFF444444),
              thickness: 2,
              indent: isTablet ? 10 : 72,
              endIndent: isTablet ? 10 : 26,
            ),
          ],
        ),
      ],
    );
  }
}
