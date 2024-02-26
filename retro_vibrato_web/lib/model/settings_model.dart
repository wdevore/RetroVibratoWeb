import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:retro_vibrato_web/model/field.dart';

import 'enums.dart';

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
    update();
  }

  void collapsed() {
    _isExpanded = false;
    update();
  }

  void update() {
    notifyListeners();
  }

  void reset() {
    attack.reset();
    sustain.reset();
    punch.reset();
    decay.reset();
  }

  void defaults() {
    attack.value = 0.0;
    sustain.value = 0.3;
    punch.value = 0.0;
    decay.value = 0.4;
  }
}

// Tone
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

  void reset() {
    frequency.reset();
    minCutoff.reset();
    slide.reset();
    deltaSlide.reset();
  }

  void defaults() {
    frequency.value = 0.3;
    minCutoff.value = 0.0; // Limit
    slide.value = 0.0; // Ramp
    deltaSlide.value = 0.0; // Delta ramp
  }
}

// Vibrato
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

  void reset() {
    depth.reset();
    speed.reset();
  }

  void defaults() {
    depth.value = 0.0; // Strength
    speed.value = 0.0;
  }
}

// Tonal change
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

  void reset() {
    multiplier.reset();
    speed.reset();
  }

  void defaults() {
    multiplier.value = 0.0; // Mod
    speed.value = 0.0;
  }
}

// Square wave duty (proportion of time signal is high vs. low)
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

  void reset() {
    dutyCycle.reset();
    sweep.reset();
  }

  void defaults() {
    // Square wave duty (proportion of time signal is high vs. low)
    dutyCycle.value = 0.5; // Square duty
    sweep.value = 0.0; // Ramp
  }
}

// Repeat
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

  void reset() {
    rate.reset();
  }

  void defaults() {
    rate.value = 0.0; // Repeat speed
  }
}

// Flanger
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

  void reset() {
    offset.reset();
    sweep.reset();
  }

  void defaults() {
    offset.value = 0.0; // Phase offset
    sweep.value = 0.0; // Phase ramp
  }
}

// Low-pass filter
class LowPassFilterSettings with ChangeNotifier {
  final String title = "LowPass Filter";
  final Field cutoffFreq = Field(0.0, 1.0, 0.0, "Cutoff Freq");
  final Field cutoffSweep = Field(-1.0, 1.0, 0.0, "Cutoff Sweep");
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

  void reset() {
    cutoffFreq.reset();
    cutoffSweep.reset();
    resonance.reset();
  }

  void defaults() {
    cutoffFreq.value = 1.0;
    cutoffSweep.value = 0.0;
    resonance.value = 0.035;
  }
}

// High-pass filter
class HighPassFilterSettings with ChangeNotifier {
  final String title = "HighPass Filter";
  final Field cutoffFreq = Field(0.0, 1.0, 0.0, "Cutoff Freq");
  final Field cutoffSweep = Field(-1.0, 1.0, 0.0, "Cutoff Sweep");

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

  void reset() {
    cutoffFreq.reset();
    cutoffSweep.reset();
  }

  void defaults() {
    cutoffFreq.value = 0.0;
    cutoffSweep.value = 0.0;
  }
}

class SampleRateSettings with ChangeNotifier {
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

  void reset() {
    rate.reset();
  }

  void defaults() {
    rate.value = SampleRate.kHz44;
  }
}

class SampleSizeSettings with ChangeNotifier {
  final Field size = Field.noRange(SampleSize.bits8, "Sample Size");

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

  void reset() {
    size.reset();
  }

  void defaults() {
    size.value = SampleSize.bits8;
  }
}

class GeneratorSettings with ChangeNotifier {
  final Field type = Field.noRange(Generator.none, "Generators");

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

  void update() {
    type.update();
    notifyListeners();
  }

  void reset() {
    type.reset();
  }
}

class WaveformSettings with ChangeNotifier {
  final Field type = Field.noRange(WaveForm.none, "Waveforms");

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

  void reset() {
    type.reset();
  }

  void defaults() {
    type.value = WaveForm.square;
  }
}

class AppSettings {
  final Field name = Field.noRange("", "Name");
  final Field sfxrFile = Field.noRange("", "Sfxr File");
  final Field waveFile = Field.noRange("", "Wave File");
  final Field destEmail = Field.noRange("", "Destination Email");
  final Field autoplay = Field.noRange(true, "Auto Play");
  final sampleRateSettings = SampleRateSettings();
  final sampleSizeSettings = SampleSizeSettings();
  final Field volume = Field.noRange(0.25, "Volume");
  final generatorSettings = GeneratorSettings();
  final waveformSettings = WaveformSettings();

  void update() {
    name.update();
    generatorSettings.update();
  }

  void reset() {
    name.reset();
    sfxrFile.reset();
    waveFile.reset();
    destEmail.reset();
    autoplay.reset();
    sampleRateSettings.reset();
    sampleSizeSettings.reset();
    volume.reset();
    generatorSettings.reset();
    waveformSettings.reset();
  }

