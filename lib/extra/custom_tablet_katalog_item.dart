import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hansa_lab/extra/custom_bottom_tablet_item.dart';
import 'package:url_launcher/url_launcher.dart';

class TabletKatalogItem extends StatefulWidget {
  const TabletKatalogItem(
      {Key? key,
      required this.imageUrl,
      required this.backgroundColor,
      required this.buttonTextColor,
      required this.buttonColor,
      required this.titleColor,
      required this.stbuttonText,
      required this.ndbuttonText,
      required this.title,
      required this.linkPDF,
      required this.linkPDFSkachat})
      : super(key: key);

  final String imageUrl;
  final Color backgroundColor;
  final Color buttonTextColor;
  final Color buttonColor;
  final Color titleColor;
  final String stbuttonText;
  final String ndbuttonText;
  final String title;
  final String linkPDF;
  final String linkPDFSkachat;

  @override
  State<TabletKatalogItem> createState() => _TabletKatalogItemState();
}

class _TabletKatalogItemState extends State<TabletKatalogItem> {
  @override
  Widget build(BuildContext context) {
    Future<void>? launched;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              launched = _launchInBrowser(
                Uri.parse(widget.linkPDF),
              );
            });
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: CachedNetworkImage(
              imageUrl: widget.imageUrl,
              width: 200.w,
              height: 150.h,
              fit: BoxFit.cover,
            ),
          ),
        ),
        TabletKatalogBottomItem(
          linkPDFSkachat: widget.linkPDFSkachat,
          linkPDF: widget.linkPDF,
          backgroundColor: widget.backgroundColor,
          buttonTextColor: widget.buttonTextColor,
          buttonColor: widget.buttonColor,
          titleColor: widget.titleColor,
          stbuttonText: widget.stbuttonText,
          ndbuttonText: widget.ndbuttonText,
          title: widget.title,
        ),
      ],
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
