import 'package:flutter/material.dart';

class PlayButtonStatelessWidget extends StatelessWidget {
  const PlayButtonStatelessWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      margin: const EdgeInsets.only(top: kToolbarHeight),
      child: FloatingActionButton(
        onPressed: () {
          // var counter = context.read<Counter>();
          // counter.increment();
          // debugPrint('Play');
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
