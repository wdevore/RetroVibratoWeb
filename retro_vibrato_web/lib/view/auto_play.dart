import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retro_vibrato_web/model/settings_model.dart';

class SettingsAutoplayCheck extends StatelessWidget {
  const SettingsAutoplayCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Field>(
      builder: (_, autoplay, __) => Container(
        decoration: BoxDecoration(color: Colors.lime.shade300),
        child: CheckboxListTile(
          title: const Text(
            'Auto Play',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          value: autoplay.value,
          onChanged: (bool? value) {
            autoplay.value = value!;
          },
          secondary: const Icon(
            Icons.play_arrow_outlined,
            size: 30,
          ),
        ),
      ),
    );
  }
}
