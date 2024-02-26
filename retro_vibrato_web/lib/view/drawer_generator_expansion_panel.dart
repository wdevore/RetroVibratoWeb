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
                    gtype.value = Generator.pickUp;
                    configurations.pickUpOrCoin(true);
                    configurations.config();
                    configurations.generate();
                    // TODO stream or save samples.
                    // Save as wave for testing
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
