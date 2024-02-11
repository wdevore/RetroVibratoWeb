import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'enums.dart';

class Field with ChangeNotifier {
  double min = 0.0;
  double max = 1.0;

  dynamic _value = 0;
  dynamic rValue = 0;

  String label = "";

  Field(this.min, this.max, this._value, this.label) {
    rValue = _value;
  }
  Field.noRange(this._value, this.label) {
    rValue = _value;
  }

  set value(dynamic v) {
    _value = v;
    notifyListeners();
  }

  dynamic get value => _value;

  reset() {
    value = rValue;
  }
}

class EnvelopeSettings with ChangeNotifier {
  final String title = "Envelope";
  // Indicates if a slider panel is visible or not.
  bool _isExpanded = false;

  final Field attack = Field(0.0, 1.0, 0.0, "Attack");
  final Field sustain = Field(0.0, 1.0, 0.0, "Sustain");
  final Field punch = Field(0.0, 1.0, 0.0, "Punch");
  final Field decay = Field(0.0, 1.0, 0.0, "Decay");

  bool get isExpanded {
    return _isExpanded;
  }

  void expanded() {
    _isExpanded = true;
    notifyListeners();
  }

  void collapsed() {
    _isExpanded = false;
    notifyListeners();
  }
}

class FrequencySettings with ChangeNotifier {
  final String title = "Frequency";

  final Field frequency = Field(0.04, 2.0, 0.04, "Frequency");
  final Field minCutoff = Field(0.0, 1.0, 0.0, "MinCutoff");
  final Field slide = Field(-1.0, 1.0, 0.0, "Slide");
  final Field deltaSlide = Field(-1.0, 1.0, 0.0, "DeltaSlide");

  bool _isExpanded = false;
  bool get isExpanded {
    return _isExpanded;
  }

  void expanded() {
    _isExpanded = true;
    notifyListeners();
  }

  void collapsed() {
    _isExpanded = false;
    notifyListeners();
  }
}

class VibratoSettings with ChangeNotifier {
  final String title = "Vibrato";
  final Field depth = Field(0.0, 1.0, 0.0, "Depth");
  final Field speed = Field(0.0, 1.0, 0.0, "Speed");

  bool _isExpanded = false;
  bool get isExpanded {
    return _isExpanded;
  }

  void expanded() {
    _isExpanded = true;
    notifyListeners();
  }

  void collapsed() {
    _isExpanded = false;
    notifyListeners();
  }
}

class ArpeggiationSettings with ChangeNotifier {
  final String title = "Arpeggiation";
  final Field multiplier = Field(-1.0, 1.0, 0.0, "Multiplier");
  final Field speed = Field(0.0, 1.0, 0.0, "Speed");

  bool _isExpanded = false;
  bool get isExpanded {
    return _isExpanded;
  }

  void expanded() {
    _isExpanded = true;
    notifyListeners();
  }

  void collapsed() {
    _isExpanded = false;
    notifyListeners();
  }
}

class DutyCycleSettings with ChangeNotifier {
  final String title = "DutyCycle";
  final Field dutyCycle = Field(0.0, 1.0, 0.0, "DutyCycle");
  final Field sweep = Field(-1.0, 1.0, 0.0, "Sweep");

  bool _isExpanded = false;
  bool get isExpanded {
    return _isExpanded;
  }

  void expanded() {
    _isExpanded = true;
    notifyListeners();
  }

  void collapsed() {
    _isExpanded = false;
    notifyListeners();
  }
}

class RetriggerSettings with ChangeNotifier {
  final String title = "Retrigger";
  final Field rate = Field(0.0, 0.96, 0.0, "Rate");

  bool _isExpanded = false;
  bool get isExpanded {
    return _isExpanded;
  }

  void expanded() {
    _isExpanded = true;
    notifyListeners();
  }

  void collapsed() {
    _isExpanded = false;
    notifyListeners();
  }
}

class FlangerSettings with ChangeNotifier {
  final String title = "Flanger";
  final Field offset = Field(-1.0, 1.0, 0.0, "Offset");
  final Field sweep = Field(-1.0, 1.0, 0.0, "Sweep");

  bool _isExpanded = false;
  bool get isExpanded {
    return _isExpanded;
  }

  void expanded() {
    _isExpanded = true;
    notifyListeners();
  }

  void collapsed() {
    _isExpanded = false;
    notifyListeners();
  }
}

class LowPassFilterSettings with ChangeNotifier {
  final String title = "LowPass Filter";
  final Field cutoffFreq = Field(0.0, 1.0, 0.0, "CutoffFreq");
  final Field cutoffSweep = Field(-1.0, 1.0, 0.0, "CutoffSweep");
  final Field resonance = Field(0.035, 1.0, 0.035, "Resonance");

  bool _isExpanded = false;
  bool get isExpanded {
    return _isExpanded;
  }

  void expanded() {
    _isExpanded = true;
    notifyListeners();
  }

  void collapsed() {
    _isExpanded = false;
    notifyListeners();
  }
}

class HighPassFilterSettings with ChangeNotifier {
  final String title = "HighPass Filter";
  final Field cutoffFreq = Field(0.0, 1.0, 0.0, "CutoffFreq");
  final Field cutoffSweep = Field(-1.0, 1.0, 0.0, "CutoffSweep");

  bool _isExpanded = false;
  bool get isExpanded {
    return _isExpanded;
  }

  void expanded() {
    _isExpanded = true;
    notifyListeners();
  }

  void collapsed() {
    _isExpanded = false;
    notifyListeners();
  }
}

