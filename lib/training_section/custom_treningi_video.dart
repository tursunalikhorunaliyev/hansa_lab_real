import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/blocs/bloc_detect_tap.dart';
import 'package:hansa_lab/blocs/download_progress_bloc.dart';
import 'package:hansa_lab/classes/send_analise_download.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class CustomTreningiVideo extends StatelessWidget {
  final String title;
  VoidCallback onTap;
  CustomTreningiVideo({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerBlocDownload = Provider.of<DownloadProgressFileBloc>(context);
    final providerBlocDetectTap = Provider.of<BlocDetectTap>(context);
    final isTablet = Provider.of<bool>(context);
    final providerSendAnaliseDownload =
        Provider.of<SendAnaliseDownload>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Column(
        children: [
          const SizedBox(
            height: 11,
          ),
          SizedBox(
            width: isTablet ? 800 : 355,
            child: Column(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: isTablet ? 800 : 355,
                      color: const Color(0xffffffff),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: SizedBox(
                                  width: isTablet ? 500 : 200,
                                  child: Text(
                                    title,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    maxLines: 3,
                                    style: GoogleFonts.montserrat(
                                      fontSize: isTablet ? 16 : 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: GestureDetector(
                                  onTap: onTap,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(64),
                                    child: Container(
                                      height: isTablet ? 30 : 25,
                                      width: isTablet ? 120 : 95,
                                      color:
                                          const Color.fromARGB(255, 213, 0, 50),
                                      child: Center(
                                        child: Text(
                                          "Скачать",
                                          style: GoogleFonts.montserrat(
                                            fontSize: isTablet ? 14 : 10,
                                            color: const Color(0xffffffff),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )),
                StreamBuilder<bool>(
                    stream: providerBlocDetectTap.dataStream,
                    builder: (context, snapshotDetectTap) {
                      log("${providerSendAnaliseDownload.getAnalise} downloading");

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: AnimatedContainer(
                            curve: snapshotDetectTap.data == true
                                ? Curves.bounceOut
                                : Curves.bounceOut,
                            duration: const Duration(milliseconds: 500),
                            width: 355,
                            height: snapshotDetectTap.data == true ? 20 : 0,
                            decoration: const BoxDecoration(
                                color: Color(0xffffffff),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                )),
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: snapshotDetectTap.data == true ? 1 : 0,
                              child: providerSendAnaliseDownload.getAnalise ==
                                      true
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: StreamBuilder<double>(
                                          initialData: 0,
                                          stream: providerBlocDownload.stream,
                                          builder: (context, snapshotDouble) {
                                            if (snapshotDouble.data == 100) {
                                              providerBlocDownload.streamSink
                                                  .add(0);
                                              providerBlocDetectTap.dataSink
                                                  .add(false);
                                            }
                                            return LinearPercentIndicator(
                                              alignment:
                                                  MainAxisAlignment.center,
                                              padding: const EdgeInsets.all(0),
                                              barRadius:
                                                  const Radius.circular(5),
                                              lineHeight: 6,
                                              percent:
                                                  snapshotDouble.data! / 100,
                                              backgroundColor: Colors.grey[200],
                                              progressColor: Colors.green,
                                            );
                                          }),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Этот файл уже скачан",
                                          style: GoogleFonts.montserrat(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            )),
                      );
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
