import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/api_models.dart/prezintatsi_model.dart';
import 'package:hansa_lab/api_services/welcome_api.dart';
import 'package:hansa_lab/blocs/prezintatsia_bloc.dart';
import 'package:hansa_lab/classes/sned_url_prezent_otkrit.dart';
import 'package:hansa_lab/extra/archive_card.dart';
import 'package:hansa_lab/extra/prezentatTabCard.dart';
import 'package:hansa_lab/screens/pdf_viewer.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class PresentArchive extends StatefulWidget {
  const PresentArchive({
    Key? key,
  }) : super(key: key);

  @override
  State<PresentArchive> createState() => _PresentArchiveState();
}

class _PresentArchiveState extends State<PresentArchive> {
  @override
  Widget build(BuildContext context) {
    final token = Provider.of<String>(context);
    final providerSendUrlPrezentOtkrit =
        Provider.of<SendUrlPrezentOtkrit>(context);
    final bloc = PrezintatsiaBLoC(token, providerSendUrlPrezentOtkrit.getUrl);
    log(providerSendUrlPrezentOtkrit.getUrl);
    bloc.sinkAction.add(PrezintatsiaAction.show);
    final scroll = ScrollController();
    final isTablet = Provider.of<bool>(context);

    Future<void>? launched;
    return Expanded(
      child: FutureBuilder<PrezintatsiaModel>(
          future: bloc.getPrezintatsiyaData(
              token, providerSendUrlPrezentOtkrit.getUrl),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(children: [
                  StickyHeader(
                      header: Container(
                        decoration: const BoxDecoration(
                            color: Color(0xffeaeaea),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xffeaeaea),
                                  offset: Offset(0, -3))
                            ]),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: isTablet ? 20 : 9, bottom: isTablet ? 9 : 5),
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: isTablet ? 55.w : 70.w,
                                height: isTablet ? 46.h : 42.h,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 213, 0, 50),
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(
                                            isTablet ? 45.r : 21.r),
                                        bottomRight: Radius.circular(
                                            isTablet ? 45.r : 21.r))),
                                child: Image.asset(
                                  'assets/free-icon-presentation-582644.png',
                                  height: isTablet ? 30.h : 30,
                                  width: isTablet ? 30.w : 30,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  '#',
                                  style: GoogleFonts.montserrat(
                                      fontSize: isTablet ? 22 : 20,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromARGB(
                                          255, 213, 0, 50)),
                                ),
                              ),
                              Text(
                                'Презентации ',
                                style: GoogleFonts.montserrat(
                                    fontSize: isTablet ? 25 : 20,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xff272624)),
                              )
                            ],
                          ),
                        ),
                      ),
                      content: isTablet
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: GridView(
                                controller: scroll,
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10,
                                        mainAxisExtent: 375),
                                children: List.generate(
                                    snapshot.data!.data.guides.dataGuides
                                        .length, (index) {
                                  return Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: StackedStackPrezentatsiyaTab(
                                        buttonLink: snapshot.data!.data.guides
                                                    .dataGuides[index].pdfUrl ==
                                                ''
                                            ? const SizedBox()
                                            : Padding(
                                                padding: EdgeInsets.only(
                                                    top:
                                                        isTablet ? 22.h : 15.h),
                                                child: InkWell(
                                                  onTap: () {
                                                    if (snapshot
                                                            .data!
                                                            .data
                                                            .guides
                                                            .dataGuides[index]
                                                            .pdfUrl
                                                            .contains(".pdf") &&
                                                        snapshot
                                                            .data!
                                                            .data
                                                            .guides
                                                            .dataGuides[index]
                                                            .pdfUrl
                                                            .contains(
                                                                "google")) {
                                                      String pdfInAppUrl =
                                                          snapshot
                                                              .data!
                                                              .data
                                                              .guides
                                                              .dataGuides[index]
                                                              .pdfUrl
                                                              .split("url=")[1]
                                                              .split("&")[0];
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                PDFViewer(
                                                                    pdfUrlForPDFViewer:
                                                                        pdfInAppUrl),
                                                          ));
                                                    } else {
                                                      String fullUrl = snapshot
                                                              .data!
                                                              .data
                                                              .guides
                                                              .dataGuides[index]
                                                              .pdfUrl
                                                              .startsWith(
                                                                  "http")
                                                          ? snapshot
                                                              .data!
                                                              .data
                                                              .guides
                                                              .dataGuides[index]
                                                              .pdfUrl
                                                          : "http://${snapshot.data!.data.guides.dataGuides[index].pdfUrl}";

                                                      setState(() {
                                                        launched =
                                                            _launchInBrowser(
                                                                Uri.parse(
                                                                    fullUrl));
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    width: isTablet ? 100 : 94,
                                                    height: isTablet ? 28 : 25,
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xff31353b),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    13.r)),
                                                    child: Text(
                                                      'Скачать',
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: isTablet
                                                                  ? 12
                                                                  : 10,
                                                              color: const Color(
                                                                  0xffffffff),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        isFavouriteURL: snapshot
                                            .data!
                                            .data
                                            .guides
                                            .dataGuides[index]
                                            .favouriteLink,
                                        linkPDFSkachat: snapshot.data!.data
                                            .guides.dataGuides[index].pdfUrl,
                                        linkPDF: snapshot.data!.data.guides
                                            .dataGuides[index].link,
                                        buttonColor: const Color.fromARGB(
                                            255, 213, 0, 50),
                                        topButtonText: 'Скачать',
                                        bottomButtonText: 'Читать',
                                        isFavourite: snapshot.data!.data.guides
                                            .dataGuides[index].isFavourite,
                                        skachat: Container(
                                          alignment: Alignment.center,
                                          width: 94,
                                          height: 25,
                                          decoration: BoxDecoration(
                                              color: const Color(0xff31353b),
                                              borderRadius:
                                                  BorderRadius.circular(13)),
                                          child: Text(
                                            'skachat',
                                            style: GoogleFonts.montserrat(
                                                fontSize: 10,
                                                color: const Color(0xffffffff),
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        title: snapshot.data!.data.guides
                                            .dataGuides[index].title,
                                        url: snapshot.data!.data.guides
                                            .dataGuides[index].pictureLink,
                                      ) /* StackedStackPrezentatsiyaTab(
                                    isFavouriteURL: snapshot
                                        .data!
                                        .data
                                        .guides
                                        .dataGuides[index]
                                        .favourite_link,
                                    linkPDFSkachat: snapshot.data!.data
                                        .guides.dataGuides[index].pdfUrl,
                                    linkPDF: snapshot.data!.data.guides
                                        .dataGuides[index].link,
                                    buttonColor: const Color(0xffff163e),
                                    topButtonText: 'Скачать',
                                    bottomButtonText: 'Читать',
                                    isFavourite: snapshot.data!.data.guides
                                        .dataGuides[index].isFavourite,
                                    skachat: Container(
                                      alignment: Alignment.center,
                                      width: 94,
                                      height: 25,
                                      decoration: BoxDecoration(
                                          color: const Color(0xff31353b),
                                          borderRadius:
                                              BorderRadius.circular(13)),
                                      child: Text(
                                        'skachat',
                                        style: GoogleFonts.montserrat(
                                            fontSize: 10,
                                            color: const Color(0xffffffff),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    title: snapshot.data!.data.guides
                                        .dataGuides[index].title,
                                    url: snapshot.data!.data.guides
                                        .dataGuides[index].picture_link,
                                  ), */
                                      );
                                }),
                              ),
                            )
                          : Column(
                              children: List.generate(
                              snapshot.data!.data.guides.dataGuides.length,
                              (index) {
                                return Column(
                                  children: [
                                    Row(),
                                    ArchiveCard(
                                      downloadButton: snapshot.data!.data.guides
                                                  .dataGuides[index].pdfUrl ==
                                              ''
                                          ? const SizedBox()
                                          : Padding(
                                              padding: EdgeInsets.only(
                                                  top: isTablet ? 22.h : 15.h),
                                              child: InkWell(
                                                onTap: () {
                                                  if (snapshot
                                                          .data!
                                                          .data
                                                          .guides
                                                          .dataGuides[index]
                                                          .pdfUrl
                                                          .contains(".pdf") &&
                                                      snapshot
                                                          .data!
                                                          .data
                                                          .guides
                                                          .dataGuides[index]
                                                          .pdfUrl
                                                          .contains("google")) {
                                                    String pdfInAppUrl =
                                                        snapshot
                                                            .data!
                                                            .data
                                                            .guides
                                                            .dataGuides[index]
                                                            .pdfUrl
                                                            .split("url=")[1]
                                                            .split("&")[0];
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              PDFViewer(
                                                                  pdfUrlForPDFViewer:
                                                                      pdfInAppUrl),
                                                        ));
                                                  } else {
                                                    String fullUrl = snapshot
                                                            .data!
                                                            .data
                                                            .guides
                                                            .dataGuides[index]
                                                            .pdfUrl
                                                            .startsWith("http")
                                                        ? snapshot
                                                            .data!
                                                            .data
                                                            .guides
                                                            .dataGuides[index]
                                                            .pdfUrl
                                                        : "http://${snapshot.data!.data.guides.dataGuides[index].pdfUrl}";

                                                    setState(() {
                                                      launched =
                                                          _launchInBrowser(
                                                              Uri.parse(
                                                                  fullUrl));
                                                    });
                                                  }
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: isTablet ? 100 : 94,
                                                  height: isTablet ? 28 : 25,
                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xff31353b),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              13.r)),
                                                  child: Text(
                                                    'Скачать',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontSize: isTablet
                                                                ? 12
                                                                : 10,
                                                            color: const Color(
                                                                0xffffffff),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                  ),
                                                ),
                                              ),
                                            ),
                                      isFavouriteURL: snapshot.data!.data.guides
                                          .dataGuides[index].favouriteLink,
                                      linkPDFSkachat: snapshot.data!.data.guides
                                          .dataGuides[index].pdfUrl,
                                      linkPDF: snapshot.data!.data.guides
                                          .dataGuides[index].link,
                                      buttonColor:
                                          const Color.fromARGB(255, 213, 0, 50),
                                      topButtonText: 'Скачать',
                                      bottomButtonText: 'Читать',
                                      isFavourite: snapshot.data!.data.guides
                                          .dataGuides[index].isFavourite,
                                      skachat: Container(
                                        alignment: Alignment.center,
                                        width: 94,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            color: const Color(0xff31353b),
                                            borderRadius:
                                                BorderRadius.circular(13)),
                                        child: Text(
                                          'skachat',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 10,
                                              color: const Color(0xffffffff),
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      title: snapshot.data!.data.guides
                                          .dataGuides[index].title,
                                      url: snapshot.data!.data.guides
                                          .dataGuides[index].pictureLink,
                                    )
                                  ],
                                );
                              },
                            ))),
                  StickyHeader(
                      header: snapshot.data!.data.guidesArchive
                              .dataGuidesArchive.isEmpty
                          ? const SizedBox()
                          : Container(
                              decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xffeaeaea),
                                      offset: Offset(0, -3))
                                ],
                                color: Color(0xffeaeaea),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: isTablet ? 20 : 30,
                                    bottom: isTablet ? 9 : 5),
                                child: Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      width: isTablet ? 55.w : 70.w,
                                      height: isTablet ? 46.h : 42.h,
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 213, 0, 50),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(
                                                  isTablet ? 45.r : 21.r),
                                              bottomRight: Radius.circular(
                                                  isTablet ? 45.r : 21.r))),
                                      child: Image.asset(
                                        'assets/Архив.png',
                                        height: isTablet ? 30.h : 30,
                                        width: isTablet ? 30.w : 30,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        '#',
                                        style: GoogleFonts.montserrat(
                                            fontSize: isTablet ? 22 : 20,
                                            fontWeight: FontWeight.w500,
                                            color: const Color.fromARGB(
                                                255, 213, 0, 50)),
                                      ),
                                    ),
                                    Text(
                                      'Архив',
                                      style: GoogleFonts.montserrat(
                                          fontSize: isTablet ? 25 : 20,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xff272624)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                      content: isTablet
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: GridView(
                                controller: scroll,
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10,
                                        mainAxisExtent: 375),
                                children: List.generate(
                                    snapshot.data!.data.guidesArchive
                                        .dataGuidesArchive.length, (index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: StackedStackPrezentatsiyaTab(
                                      buttonLink: snapshot
                                                  .data!
                                                  .data
                                                  .guidesArchive
                                                  .dataGuidesArchive[index]
                                                  .pdfUrl ==
                                              ''
                                          ? const SizedBox()
                                          : Padding(
                                              padding: EdgeInsets.only(
                                                  top: isTablet ? 22.h : 15.h),
                                              child: InkWell(
                                                onTap: () {
                                                  if (snapshot
                                                          .data!
                                                          .data
                                                          .guidesArchive
                                                          .dataGuidesArchive[
                                                              index]
                                                          .pdfUrl
                                                          .contains(".pdf") &&
                                                      snapshot
                                                          .data!
                                                          .data
                                                          .guidesArchive
                                                          .dataGuidesArchive[
                                                              index]
                                                          .pdfUrl
                                                          .contains("google")) {
                                                    String pdfInAppUrl =
                                                        snapshot
                                                            .data!
                                                            .data
                                                            .guidesArchive
                                                            .dataGuidesArchive[
                                                                index]
                                                            .pdfUrl
                                                            .split("url=")[1]
                                                            .split("&")[0];
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              PDFViewer(
                                                                  pdfUrlForPDFViewer:
                                                                      pdfInAppUrl),
                                                        ));
                                                  } else {
                                                    String fullUrl = snapshot
                                                            .data!
                                                            .data
                                                            .guidesArchive
                                                            .dataGuidesArchive[
                                                                index]
                                                            .pdfUrl
                                                            .startsWith("http")
                                                        ? snapshot
                                                            .data!
                                                            .data
                                                            .guidesArchive
                                                            .dataGuidesArchive[
                                                                index]
                                                            .pdfUrl
                                                        : "http://${snapshot.data!.data.guidesArchive.dataGuidesArchive[index].pdfUrl}";

                                                    setState(() {
                                                      launched =
                                                          _launchInBrowser(
                                                              Uri.parse(
                                                                  fullUrl));
                                                    });
                                                  }
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: isTablet ? 100 : 94,
                                                  height: isTablet ? 28 : 25,
                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xff31353b),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              13.r)),
                                                  child: Text(
                                                    'Скачать',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontSize: isTablet
                                                                ? 12
                                                                : 10,
                                                            color: const Color(
                                                                0xffffffff),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                  ),
                                                ),
                                              ),
                                            ),
                                      isFavouriteURL: snapshot
                                          .data!
                                          .data
                                          .guidesArchive
                                          .dataGuidesArchive[index]
                                          .favouriteLink,
                                      linkPDFSkachat: snapshot
                                          .data!
                                          .data
                                          .guidesArchive
                                          .dataGuidesArchive[index]
                                          .pdfUrl,
                                      linkPDF: snapshot.data!.data.guidesArchive
                                          .dataGuidesArchive[index].link,
                                      buttonColor:
                                          const Color.fromARGB(255, 213, 0, 50),
                                      topButtonText: 'Скачать',
                                      bottomButtonText: 'Читать',
                                      isFavourite: snapshot
                                          .data!
                                          .data
                                          .guidesArchive
                                          .dataGuidesArchive[index]
                                          .isFavourite,
                                      skachat: Container(
                                        alignment: Alignment.center,
                                        width: 94,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            color: const Color(0xff31353b),
                                            borderRadius:
                                                BorderRadius.circular(13)),
                                        child: Text(
                                          'skachat',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 10,
                                              color: const Color(0xffffffff),
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      title: snapshot.data!.data.guidesArchive
                                          .dataGuidesArchive[index].title,
                                      url: snapshot.data!.data.guidesArchive
                                          .dataGuidesArchive[index].pictureLink,
                                    ),
                                  );
                                }),
                              ),
                            )
                          : Column(
                              children: List.generate(
                                  snapshot.data!.data.guidesArchive
                                      .dataGuidesArchive.length,
                                  (index) => Column(
                                        children: [
                                          Row(),
                                          ArchiveCard(
                                            downloadButton: snapshot
                                                        .data!
                                                        .data
                                                        .guidesArchive
                                                        .dataGuidesArchive[
                                                            index]
                                                        .pdfUrl ==
                                                    ''
                                                ? const SizedBox()
                                                : Padding(
                                                    padding: EdgeInsets.only(
                                                        top: isTablet
                                                            ? 22.h
                                                            : 15.h),
                                                    child: InkWell(
                                                      onTap: () {
                                                        if (snapshot
                                                          .data!
                                                          .data
                                                          .guidesArchive
                                                          .dataGuidesArchive[
                                                              index]
                                                          .pdfUrl
                                                          .contains(".pdf") &&
                                                      snapshot
                                                          .data!
                                                          .data
                                                          .guidesArchive
                                                          .dataGuidesArchive[
                                                              index]
                                                          .pdfUrl
                                                          .contains("google")) {
                                                    String pdfInAppUrl =
                                                        snapshot
                                                            .data!
                                                            .data
                                                            .guidesArchive
                                                            .dataGuidesArchive[
                                                                index]
                                                            .pdfUrl
                                                            .split("url=")[1]
                                                            .split("&")[0];
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              PDFViewer(
                                                                  pdfUrlForPDFViewer:
                                                                      pdfInAppUrl),
                                                        ));
                                                  } else {
                                                    String fullUrl = snapshot
                                                            .data!
                                                            .data
                                                            .guidesArchive
                                                            .dataGuidesArchive[
                                                                index]
                                                            .pdfUrl
                                                            .startsWith("http")
                                                        ? snapshot
                                                            .data!
                                                            .data
                                                            .guidesArchive
                                                            .dataGuidesArchive[
                                                                index]
                                                            .pdfUrl
                                                        : "http://${snapshot.data!.data.guidesArchive.dataGuidesArchive[index].pdfUrl}";

                                                    setState(() {
                                                      launched =
                                                          _launchInBrowser(
                                                              Uri.parse(
                                                                  fullUrl));
                                                    });
                                                  }
                                                      },
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width:
                                                            isTablet ? 100 : 94,
                                                        height:
                                                            isTablet ? 28 : 25,
                                                        decoration: BoxDecoration(
                                                            color: const Color(
                                                                0xff31353b),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        13.r)),
                                                        child: Text(
                                                          'Скачать',
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  fontSize:
                                                                      isTablet
                                                                          ? 12
                                                                          : 10,
                                                                  color: const Color(
                                                                      0xffffffff),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                            isFavouriteURL: snapshot
                                                .data!
                                                .data
                                                .guidesArchive
                                                .dataGuidesArchive[index]
                                                .favouriteLink,
                                            linkPDFSkachat: snapshot
                                                .data!
                                                .data
                                                .guidesArchive
                                                .dataGuidesArchive[index]
                                                .pdfUrl,
                                            buttonColor: const Color.fromARGB(
                                                255, 213, 0, 50),
                                            topButtonText: 'Скачать',
                                            bottomButtonText: 'Читать',
                                            linkPDF: snapshot
                                                .data!
                                                .data
                                                .guidesArchive
                                                .dataGuidesArchive[index]
                                                .link,
                                            isFavourite: snapshot
                                                .data!
                                                .data
                                                .guidesArchive
                                                .dataGuidesArchive[index]
                                                .isFavourite,
                                            skachat: Container(
                                              alignment: Alignment.center,
                                              width: 94,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xff31353b),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          13)),
                                              child: Text(
                                                'skachat',
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 10,
                                                    color:
                                                        const Color(0xffffffff),
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            title: snapshot
                                                .data!
                                                .data
                                                .guidesArchive
                                                .dataGuidesArchive[index]
                                                .title,
                                            url: snapshot
                                                .data!
                                                .data
                                                .guidesArchive
                                                .dataGuidesArchive[index]
                                                .pictureLink,
                                          )
                                        ],
                                      ))))
                ]),
              );
            } else {
              return Center(
                  child: Lottie.asset(
                'assets/pre.json',
                height: 70,
                width: 70,
              ));
            }
          }),
    );
  }

  _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}
