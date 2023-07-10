import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdatePage extends StatefulWidget {
  final bool skip;
  final Widget home;

  const UpdatePage(this.home, {Key? key, required this.skip}) : super(key: key);

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/update.png',
                color: Color.fromARGB(255, 213, 0, 50),
                height: MediaQuery.of(context).size.width * 0.6,
              ),
              SizedBox(
                height: 10,
              ),
              const Text(
                'В программе есть обновление.',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              const Text(
                'Пожалуйста, обновите приложение',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                    color: Colors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              GestureDetector(
                onTap: () {
                  Platform.isAndroid
                      ? launch(
                          "https://play.google.com/store/apps/details?id=com.hansa.hansa_lab",
                        )
                      : launch(
                          "https://apps.apple.com/uz/app/hansa-lab/id6444158285",
                        );
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 213, 0, 50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 4,
                        offset: const Offset(4, 4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Обновлять!',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              widget.skip
                  ? GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(builder: (_) => widget.home),
                          (route) => false,
                        );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              blurRadius: 4,
                              offset: const Offset(4, 4),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'Keyingi safar ▶️',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
