import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hansa_lab/classes/send_check_switcher.dart';
import 'package:provider/provider.dart';

class ThanksDialog extends StatelessWidget {
  const ThanksDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerSendCheckSwitcher = Provider.of<SendCheckSwitcher>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          height: 150,
          width: 300,
          decoration: BoxDecoration(
              color: const Color(0xffffffff),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Спасибо что вы записались на наш вебинар. Вся подробная информация отправлена вам на почту. ",
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.0,
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
