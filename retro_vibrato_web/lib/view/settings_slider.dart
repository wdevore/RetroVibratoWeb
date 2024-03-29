import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retro_vibrato_web/model/configuration_inherited_widget.dart';
import 'package:retro_vibrato_web/model/field.dart';
import 'package:retro_vibrato_web/view/custom_slider_thumb_rect.dart';

class SettingsSlider extends StatelessWidget {
  const SettingsSlider({
    Key? key,
    required this.height,
    required this.flex,
  }) : super(key: key);

  final double height;
  final int flex;

  @override
  Widget build(BuildContext context) {
    // final field = context.watch<Field>();
    // Instead of using "watch" above I used a
    // "Consumer" below.
    ConfigurationWidget configWidget = ConfigurationWidget.of(context);

    return Consumer<Field>(
      builder: (_, field, __) => SizedBox(
        height: height,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(right: 2.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: Text(
                      field.label,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      field.value = field.rValue;
                      configWidget.config.aplay();
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: flex,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.orange,
                  inactiveTrackColor: Colors.amberAccent,
                  trackShape: const RectangularSliderTrackShape(),
                  trackHeight: 5.0,
                  thumbColor: Colors.white,
                  thumbShape: CustomSliderThumbRect(
                    thumbRadius: 15.0,
                    thumbHeight: 25,
                    min: field.min,
                    max: field.max,
                    sliderValue: field.value,
                  ),
                  overlayColor: Colors.blue.withAlpha(32),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 28.0),
                ),
                child: Slider(
                  value: field.value,
                  min: field.min,
                  max: field.max,
                  divisions: 200,
                  onChanged: (value) {
                    field.value = value;
                  },
                  onChangeEnd: (value) => configWidget.config.aplay(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
