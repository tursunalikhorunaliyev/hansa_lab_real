import 'package:flutter/material.dart';
import 'package:hansa_lab/api_models.dart/catalog_model.dart';
import 'package:hansa_lab/api_services/catalog_api.dart';
import 'package:hansa_lab/extra/custom_katalog_item_double.dart';
import 'package:hansa_lab/extra/custom_tablet_katalog_item.dart';
import 'package:hansa_lab/extra/custom_title.dart';
import 'package:hansa_lab/extra/my_behavior%20.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Katalogi extends StatefulWidget {
  const Katalogi({Key? key}) : super(key: key);

  @override
  State<Katalogi> createState() => _KatalogiState();
}

class _KatalogiState extends State<Katalogi> {
  @override
  Widget build(BuildContext context) {
    final token = Provider.of<String>(context);
    final isTablet = Provider.of<bool>(context);
    final catalogBloc = CatalogBloc(token);
    final scroll = ScrollController();
    catalogBloc.eventSink.add(CatalogAction.get);
    return Expanded(
      child: StreamBuilder<CatalogModel>(
          stream: catalogBloc.dataStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!.data;
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    StickyHeader(
                      header: const CustomTitle(
                        imagePath: "assets/katalogi_title.png",
                        title: "Каталоги",
                      ),
                      content: isTablet
                          ? ScrollConfiguration(
                              behavior: MyBehavior(),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: GridView(
                                  controller: scroll,
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 22,
                                          mainAxisExtent: 240.h),
                                  children: List.generate(
                                      data.guides.list.length, (index) {
                                    return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5.0),
                                        child: TabletKatalogItem(
                                          linkPDFSkachat: snapshot.data!.data
                                              .guides.list[index].pdfUrl,
                                          linkPDF: snapshot.data!.data.guides
                                              .list[index].link,
                                          imageUrl: data
                                              .guides.list[index].pictureLink,
                                          backgroundColor:
                                              const Color(0xff000004),
                                          buttonTextColor:
                                              const Color(0xffffffff),
                                          buttonColor: const Color.fromARGB(
                                              255, 213, 0, 50),
                                          titleColor: const Color(0xffffffff),
                                          title: data.guides.list[index].title,
                                          stbuttonText: "Скачать",
                                          ndbuttonText: "Читать",
                                        ));
                                  }),
                                ),
                              ))
                          : Column(
                              children: List.generate(data.guides.list.length,
                                  (index) {
                                return CustomKatalogItemDouble(
                                  linkPDFSkachat: snapshot
                                      .data!.data.guides.list[index].pdfUrl,
                                  linkPDF: snapshot
                                      .data!.data.guides.list[index].link,
                                  imageUrl: data.guides.list[index].pictureLink,
                                  backgroundColor: const Color(0xff000004),
                                  buttonTextColor: const Color(0xffffffff),
                                  buttonColor:
                                      const Color.fromARGB(255, 213, 0, 50),
                                  titleColor: const Color(0xffffffff),
                                  title: data.guides.list[index].title,
                                  stbuttonText: "Скачать",
                                  ndbuttonText: "Читать",
                                );
                              }),
                            ),
                    ),
                    StickyHeader(
                      header: const CustomTitle(
                        imagePath: "assets/katalogi_title.png",
                        title: "Архив",
                      ),
                      content: isTablet
                          ? ScrollConfiguration(
                              behavior: MyBehavior(),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: GridView(
                                  controller: scroll,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 22,
                                          mainAxisExtent: 240.h),
                                  children: List.generate(
                                      snapshot.data!.data.guidesArchive.list
                                          .length, (index) {
                                    return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5.0),
                                        child: TabletKatalogItem(
                                          linkPDFSkachat: snapshot.data!.data
                                              .guidesArchive.list[index].pdfUrl,
                                          linkPDF: snapshot.data!.data
                                              .guidesArchive.list[index].link,
                                          imageUrl: data.guidesArchive
                                              .list[index].pictureLink,
                                          backgroundColor:
                                              const Color(0xff000004),
                                          buttonTextColor:
                                              const Color(0xffffffff),
                                          buttonColor: const Color.fromARGB(
                                              255, 213, 0, 50),
                                          titleColor: const Color(0xffffffff),
                                          title: data
                                              .guidesArchive.list[index].title,
                                          stbuttonText: "Скачать",
                                          ndbuttonText: "Читать",
                                        ));
                                  }),
                                ),
                              ))
                          : Column(
                              children: List.generate(
                                  data.guidesArchive.list.length, (index) {
                                return CustomKatalogItemDouble(
                                  linkPDFSkachat: snapshot.data!.data
                                      .guidesArchive.list[index].pdfUrl,
                                  linkPDF: snapshot.data!.data.guidesArchive
                                      .list[index].link,
                                  imageUrl: data
                                      .guidesArchive.list[index].pictureLink,
                                  backgroundColor: const Color(0xff000004),
                                  buttonTextColor: const Color(0xffffffff),
                                  buttonColor:
                                      const Color.fromARGB(255, 213, 0, 50),
                                  titleColor: const Color(0xffffffff),
                                  title: data.guidesArchive.list[index].title,
                                  stbuttonText: "Скачать",
                                  ndbuttonText: "Читать",
                                );
                              }),
                            ),
                    ),
                  ],
                ),
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
}
