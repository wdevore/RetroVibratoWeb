import 'package:flutter/material.dart';
import 'package:retro_vibrato_web/configurations.dart';

class ConfigurationWidget extends InheritedWidget {
  const ConfigurationWidget({
    super.key,
    required this.config,
    required super.child,
  });

  final Configurations config;

  static ConfigurationWidget? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ConfigurationWidget>();
  }

  static ConfigurationWidget of(BuildContext context) {
    final ConfigurationWidget? result = maybeOf(context);
    assert(result != null, 'No ConfigurationWidget found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ConfigurationWidget oldWidget) => false;
}
