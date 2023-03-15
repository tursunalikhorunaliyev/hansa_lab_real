
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/extra/top_video_widget.dart';
import 'package:hansa_lab/video/bloc_video_api.dart';
import 'package:hansa_lab/video/model_video.dart';
import 'package:provider/provider.dart';

//salom dunyo
class CustomVideoListItem extends StatefulWidget {
  final int index;
  final int indexMain;
  final String selectedTitle;

  const CustomVideoListItem(
      {Key? key,
      required this.index,
      required this.indexMain,
      required this.selectedTitle})
      : super(key: key);

  @override
  State<CustomVideoListItem> createState() => _CustomVideoListItemState();
}

class _CustomVideoListItemState extends State<CustomVideoListItem> {
  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    final token = Provider.of<String>(context);
    final blocVideoApi = BlocVideoApi();
    print(token);
    print('token');
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 12, right: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: isTablet ? 420 : 220,
          color: Colors.white,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: isTablet ? 240 : 130,
                  width: isTablet ? 420 : 220,
                  child: FutureBuilder<VideoMainOne>(
                      future: blocVideoApi.getData(token: token),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: snapshot
                                    .data!
                                    .videoListData
                                    .list[widget.indexMain]
                                    .data
                                    .list[widget.index]
                                    .pictureLink,
                                height: isTablet ? 240 : 130,
                                width: isTablet ? 420 : 220,
                                fit: BoxFit.cover,
                              ),
                              InkWell(
                                onTap: () {
                                  print(widget.indexMain);
                                  print(widget.index);
                                  final VideoDetails video = snapshot
                                      .data!
                                      .videoListData
                                      .list[widget.indexMain]
                                      .data
                                      .list[widget.index];
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Scaffold(
                                        backgroundColor: Colors.transparent,
                                        body: Provider<String>.value(
                                          value: token,
                                          child: TopVideoWidget(
                                            url: video.videoLink,
                                            title: video.title,
                                            selectedIndex: widget.index,
                                            selectedTitle: widget.selectedTitle,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Center(
                                  child: Container(
                                    height: isTablet ? 240 : 130,
                                    width: isTablet ? 420 : 220,
                                    color: Colors.transparent,
                                    alignment: Alignment.center,
                                    child: Opacity(
                                      opacity: .5,
                                      child: Icon(
                                        CupertinoIcons.play_circle_fill,
                                        size: isTablet ? 45 : 25,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                ),
              ),
              FutureBuilder<VideoMainOne>(
                  future: blocVideoApi.getData(token: token),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return const SizedBox();
                    } else {
                      return Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(11),
                        child: Text(
                          snapshot.data!.videoListData.list[widget.indexMain]
                              .data.list[widget.index].title,
                          maxLines: 3,
                          style: GoogleFonts.montserrat(
                              fontSize: isTablet ? 16 : 10,
                              color: const Color(0xff4e5258),
                              fontWeight: FontWeight.w600),
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
