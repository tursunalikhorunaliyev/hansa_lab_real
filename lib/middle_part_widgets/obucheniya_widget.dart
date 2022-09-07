import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/api_models.dart/obucheniya_model_api.dart';
import 'package:hansa_lab/api_services/welcome_api.dart';
import 'package:hansa_lab/blocs/bloc_obucheniya.dart';
import 'package:hansa_lab/extra/custom_obucheniya_card.dart';
import 'package:hansa_lab/obucheniyaTab.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ObucheniyaWidget extends StatelessWidget {
  const ObucheniyaWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    final token = Provider.of<String>(context);
    final bloc = Provider.of<BlocObucheniya>(context);
    bloc.eventSink.add(ObucheniyaEnum.obucheniya);
    final welcomeApi = WelcomeApi(token);
    welcomeApi.eventSink.add(WelcomeApiAction.fetch);
    final scroll = ScrollController();

    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
              children: List.generate(
            1,
            (index) {
              return StreamBuilder<ObucheniyaModel>(
                  stream: bloc.stream,
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return Column(
                        children: [
                          StickyHeader(
                            header: Container(
                              color: const Color(0xffeaeaea),
                              child: Padding(
                                padding: EdgeInsets.only(top: 9.h, bottom: 5.h),
                                child: Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      width: isTablet ? 55.w : 70.w,
                                      height: isTablet ? 46.h : 42.h,
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(255, 213, 0, 50),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(
                                                  isTablet ? 45.r : 21.r),
                                              bottomRight: Radius.circular(
                                                  isTablet ? 45.r : 21.r))),
                                      child: Image.asset(
                                        'assets/free-icon-academic-2599288.png',
                                        height: 30.h,
                                        width: 30.w,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.w),
                                      child: Text('#',
                                          style: GoogleFonts.montserrat(
                                            fontSize: isTablet ? 10.sp : 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color.fromARGB(255, 213, 0, 50),
                                          )),
                                    ),
                                    Text(
                                      'Обучающие материалы ',
                                      style: GoogleFonts.montserrat(
                                          fontSize: isTablet ? 12.sp : 19.sp,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xff272624)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            content: isTablet
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    child: GridView(
                                      controller: scroll,
                                      shrinkWrap: true,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 10,
                                              mainAxisExtent: 375),
                                      children: List.generate(
                                          snapshot.data!.data.listGuides.list
                                              .length, (index) {
                                        return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: StackedStackObuch(
                                                isFavouriteURL: snapshot
                                                    .data!
                                                    .data
                                                    .listGuides
                                                    .list[index]
                                                    .favouriteLink,
                                                buttonColor:
                                                    const Color.fromARGB(255, 213, 0, 50),
                                                bottomButtonText: 'скачать ',
                                                title: snapshot
                                                    .data!
                                                    .data
                                                    .listGuides
                                                    .list[index]
                                                    .title,
                                                url: snapshot
                                                    .data!
                                                    .data
                                                    .listGuides
                                                    .list[index]
                                                    .pictureLink,
                                                isFavourite: snapshot
                                                    .data!
                                                    .data
                                                    .listGuides
                                                    .list[index]
                                                    .isFavourite,
                                                linkPDF: snapshot
                                                    .data!
                                                    .data
                                                    .listGuides
                                                    .list[index]
                                                    .pdfUrl));
                                      }),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      Row(),
                                      Column(children: [
                                        ObucheniyaCard(
                                            isFavouriteURL: snapshot
                                                .data!
                                                .data
                                                .listGuides
                                                .list[index]
                                                .favouriteLink,
                                            buttonColor:
                                                const Color.fromARGB(255, 213, 0, 50),
                                            bottomButtonText: 'скачать ',
                                            title: snapshot.data!.data
                                                .listGuides.list[index].title,
                                            url: snapshot.data!.data.listGuides
                                                .list[index].pictureLink,
                                            isFavourite: snapshot
                                                .data!
                                                .data
                                                .listGuides
                                                .list[index]
                                                .isFavourite,
                                            linkPDF: snapshot.data!.data
                                                .listGuides.list[index].pdfUrl)
                                      ]),
                                    ],
                                  ),
                          ),
                          StickyHeader(
                            header: Container(
                              color: const Color(0xffeaeaea),
                              child: Padding(
                                padding: EdgeInsets.only(top: 9.h, bottom: 5.h),
                                child: Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      width: isTablet ? 55.w : 70.w,
                                      height: isTablet ? 46.h : 42.h,
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(255, 213, 0, 50),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(
                                                  isTablet ? 45.r : 21.r),
                                              bottomRight: Radius.circular(
                                                  isTablet ? 45.r : 21.r))),
                                      child: Image.asset(
                                        'assets/Архив.png',
                                        height: 30.h,
                                        width: 30.w,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.w),
                                      child: Text(
                                        '#',
                                        style: GoogleFonts.montserrat(
                                            fontSize: isTablet ? 10.sp : 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color.fromARGB(255, 213, 0, 50)),
                                      ),
                                    ),
                                    Text(
                                      'Архив',
                                      style: GoogleFonts.montserrat(
                                          fontSize: isTablet ? 12.sp : 20.sp,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xff272624)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            content: isTablet
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    child: GridView(
                                      controller: scroll,
                                      shrinkWrap: true,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 10,
                                              mainAxisExtent: 375),
                                      children: List.generate(
                                          snapshot.data!.data.listArchiveGuides
                                              .list.length, (index) {
                                        return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: StackedStackObuch(
                                                isFavouriteURL: snapshot
                                                    .data!
                                                    .data
                                                    .listArchiveGuides
                                                    .list[index]
                                                    .favouriteLink,
                                                buttonColor:
                                                    const Color.fromARGB(255, 213, 0, 50),
                                                bottomButtonText: 'скачать ',
                                                title: snapshot
                                                    .data!
                                                    .data
                                                    .listArchiveGuides
                                                    .list[index]
                                                    .title,
                                                url: snapshot
                                                    .data!
                                                    .data
                                                    .listArchiveGuides
                                                    .list[index]
                                                    .pictureLink,
                                                isFavourite: snapshot
                                                    .data!
                                                    .data
                                                    .listArchiveGuides
                                                    .list[index]
                                                    .isFavourite,
                                                linkPDF: snapshot
                                                    .data!
                                                    .data
                                                    .listArchiveGuides
                                                    .list[index]
                                                    .pdfUrl));
                                      }),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      Row(),
                                      Column(
                                        children: [
                                          ObucheniyaCard(
                                              isFavouriteURL: snapshot
                                                  .data!
                                                  .data
                                                  .listArchiveGuides
                                                  .list[index]
                                                  .favouriteLink,
                                              buttonColor:
                                                  const Color.fromARGB(255, 213, 0, 50),
                                              bottomButtonText: 'скачать ',
                                              title: snapshot
                                                  .data!
                                                  .data
                                                  .listArchiveGuides
                                                  .list[index]
                                                  .title,
                                              url: snapshot
                                                  .data!
                                                  .data
                                                  .listArchiveGuides
                                                  .list[index]
                                                  .pictureLink,
                                              isFavourite: snapshot
                                                  .data!
                                                  .data
                                                  .listArchiveGuides
                                                  .list[index]
                                                  .isFavourite,
                                              linkPDF: snapshot
                                                  .data!
                                                  .data
                                                  .listArchiveGuides
                                                  .list[index]
                                                  .pdfUrl.toString().isEmpty?snapshot
                                                  .data!
                                                  .data
                                                  .listArchiveGuides
                                                  .list[index]
                                                  .link:snapshot
                                                  .data!
                                                  .data
                                                  .listArchiveGuides
                                                  .list[index]
                                                  .pdfUrl)
                                        ],
                                      )
                                    ],
                                  ),
                          ),
                        ],
                      );
                    } else {
                      bloc.eventSink.add(ObucheniyaEnum.obucheniya);
                      welcomeApi.eventSink.add(WelcomeApiAction.fetch);
                      return Padding(
                        padding: EdgeInsets.only(
                            top:
                                (MediaQuery.of(context).size.height / 2) - 135),
                        child: Center(
                          child: Lottie.asset(
                            'assets/pre.json',
                            height: 70,
                            width: 70,
                          ),
                        ),
                      );
                    }
                  });
            },
          )),
        ),
      ),
    );
  }
}
