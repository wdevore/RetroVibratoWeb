import 'package:flutter/material.dart';
import 'package:retro_vibrato_web/configurations.dart';

class PlayButtonStatelessWidget extends StatelessWidget {
  final Configurations conf;

  const PlayButtonStatelessWidget({
    super.key,
    required this.conf,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      margin: const EdgeInsets.only(top: kToolbarHeight),
      child: FloatingActionButton(
        onPressed: () {
          conf.play();
        },
        tooltip: 'Play sound',
        backgroundColor: Colors.lime,
        child: const Icon(
          Icons.play_arrow,
          size: 50,
          color: Colors.blue,
        ),
      ),
    );
  }
}
