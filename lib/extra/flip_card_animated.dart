import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class FlipCardAnimated extends StatefulWidget {
  const FlipCardAnimated({Key? key}) : super(key: key);

  @override
  State<FlipCardAnimated> createState() => _FlipCardAnimatedState();
}

class _FlipCardAnimatedState extends State<FlipCardAnimated> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlipCard(
        key: cardKey,
        flipOnTouch: false,
        front: TextButton(
          onPressed: () => cardKey.currentState!.toggleCard(),
          child: const Text('Toggle'),
        ),
        back: const Text('Back'),
      ),
    );
  }
}