class SampleRateSettings with ChangeNotifier {
  // final String title = "Sample Rate";
  final Field rate = Field.noRange(SampleRate.kHz44, "Sample Rate");

  bool _isExpanded = false;
  bool get isExpanded {
    return _isExpanded;
  }

  void expanded() {
    _isExpanded = true;
    notifyListeners();
  }

  void collapsed() {
    _isExpanded = false;
    notifyListeners();
  }
}

class AppSettings {
  final Field name = Field.noRange("", "Name");
  final Field sfxrFile = Field.noRange("", "Sfxr File");
  final Field waveFile = Field.noRange("", "Wave File");
  final Field destEmail = Field.noRange("", "Destination Email");
  final Field autoplay = Field.noRange(true, "Auto Play");
  // final Field sampleRate = Field.noRange(SampleRate.kHz44, "Sample Rate");
  final sampleRateSettings = SampleRateSettings();
  final Field sampleSize = Field.noRange(8, "Sample Size");
  final Field volume = Field.noRange(0.5, "Auto Play");
  final Field generator = Field.noRange(Generator.none, "None");
  final Field wave = Field.noRange(WaveForm.none, "None");
}

class SettingsModel with ChangeNotifier {
  final appSettings = AppSettings();
  final frequencySettings = FrequencySettings();
  final vibratoSettings = VibratoSettings();
  final arpeggiationSettings = ArpeggiationSettings();
  final dutyCycleSettings = DutyCycleSettings();
  final retriggerSettings = RetriggerSettings();
  final flangerSettings = FlangerSettings();
  final lowPassFilterSettings = LowPassFilterSettings();
  final highPassFilterSettings = HighPassFilterSettings();
  final envelopeSettings = EnvelopeSettings();

  void fromJson(String json) {
    var jSettings = jsonDecode(json);

    appSettings.name.value = jSettings["Name"];
    appSettings.generator.value = _categoryToGenerator(jSettings["Category"]);
    appSettings.wave.value = _waveToGenerator(jSettings["WaveShape"]);
    appSettings.sampleRateSettings.rate.value = jSettings["SampleRate"];
    appSettings.sampleSize.value = jSettings["SampleSize"];
    appSettings.volume.value = jSettings["SoundVolume"];

    // Frequency
    frequencySettings.frequency.value = jSettings["BaseFrequency"];
    frequencySettings.minCutoff.value = jSettings["FrequencyLimit"];
    frequencySettings.slide.value = jSettings["FrequencyRamp"];
    frequencySettings.deltaSlide.value = jSettings["FrequencyDeltaRamp"];

    // Vibrator
    vibratoSettings.depth.value = jSettings["VibratoStrength"];
    vibratoSettings.speed.value = jSettings["VibratoSpeed"];

    // Arpeggiation
    arpeggiationSettings.multiplier.value = jSettings["ArpeggioMod"];
    arpeggiationSettings.speed.value = jSettings["ArpeggioSpeed"];

    // DutyCycle
    dutyCycleSettings.dutyCycle.value = jSettings["DutyCycle"];
    dutyCycleSettings.sweep.value = jSettings["DutyCycleRamp"];

    // Retrigger
    retriggerSettings.rate.value = jSettings["RepeatSpeed"];

    // Flanger
    flangerSettings.offset.value = jSettings["FlangerPhaseOffset"];
    flangerSettings.sweep.value = jSettings["FlangerPhaseRamp"];

    // LowPass
    lowPassFilterSettings.cutoffFreq.value =
        jSettings["LowPassFilterFrequency"];
    lowPassFilterSettings.cutoffSweep.value =
        jSettings["LowPassFilterFrequencyRamp"];
    lowPassFilterSettings.resonance.value =
        jSettings["LowPassFilterFrequencyResonance"];

    // HighPass
    highPassFilterSettings.cutoffFreq.value =
        jSettings["HighPassFilterFrequency"];
    highPassFilterSettings.cutoffSweep.value =
        jSettings["HighPassFilterFrequencyRamp"];

    // Envelope
    envelopeSettings.attack.value = jSettings["EnvelopeAttack"];
    envelopeSettings.sustain.value = jSettings["EnvelopeSustain"];
    envelopeSettings.punch.value = jSettings["EnvelopePunch"];
    envelopeSettings.decay.value = jSettings["EnvelopeDecay"];
  }

  Generator _categoryToGenerator(String cat) {
    switch (cat) {
      case "PickUp":
        return Generator.pickUp;
      case "Laser":
        return Generator.laser;
      case "Explosion":
        return Generator.explosion;
      case "PowerUp":
        return Generator.powerUp;
      case "Hit":
        return Generator.hit;
      case "Blip":
        return Generator.blip;
      case "Synth":
        return Generator.synth;
      case "Random":
        return Generator.random;
      case "Tone":
        return Generator.tone;
      case "Mutate":
        return Generator.mutate;
      default:
        return Generator.none;
    }
  }

  WaveForm _waveToGenerator(int wave) {
    switch (wave) {
      case 0:
        return WaveForm.square;
      case 1:
        return WaveForm.triangle;
      case 2:
        return WaveForm.sine;
      case 3:
        return WaveForm.sawtoothFalling;
      case 4:
        return WaveForm.whiteNoise;
      case 5:
        return WaveForm.pinkNoise;
      case 6:
        return WaveForm.redNoise; // Brownian/red
      case 7:
        return WaveForm.sawtoothRising;
      default:
        return WaveForm.none;
    }
  }
}
