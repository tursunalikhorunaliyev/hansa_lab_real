import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class StatiComment extends StatefulWidget {
  const StatiComment(
      {Key? key,
      required this.initialRating,
      required this.name,
      required this.comment,
      required this.imageURl,
      
      })
      : super(key: key);
  final double initialRating;
  final String name;
  final String comment;
  final String imageURl;
  @override
  State<StatiComment> createState() => _StatiCommentState();
}

class _StatiCommentState extends State<StatiComment> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: CachedNetworkImage(
                    height: 48.66666666666667,
                    width: 49,
                    imageUrl: widget.imageURl,
                    fit: BoxFit.cover,
                  )),
              const SizedBox(
                width: 14.33333333333333,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: RatingBar.builder(
                        unratedColor: Colors.grey[300],
                        initialRating: widget.initialRating,
                        itemCount: 5,
                        itemSize: 12,
                        itemBuilder: (context, index) {
                          return const Icon(
                            Icons.star,
                            color: Colors.red,
                          );
                        },
                        onRatingUpdate: (value) {
                          log(value.toString());
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  SizedBox(
                    width: 280,
                    child: Text(

                      widget.name,
                      overflow: TextOverflow.clip,
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFF474747),
                        fontSize: 15.65333333333333,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          const SizedBox(
            height: 12.66666666666667,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.comment,
                style: GoogleFonts.montserrat(),
              )),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            height: 5,
            thickness: 2,
            color: Color(0xFFe5e5e5),
          )
        ],
      ),
    );
  }
}
