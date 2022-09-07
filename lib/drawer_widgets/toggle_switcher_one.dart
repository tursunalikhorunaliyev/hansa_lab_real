import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hansa_lab/blocs/bloc_push_uvodamleniya.dart';
import 'package:hansa_lab/classes/notification_token.dart';
import 'package:hansa_lab/enums/enum_push_uvodamleniya.dart';
import 'package:hansa_lab/providers/provider_otpravit_push_uvodamleniya.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class ToggleSwitcherOne extends StatefulWidget {
  const ToggleSwitcherOne({
    Key? key,
  }) : super(key: key);

  @override
  State<ToggleSwitcherOne> createState() => _ToggleSwitcherOneState();
}

class _ToggleSwitcherOneState extends State<ToggleSwitcherOne> {
  int firstTime = 0;
  Future<bool> getData(token) async {
    http.Response response = await http.get(
      Uri.parse("http://hansa-lab.ru/api/auth/token?token=$token"),
    );
    log("${response.body} bloc push uvodamleniya get");
    log("${response.statusCode} bloc push uvodamleniya get");

    return jsonDecode(response.body)['data'];
  }

  @override
  void initState() {
    firstTime = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerNotificationToken = Provider.of<NotificationToken>(context);

    final providerOtpravitPushUvodamleniya =
        Provider.of<ProviderOtpravitPushUvodamleniya>(context);

    if (firstTime == 1) {
      providerNotificationToken.getToken().then((valueToken) {
        getData(valueToken).then((valueBool) {
          
          providerOtpravitPushUvodamleniya.setAlignment(
              valueBool == false ? Alignment.centerLeft : Alignment.centerRight);
        });
        firstTime = 2;
      });
    }

    final blocPushUvodamleniya =
        BlocPushUvodamleniya(providerNotificationToken);

        log("${providerOtpravitPushUvodamleniya.getAlignment} DFG");

    return Center(
      child: SizedBox(
        height: 21,
        width: 40,
        child: GestureDetector(
            onTap: () {
              providerOtpravitPushUvodamleniya.setAlignment(
                  providerOtpravitPushUvodamleniya.getAlignment ==
                          Alignment.centerRight
                      ? Alignment.centerLeft
                      : Alignment.centerRight);
              Timer(
                const Duration(seconds: 3),
                () {
                  providerNotificationToken.getToken().then((valueToken) {
                    blocPushUvodamleniya.postData(valueToken).then(
                        (valuePost) => blocPushUvodamleniya.eventSink
                            .add(EnumPushUvodamleniya.fetch));
                  });
                },
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 12,
                  decoration: BoxDecoration(
                      color: const Color(0xFFdddddd),
                      borderRadius: BorderRadius.circular(10)),
                ),
                Consumer<ProviderOtpravitPushUvodamleniya>(
                  builder: (context, value, child) {
                    return AnimatedAlign(
                      alignment: value.getAlignment,
                      duration: const Duration(milliseconds: 100),
                      child: Container(
                        width: 21,
                        decoration: BoxDecoration(
                            color: value.getAlignment == Alignment.centerRight
                                ? const Color(0xFF25b049)
                                : Colors.grey[350],
                            borderRadius: BorderRadius.circular(25.r)),
                      ),
                    );
                  },
                )
              ],
            )),
      ),
    );
  }
}
