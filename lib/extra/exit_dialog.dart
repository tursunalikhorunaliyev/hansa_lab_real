import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hansa_lab/classes/send_check_switcher.dart';
import 'package:provider/provider.dart';

class ExitDialog extends StatelessWidget {
  const ExitDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerSendCheckSwitcher = Provider.of<SendCheckSwitcher>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          height: 180,
          width: 300,
          decoration: BoxDecoration(
              color: const Color(0xffffffff),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Вы уверены, что хотите выйти из этого приложения?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              //Salom
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (providerSendCheckSwitcher.getBool == true) {
                        Navigator.pop(context);
                      } else {
                        exit(0);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 35,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 238, 238, 238),
                      ),
                      child: const Text(
                        "Да",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 35,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFF25b049),
                      ),
                      child: const Text(
                        "Нет",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
