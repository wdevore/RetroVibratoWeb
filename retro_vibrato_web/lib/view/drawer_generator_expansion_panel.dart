import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retro_vibrato_web/configurations.dart';
import 'package:retro_vibrato_web/model/enums.dart';
import 'package:retro_vibrato_web/model/field.dart';
import 'package:retro_vibrato_web/model/settings_model.dart';

class GeneratorsSubPanel extends StatelessWidget {
  const GeneratorsSubPanel({
    Key? key,
    required this.configurations,
  }) : super(key: key);

  final Configurations configurations;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<GeneratorSettings>();
    const delay = 2000;

    return ExpansionPanelList(
      expandedHeaderPadding: EdgeInsets.zero,
      dividerColor: Colors.white,
      animationDuration: const Duration(milliseconds: 150),
      expansionCallback: (int index, bool isExpanded) {
        if (isExpanded) {
          settings.expanded();
        } else {
          settings.collapsed();
        }
      },
      children: [
        ExpansionPanel(
          canTapOnHeader: true,
          backgroundColor: Colors.lime.shade100,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return const Center(
              child: Text(
                "Generators",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            );
          },
          body: Consumer<Field>(
            builder: (_, gtype, __) => Column(
              children: [
                TextButton(
                  child: Text(
                    'Pickup/Coin',
                    style: TextStyle(
                      color: gtype.value == Generator.pickUp
                          ? Colors.blue[600]
                          : Colors.grey[600],
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    // Note: We play the sound first so that it completes
                    // before we set the gtype. The alternative is to
                    // push the configuration calls into a coroutine.
                    configurations.pickUpOrCoin(true);
                    configurations.aplay();
                    // Future.delayed(const Duration(milliseconds: delay))
                    //     .then((value) => gtype.value = Generator.pickUp);
                    gtype.value = Generator.pickUp;
                  },
                ),
                TextButton(
                  child: Text(
                    'Laser',
                    style: TextStyle(
                      color: gtype.value == Generator.laser
                          ? Colors.blue[600]
                          : Colors.grey[600],
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    configurations.laserShoot();
                    configurations.aplay();
                    gtype.value = Generator.laser;
                  },
                ),
                TextButton(
                  child: Text(
                    'Explosion',
                    style: TextStyle(
                      color: gtype.value == Generator.explosion
                          ? Colors.blue[600]
                          : Colors.grey[600],
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    configurations.explosion();
                    configurations.aplay();
                    gtype.value = Generator.explosion;
                  },
                ),
                TextButton(
                  child: Text(
                    'PowerUp',
                    style: TextStyle(
                      color: gtype.value == Generator.powerUp
                          ? Colors.blue[600]
                          : Colors.grey[600],
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    configurations.powerUp();
                    configurations.aplay();
                    gtype.value = Generator.powerUp;
                  },
                ),
                TextButton(
                  child: Text(
                    'Hit',
                    style: TextStyle(
                      color: gtype.value == Generator.hit
                          ? Colors.blue[600]
                          : Colors.grey[600],
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    configurations.hitHurt();
                    configurations.aplay();
                    gtype.value = Generator.hit;
                  },
                ),
                TextButton(
                  child: Text(
                    'Blip',
                    style: TextStyle(
                      color: gtype.value == Generator.blip
                          ? Colors.blue[600]
                          : Colors.grey[600],
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    configurations.blipSelect();
                    configurations.aplay();
                    gtype.value = Generator.blip;
                  },
                ),
                TextButton(
                  child: Text(
                    'Synth',
                    style: TextStyle(
                      color: gtype.value == Generator.synth
                          ? Colors.blue[600]
                          : Colors.grey[600],
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    configurations.synth();
                    configurations.aplay();
                    gtype.value = Generator.synth;
                  },
                ),
                TextButton(
                  child: Text(
                    'Random',
                    style: TextStyle(
                      color: gtype.value == Generator.random
                          ? Colors.blue[600]
                          : Colors.grey[600],
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    configurations.random();
                    configurations.aplay();
                    gtype.value = Generator.random;
                  },
                ),
                TextButton(
                  child: Text(
                    'Tone',
                    style: TextStyle(
                      color: gtype.value == Generator.tone
                          ? Colors.blue[600]
                          : Colors.grey[600],
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    configurations.tone(440, WaveForm.sine);
                    configurations.aplay();
                    gtype.value = Generator.tone;
                  },
                ),
                TextButton(
                  child: Text(
                    'Mutate',
                    style: TextStyle(
                      color: gtype.value == Generator.mutate
                          ? Colors.blue[400]
                          : Colors.grey[600],
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    configurations.mutate();
                    configurations.aplay();
                    gtype.value = Generator.mutate;
                  },
                ),
              ],
            ),
          ),
          isExpanded: settings.isExpanded,
        ),
      ],
    );
  }
}
