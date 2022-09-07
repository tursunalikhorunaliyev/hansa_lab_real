import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:hansa_lab/blocs/login_anim_bloc.dart';
import 'package:hansa_lab/extra/login_card.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//
class FlipAnim extends StatefulWidget {
  const FlipAnim({Key? key}) : super(key: key);

  @override
  State<FlipAnim> createState() => _FlipAnimState();
}

class _FlipAnimState extends State<FlipAnim> {
  GlobalKey<FlipCardState> flipKeyv = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginAnimBloc>(context);
    final providerFlip = Provider.of<FlipCardController>(context);
    return StreamBuilder<double>(
        stream: provider.stream,
        initialData: -600,
        builder: (context, snapshot) {
          return AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            bottom: snapshot.data!.toDouble().h,
            left: 15.w,
            right: 15.w,
            child: FlipCard(
              controller: providerFlip,
              key: flipKeyv,
              flipOnTouch: false,
              front: const SizedBox(),
              back: const LoginCard(),
            ),
          );
        });
  }
}