  void defaults() {
    sampleRateSettings.defaults();
    sampleSizeSettings.defaults();
    waveformSettings.defaults();
  }
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

  List<double> noiseBuffer = [];

  String? downloadName;

  // Note: these update methods are really not needed.
  // TODO remove
  void update() {
    appSettings.update();
  }

  void reset() {
    appSettings.reset();
    envelopeSettings.reset();
    frequencySettings.reset();
    vibratoSettings.reset();
    arpeggiationSettings.reset();
    dutyCycleSettings.reset();
    retriggerSettings.reset();
    flangerSettings.reset();
    lowPassFilterSettings.reset();
    highPassFilterSettings.reset();
  }

  // A basic preset
  void defaults() {
    appSettings.defaults();
    envelopeSettings.defaults();
    frequencySettings.defaults();
    vibratoSettings.defaults();
    arpeggiationSettings.defaults();
    dutyCycleSettings.defaults();
    retriggerSettings.defaults();
    flangerSettings.defaults();
    lowPassFilterSettings.defaults();
    highPassFilterSettings.defaults();
  }

  String toJson() {
    String json = """
{
  "Format": "InternalView",
  "Category": "${_generatorToString(appSettings.generatorSettings.type.value)}",
  "Name": "${appSettings.name.value}",
  "BaseFrequency": ${frequencySettings.frequency.value},
  "FrequencyLimit": ${frequencySettings.minCutoff.value},
  "FrequencyRamp": ${frequencySettings.slide.value},
  "FrequencyDeltaRamp": ${frequencySettings.deltaSlide.value},
  "VibratoStrength": ${vibratoSettings.depth.value},
  "VibratoSpeed": ${vibratoSettings.speed.value},
  "ArpeggioMod": ${arpeggiationSettings.multiplier.value},
  "ArpeggioSpeed": ${arpeggiationSettings.speed.value},
  "DutyCycle": ${dutyCycleSettings.dutyCycle.value},
  "DutyCycleRamp": ${dutyCycleSettings.sweep.value},
  "RepeatSpeed": ${retriggerSettings.rate.value},
  "FlangerPhaseOffset": ${flangerSettings.offset.value},
  "FlangerPhaseRamp": ${flangerSettings.sweep.value},
  "LowPassFilterFrequency": ${lowPassFilterSettings.cutoffFreq.value},
  "LowPassFilterFrequencyRamp": ${lowPassFilterSettings.cutoffSweep.value},
  "LowPassFilterFrequencyResonance": ${lowPassFilterSettings.resonance.value},
  "HighPassFilterFrequency": ${highPassFilterSettings.cutoffFreq.value},
  "HighPassFilterFrequencyRamp": ${highPassFilterSettings.cutoffSweep.value},
  "EnvelopeAttack": ${envelopeSettings.attack.value},
  "EnvelopeSustain": ${envelopeSettings.sustain.value},
  "EnvelopePunch": ${envelopeSettings.punch.value},
  "EnvelopeDecay": ${envelopeSettings.decay.value},
  "WaveShape": "${_waveToString(appSettings.waveformSettings.type.value)}",
  "SampleRate": "${_rateToString(appSettings.sampleRateSettings.rate.value)}",
  "SampleSize": "${_sizeToString(appSettings.sampleSizeSettings.size.value)}",
  "SoundVolume": ${appSettings.volume.value},
  "NoiseType": "white",
  "NoiseData": []
}
""";

    return json;
  }

  void fromJson(String json) {
    Map<String, dynamic> jSettings = jsonDecode(json);

    appSettings.name.value = jSettings["Name"];
    appSettings.generatorSettings.type.value =
        _categoryToGenerator(jSettings["Category"]);
    appSettings.waveformSettings.type.value =
        _waveToGenerator(jSettings["WaveShape"]);

    appSettings.sampleRateSettings.rate.value =
        _rateToSampleRate(jSettings["SampleRate"]);

    appSettings.sampleSizeSettings.size.value =
        _sizeToSampleSize(jSettings["SampleSize"]);
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
    retriggerSettings.rate.value = checkRepeatValue(jSettings["RepeatSpeed"]);

    // Flanger
    flangerSettings.offset.value = jSettings["FlangerPhaseOffset"];
    flangerSettings.sweep.value = jSettings["FlangerPhaseRamp"];

    // LowPass
    lowPassFilterSettings.cutoffFreq.value =
        jSettings["LowPassFilterFrequency"];
    lowPassFilterSettings.cutoffSweep.value =
        jSettings["LowPassFilterFrequencyRamp"];
    lowPassFilterSettings.resonance.value = checkLowPassResonanceValue(
        jSettings["LowPassFilterFrequencyResonance"]);

    // HighPass
    highPassFilterSettings.cutoffFreq.value =
        jSettings["HighPassFilterFrequency"];
    highPassFilterSettings.cutoffSweep.value =
        jSettings["HighPassFilterFrequencyRamp"];

    // Envelope
    envelopeSettings.attack.value =
        checkEnvelopeValue(jSettings["EnvelopeAttack"]);
    envelopeSettings.sustain.value =
        checkEnvelopeValue(jSettings["EnvelopeSustain"]);
    envelopeSettings.punch.value =
        checkEnvelopeValue(jSettings["EnvelopePunch"]);
    envelopeSettings.decay.value =
        checkEnvelopeValue(jSettings["EnvelopeDecay"]);
  }

