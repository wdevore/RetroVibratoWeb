// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retro_vibrato_web/model/settings_model.dart';
import 'package:retro_vibrato_web/view/settings_slider.dart';

class ArpeggiationExpansionPanelList extends StatelessWidget {
  const ArpeggiationExpansionPanelList({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<ArpeggiationSettings>();

    return ExpansionPanelList(
      expandedHeaderPadding: EdgeInsets.zero,
      dividerColor: Colors.white,
      animationDuration: const Duration(milliseconds: 200),
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
          backgroundColor: Colors.grey,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              isThreeLine: false,
              title: Container(
                alignment: Alignment.center,
                color: Colors.black26,
                padding: const EdgeInsets.only(top: 2, bottom: 2),
                child: Text(
                  settings.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent,
                  ),
                ),
              ),
            );
          },
          body: Column(
            children: [
              ChangeNotifierProvider.value(
                value: settings.multiplier,
                child: const SettingsSlider(),
              ),
              ChangeNotifierProvider.value(
                value: settings.speed,
                child: const SettingsSlider(),
              ),
            ],
          ),
          isExpanded: settings.isExpanded,
        ),
      ],
    );
  }

  void updateAttackFieldValue(dynamic value) {}
}