  // The "check" methods try to ensure that the json
  // data is within the respective ranges.
  // Early version of my SFxr adaptations would generate
  // values outside those ranges.
  double checkLowPassResonanceValue(double v) {
    return v < 0 ? (v + 0.5).abs() : v;
  }

  double checkEnvelopeValue(double v) {
    return v < 0 ? (v + 0.5).abs() : v;
  }

  // Retrigger
  double checkRepeatValue(double v) {
    return v < 0 ? min(v + 1.0, 0.95).abs() : min(v, 0.95).abs();
  }

  Generator _categoryToGenerator(String cat) {
    switch (cat) {
      case "pickUp":
        return Generator.pickUp;
      case "laser":
        return Generator.laser;
      case "explosion":
        return Generator.explosion;
      case "powerUp":
        return Generator.powerUp;
      case "hit":
        return Generator.hit;
      case "blip":
        return Generator.blip;
      case "synth":
        return Generator.synth;
      case "random":
        return Generator.random;
      case "tone":
        return Generator.tone;
      case "mutate":
        return Generator.mutate;
      default:
        return Generator.none;
    }
  }

  String _generatorToString(Generator gen) {
    switch (gen) {
      case Generator.pickUp:
        return "pickUp";
      case Generator.laser:
        return "laser";
      case Generator.explosion:
        return "explosion";
      case Generator.powerUp:
        return "powerUp";
      case Generator.hit:
        return "hit";
      case Generator.blip:
        return "blip";
      case Generator.synth:
        return "synth";
      case Generator.random:
        return "random";
      case Generator.tone:
        return "tone";
      case Generator.mutate:
        return "mutate";
      default:
        return "none";
    }
  }

  WaveForm _waveToGenerator(String wave) {
    switch (wave) {
      case "square":
        return WaveForm.square;
      case "triangle":
        return WaveForm.triangle;
      case "sine":
        return WaveForm.sine;
      case "sawtoothFalling":
        return WaveForm.sawtoothFalling;
      case "whiteNoise":
        return WaveForm.whiteNoise;
      case "pinkNoise":
        return WaveForm.pinkNoise;
      case "redNoise":
        return WaveForm.redNoise; // Brownian/red
      case "sawtoothRising":
        return WaveForm.sawtoothRising;
      default:
        return WaveForm.none;
    }
  }

  String _waveToString(WaveForm wave) {
    switch (wave) {
      case WaveForm.square:
        return "square";
      case WaveForm.triangle:
        return "triangle";
      case WaveForm.sine:
        return "sine";
      case WaveForm.sawtoothFalling:
        return "sawtoothFalling";
      case WaveForm.whiteNoise:
        return "whiteNoise";
      case WaveForm.pinkNoise:
        return "pinkNoise";
      case WaveForm.redNoise:
        return "redNoise"; // Brownian/red
      case WaveForm.sawtoothRising:
        return "sawtoothRising";
      default:
        return "none";
    }
  }

  String _rateToString(SampleRate rate) {
    switch (rate) {
      case SampleRate.kHz44:
        return "kHz44";
      case SampleRate.kHz22:
        return "kHz22";
      case SampleRate.kHz11:
        return "kHz11";
      case SampleRate.kHz55:
        return "kHz55"; // 5.5KHz
      default:
        return "none";
    }
  }

  SampleRate _rateToSampleRate(String rate) {
    switch (rate) {
      case "kHz44":
        return SampleRate.kHz44;
      case "kHz22":
        return SampleRate.kHz22;
      case "kHz11":
        return SampleRate.kHz11;
      case "kHz55":
        return SampleRate.kHz55; // 5.5KHz
      default:
        return SampleRate.none;
    }
  }

  static int sampleRateToInt(AppSettings settings) {
    switch (settings.sampleRateSettings.rate.value) {
      case SampleRate.kHz44:
        return 44100;
      case SampleRate.kHz22:
        return 22000;
      case SampleRate.kHz11:
        return 11000;
      case SampleRate.kHz55:
        return 5500; // 5.5KHz
      default:
        return 0;
    }
  }

  String _sizeToString(SampleSize size) {
    switch (size) {
      case SampleSize.bits16:
        return "bits16";
      case SampleSize.bits8:
        return "bits8";
      default:
        return "none";
    }
  }

  static int sampleSizeToInt(AppSettings settings) {
    switch (settings.sampleSizeSettings.size.value) {
      case SampleSize.bits16:
        return 16;
      case SampleSize.bits8:
        return 8;
      default:
        return 0;
    }
  }

  SampleSize _sizeToSampleSize(String size) {
    switch (size) {
      case "bits16":
        return SampleSize.bits16;
      case "bits8":
        return SampleSize.bits8;
      default:
        return SampleSize.none;
    }
  }
}
