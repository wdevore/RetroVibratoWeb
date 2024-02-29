import 'dart:math';

import 'package:retro_vibrato_web/generator_algorithm.dart';
import 'package:retro_vibrato_web/model/enums.dart';
import 'package:retro_vibrato_web/model/field.dart';
import 'package:retro_vibrato_web/model/settings_model.dart';

// Technically the values generated are meaningless to a user
// Other version of this generator supported an external
// representation for the user which again was mostly meaningless
// so this version only deals with internal values.

// This is base configurations for the Generator algorithm which is
// driven by the Settings values.
class Configurations {
  final SettingsModel settings;
  final GeneratorAlgorithm ga = GeneratorAlgorithm();

  static const playbackSoundVolume = 0.1;

  Configurations(this.settings);

  void generate() {
    ga.generate(settings);
  }

  void config() {
    // ga.initForRepeat(settings);
    ga.init(settings);
  }

  double clamp(Field f, double rand) {
    double v = f.value + rand;
    return v.clamp(f.min, f.max);
  }

  void mutate() {
    var freqSettings = settings.frequencySettings;
    if (Random().nextDouble() > 0.5) {
      freqSettings.frequency.add(Random().nextDouble() * 0.1 - 0.05);
    }
    if (Random().nextDouble() > 0.5) {
      freqSettings.slide.add(Random().nextDouble() * 0.1 - 0.05);
    }
    if (Random().nextDouble() > 0.5) {
      freqSettings.deltaSlide.add(Random().nextDouble() * 0.1 - 0.05);
    }

    var dutySettings = settings.dutyCycleSettings;
    if (Random().nextDouble() > 0.5) {
      dutySettings.dutyCycle.add(Random().nextDouble() * 0.1 - 0.05);
    }
    if (Random().nextDouble() > 0.5) {
      dutySettings.sweep.add(Random().nextDouble() * 0.1 - 0.05);
    }

    var vibSettings = settings.vibratoSettings;
    if (Random().nextDouble() > 0.5) {
      vibSettings.depth.add(Random().nextDouble() * 0.1 - 0.05);
    }
    if (Random().nextDouble() > 0.5) {
      vibSettings.speed.add(Random().nextDouble() * 0.1 - 0.05);
    }

    var envSettings = settings.envelopeSettings;
    if (Random().nextDouble() > 0.5) {
      envSettings.attack.add(Random().nextDouble() * 0.1 - 0.05);
    }
    if (Random().nextDouble() > 0.5) {
      envSettings.sustain.add(Random().nextDouble() * 0.1 - 0.05);
    }
    if (Random().nextDouble() > 0.5) {
      envSettings.decay.add(Random().nextDouble() * 0.1 - 0.05);
    }
    if (Random().nextDouble() > 0.5) {
      envSettings.punch.add(Random().nextDouble() * 0.1 - 0.05);
    }

    var lpfSettings = settings.lowPassFilterSettings;
    if (Random().nextDouble() > 0.5) {
      lpfSettings.cutoffFreq.add(Random().nextDouble() * 0.1 - 0.05);
    }
    if (Random().nextDouble() > 0.5) {
      lpfSettings.cutoffSweep.add(Random().nextDouble() * 0.1 - 0.05);
    }
    if (Random().nextDouble() > 0.5) {
      lpfSettings.resonance.add(Random().nextDouble() * 0.1 - 0.05);
    }

    var hpfSettings = settings.highPassFilterSettings;
    if (Random().nextDouble() > 0.5) {
      hpfSettings.cutoffFreq.add(Random().nextDouble() * 0.1 - 0.05);
    }
    if (Random().nextDouble() > 0.5) {
      hpfSettings.cutoffSweep.add(Random().nextDouble() * 0.1 - 0.05);
    }

    var flaSettings = settings.flangerSettings;
    if (Random().nextDouble() > 0.5) {
      flaSettings.offset.add(Random().nextDouble() * 0.1 - 0.05);
    }
    if (Random().nextDouble() > 0.5) {
      flaSettings.sweep.add(Random().nextDouble() * 0.1 - 0.05);
    }

    var repSettings = settings.retriggerSettings;
    if (Random().nextDouble() > 0.5) {
      repSettings.rate.add(Random().nextDouble() * 0.1 - 0.05);
    }

    var arpSettings = settings.arpeggiationSettings;
    if (Random().nextDouble() > 0.5) {
      arpSettings.speed.add(Random().nextDouble() * 0.1 - 0.05);
    }
    if (Random().nextDouble() > 0.5) {
      arpSettings.multiplier.add(Random().nextDouble() * 0.1 - 0.05);
    }
  }

  void pickUpOrCoin(bool withArp) {
    settings.defaults();

    if (Random().nextDouble() > 0.5) {
      settings.appSettings.waveformSettings.type.value =
          WaveForm.sawtoothRising;
    } else {
      settings.appSettings.waveformSettings.type.value =
          WaveForm.sawtoothFalling;
    }

    // Base freq
    settings.frequencySettings.frequency.value =
        0.4 + Random().nextDouble() * 0.5;

    // Envelope
    var envSettings = settings.envelopeSettings;

    envSettings.attack.value = 0.0;
    envSettings.sustain.value = Random().nextDouble() * 0.1;
    envSettings.decay.value = 0.1 + Random().nextDouble() * 0.4;
    envSettings.punch.value = 0.3 + Random().nextDouble() * 0.3;

    // Arpeggiation
    var arpSettings = settings.arpeggiationSettings;
    if (withArp || Random().nextDouble() > 0.5) {
      arpSettings.speed.value = 0.5 + Random().nextDouble() * 0.2;
      arpSettings.multiplier.value = 0.2 + Random().nextDouble() * 0.4;
    }
  }

  void laserShoot() {
    settings.defaults();

    var appSettings = settings.appSettings;
    // Damping volume in case this generates a loud sound
    appSettings.volume.value = playbackSoundVolume;

    WaveForm shape = _generateRandomWaveNoNoise();
    appSettings.waveformSettings.type.value = shape;

    // Frequency
    var freqSettings = settings.frequencySettings;
    if (madRand(4.0) == 0) {
      // Square
      freqSettings.frequency.value = 0.3 + Random().nextDouble() * 0.6;
      freqSettings.minCutoff.value = Random().nextDouble() * 0.1;
      freqSettings.slide.value = -0.35 - Random().nextDouble() * 0.3;
    } else {
      freqSettings.frequency.value = 0.5 + Random().nextDouble() * 0.5;
      freqSettings.minCutoff.value =
          freqSettings.frequency.value - 0.2 - Random().nextDouble() * 0.6;
      if (freqSettings.minCutoff.value < 0.2) {
        freqSettings.minCutoff.value = 0.2;
      }
      freqSettings.slide.value = -0.15 - Random().nextDouble() * 0.2;
    }

    // Duty
    var dutySettings = settings.dutyCycleSettings;
    if (shape == WaveForm.triangle) {
      dutySettings.dutyCycle.value = 1.0;
    }

    if (Random().nextDouble() > 0.5) {
      dutySettings.dutyCycle.value = Random().nextDouble() * 0.5;
      dutySettings.sweep.value = Random().nextDouble() * 0.2;
    } else {
      dutySettings.dutyCycle.value = 0.4 + Random().nextDouble() * 0.5;
      dutySettings.sweep.value = -Random().nextDouble() * 0.7;
    }

    // Envelope
    var envSettings = settings.envelopeSettings;
    envSettings.attack.value = 0.0;
    envSettings.sustain.value = 0.1 + Random().nextDouble() * 0.2;
    envSettings.decay.value = Random().nextDouble() * 0.4;
    if (Random().nextDouble() > 0.5) {
      envSettings.punch.value = Random().nextDouble() * 0.3;
    }

    // Flanger Phase
    var flanSettings = settings.flangerSettings;
    if (madRand(4.0) == 0) {
      flanSettings.offset.value = Random().nextDouble() * 0.2;
      flanSettings.sweep.value = -Random().nextDouble() * 0.2;
    }

    // High pass
    settings.highPassFilterSettings.cutoffFreq.value =
        Random().nextDouble() * 0.3;
  }

  void explosion() {
    settings.defaults();

    var appSettings = settings.appSettings;
    // Damping volume in case this generates a loud sound
    appSettings.volume.value = playbackSoundVolume;

    WaveForm shape = WaveForm.whiteNoise;
    appSettings.waveformSettings.type.value = shape;

    // Frequency
    var freqSettings = settings.frequencySettings;

    if (Random().nextDouble() > 0.5) {
      freqSettings.frequency.value = sqr(0.1 + Random().nextDouble() * 0.4);
      freqSettings.slide.value = -0.1 + Random().nextDouble() * 0.4;
    } else {
      freqSettings.frequency.value = sqr(0.2 + Random().nextDouble() * 0.7);
      freqSettings.slide.value = -0.2 - Random().nextDouble() * 0.2;
    }

    if (madRand(5.0) == 0) {
      freqSettings.slide.value = 0.0;
    }

    // Retrigger
    if (madRand(3.0) == 0) {
      settings.retriggerSettings.rate.value = 0.3 + Random().nextDouble() * 0.5;
    }

    // Envelope
    var envSettings = settings.envelopeSettings;
    envSettings.attack.value = 0.0;
    envSettings.sustain.value = 0.1 + Random().nextDouble() * 0.3;
    envSettings.decay.value = Random().nextDouble() * 0.5;
    envSettings.punch.value = 0.2 + Random().nextDouble() * 0.6;

    // Flanger Phase
    var flanSettings = settings.flangerSettings;
    if (Random().nextDouble() > 0.5) {
      flanSettings.offset.value = -0.3 + Random().nextDouble() * 0.9;
      flanSettings.sweep.value = -Random().nextDouble() * 0.3;
    }

    // Vibrato
    var vibSettings = settings.vibratoSettings;
    if (Random().nextDouble() > 0.5) {
      vibSettings.depth.value = Random().nextDouble() * 0.7;
      vibSettings.speed.value = Random().nextDouble() * 0.6;
    }

    // Arpeggiation
    var arpSettings = settings.arpeggiationSettings;
    if (madRand(4.0) == 0) {
      arpSettings.speed.value = 0.6 + Random().nextDouble() * 0.3;
      arpSettings.multiplier.value = 0.8 - Random().nextDouble() * 1.6;
    }
  }

  void powerUp() {
    settings.defaults();

    var appSettings = settings.appSettings;
    // Damping volume in case this generates a loud sound
    appSettings.volume.value = playbackSoundVolume;

    double chance = Random().nextDouble();

    WaveForm shape = appSettings.waveformSettings.type.value;
    if (chance > 0.5) {
      shape = WaveForm.triangle;
    }
    appSettings.waveformSettings.type.value = shape;

    // Duty
    if (chance > 0.5) {
      settings.dutyCycleSettings.dutyCycle.value = 1.0;
    } else {
      settings.dutyCycleSettings.dutyCycle.value = Random().nextDouble() * 0.6;
    }

    // Frequency
    var freqSettings = settings.frequencySettings;
    freqSettings.frequency.value = 0.2 + Random().nextDouble() * 0.3;

    var repSettings = settings.retriggerSettings;
    var vibSettings = settings.vibratoSettings;
    if (Random().nextDouble() > 0.5) {
      freqSettings.slide.value = 0.1 + Random().nextDouble() * 0.4;
      repSettings.rate.value = 0.4 + Random().nextDouble() * 0.4;
    } else {
      freqSettings.slide.value = 0.05 + Random().nextDouble() * 0.2;
      if (Random().nextDouble() > 0.5) {
        vibSettings.depth.value = Random().nextDouble() * 0.7;
        vibSettings.speed.value = Random().nextDouble() * 0.6;
      }
    }

    // Envelope
    var envSettings = settings.envelopeSettings;
    envSettings.attack.value = 0.0;
    envSettings.sustain.value = Random().nextDouble() * 0.4;
    envSettings.decay.value = 0.1 + Random().nextDouble() * 0.4;
  }

  void hitHurt() {
    settings.defaults();

    var appSettings = settings.appSettings;
    // Damping volume in case this generates a loud sound
    appSettings.volume.value = playbackSoundVolume;

    WaveForm shape = _generateRandomWaveNoNoise();
    appSettings.waveformSettings.type.value = shape;

    switch (shape) {
      case WaveForm.sine:
        shape = WaveForm.whiteNoise;
        appSettings.waveformSettings.type.value = shape;
      case WaveForm.square:
        settings.dutyCycleSettings.dutyCycle.value =
            Random().nextDouble() * 0.6;
      case WaveForm.triangle:
      case WaveForm.sawtoothRising:
      case WaveForm.sawtoothFalling:
        settings.dutyCycleSettings.dutyCycle.value = 1.0;
      default:
    }

    // Frequency
    var freqSettings = settings.frequencySettings;
    freqSettings.frequency.value = 0.2 + Random().nextDouble() * 0.6;
    freqSettings.slide.value = -0.3 - Random().nextDouble() * 0.4;

    // Envelope
    var envSettings = settings.envelopeSettings;
    envSettings.attack.value = 0.0;
    envSettings.sustain.value = Random().nextDouble() * 0.1;
    envSettings.decay.value = 0.1 + Random().nextDouble() * 0.2;

    // High pass
    if (Random().nextDouble() > 0.5) {
      settings.highPassFilterSettings.cutoffFreq.value =
          Random().nextDouble() * 0.3;
    }
  }

  void jump() {
    settings.defaults();

    var appSettings = settings.appSettings;
    // Damping volume in case this generates a loud sound
    appSettings.volume.value = playbackSoundVolume;

    appSettings.waveformSettings.type.value = WaveForm.square;

    // Duty
    settings.dutyCycleSettings.dutyCycle.value = Random().nextDouble() * 0.6;

    var freqSettings = settings.frequencySettings;
    freqSettings.frequency.value = 0.3 + Random().nextDouble() * 0.3;
    freqSettings.slide.value = 0.1 + Random().nextDouble() * 0.2;

    // Envelope
    var envSettings = settings.envelopeSettings;
    envSettings.attack.value = 0.0;
    envSettings.sustain.value = 0.1 + Random().nextDouble() * 0.3;
    envSettings.decay.value = 0.1 + Random().nextDouble() * 0.2;

    // High pass
    var hpfSettings = settings.highPassFilterSettings;
    if (Random().nextDouble() > 0.5) {
      hpfSettings.cutoffFreq.value = Random().nextDouble() * 0.3;
    }

    // Low pass
    var lpfSettings = settings.lowPassFilterSettings;
    if (Random().nextDouble() > 0.5) {
      lpfSettings.cutoffFreq.value = 1.0 - Random().nextDouble() * 0.6;
    }
  }

  void blipSelect() {
    settings.defaults();

    var appSettings = settings.appSettings;
    // Damping volume in case this generates a loud sound
    appSettings.volume.value = playbackSoundVolume;

    WaveForm shape = _generateRandomWaveNoNoiseNoSaw();
    appSettings.waveformSettings.type.value = shape;

    // Duty
    if (shape == WaveForm.square) {
      settings.dutyCycleSettings.dutyCycle.value = Random().nextDouble() * 0.6;
    } else {
      settings.dutyCycleSettings.dutyCycle.value = 1.0;
    }

    // Base frequency
    var freqSettings = settings.frequencySettings;
    freqSettings.frequency.value = 0.2 + Random().nextDouble() * 0.4;

    // Envelope
    var envSettings = settings.envelopeSettings;
    envSettings.attack.value = 0.0;
    envSettings.sustain.value = 0.1 + Random().nextDouble() * 0.1;
    envSettings.decay.value = Random().nextDouble() * 0.2;

    // High pass
    var hpfSettings = settings.highPassFilterSettings;
    hpfSettings.cutoffFreq.value = 0.1;
  }

  void synth() {
    settings.defaults();

    var appSettings = settings.appSettings;
    // Damping volume in case this generates a loud sound
    appSettings.volume.value = playbackSoundVolume;

    WaveForm shape = _generateRandomWaveNoNoiseNoSaw();
    appSettings.waveformSettings.type.value = shape;

    // Base frequency
    var freqSettings = settings.frequencySettings;
    if (Random().nextDouble() > 0.5) {
      freqSettings.frequency.value = 0.2477;
    } else {
      freqSettings.frequency.value = 0.1737;
    }

    // Envelope
    var envSettings = settings.envelopeSettings;
    if (madRand(5.0) > 3.0) {
      envSettings.attack.value = Random().nextDouble() * 0.5;
    } else {
      envSettings.attack.value = 0.0;
    }
    envSettings.sustain.value = Random().nextDouble();
    envSettings.punch.value = Random().nextDouble();
    envSettings.decay.value = Random().nextDouble() * 0.9 + 0.1;

    // Arpeggiation
    var arpSettings = settings.arpeggiationSettings;
    List<double> aMod = [0, 0, 0, 0, -0.3162, 0.7454, 0.7454];
    arpSettings.multiplier.value = aMod[madRand(7)];
    arpSettings.speed.value = Random().nextDouble() * 0.5 + 0.4;

    // Duty
    settings.dutyCycleSettings.dutyCycle.value = Random().nextDouble();
    if (madRand(3) == 2.0) {
      settings.dutyCycleSettings.sweep.value = Random().nextDouble();
    } else {
      settings.dutyCycleSettings.sweep.value = 0.0;
    }

    // Low pass
    var lpfSettings = settings.lowPassFilterSettings;
    if (madRand(2) == 0) {
      lpfSettings.cutoffFreq.value = 1.0;
    } else {
      lpfSettings.cutoffFreq.value =
          Random().nextDouble() * Random().nextDouble();
    }
    lpfSettings.cutoffSweep.value = rndr(-1.0, 1.0);
    lpfSettings.resonance.value = Random().nextDouble();

    // High pass
    var hpfSettings = settings.highPassFilterSettings;

    if (madRand(4) == 3.0) {
      hpfSettings.cutoffFreq.value = Random().nextDouble();
    } else {
      hpfSettings.cutoffFreq.value = 0.0;
    }

    if (madRand(4) == 4) {
      hpfSettings.cutoffSweep.value = Random().nextDouble();
    } else {
      hpfSettings.cutoffSweep.value = 0.0;
    }
  }

  void random() {
    settings.defaults();

    var appSettings = settings.appSettings;
    // Damping volume in case this generates a loud sound
    appSettings.volume.value = playbackSoundVolume;

    // Base frequency
    var freqSettings = settings.frequencySettings;
    var baseFreg = freqSettings.frequency;
    var freqRamp = freqSettings.slide;
    if (Random().nextDouble() > 0.5) {
      baseFreg.value = cube(Random().nextDouble() * 2.0 - 1) + 0.5;
    } else {
      baseFreg.value = sqr(Random().nextDouble());
    }

    freqSettings.minCutoff.value = 0.0;
    freqRamp.value = pow(Random().nextDouble() * 2.0 - 1.0, 5);

    if (baseFreg.value > 0.7 && freqRamp.value > 0.2) {
      freqRamp.value = -freqRamp.value;
    }
    if (baseFreg.value < 0.2 && freqRamp.value < -0.05) {
      freqRamp.value = -freqRamp.value;
    }
    freqSettings.deltaSlide.value = pow(Random().nextDouble() * 2.0 - 1.0, 3);

    // Duty
    settings.dutyCycleSettings.dutyCycle.value =
        Random().nextDouble() * 2.0 - 1.0;
    settings.dutyCycleSettings.sweep.value =
        pow(Random().nextDouble() * 2.0 - 1.0, 3);

    // Vibrato
    var vibSettings = settings.vibratoSettings;
    vibSettings.depth.value = pow(Random().nextDouble() * 2.0 - 1.0, 3);
    vibSettings.speed.value = rndr(-1.0, 1.0);

    // Envelope
    var envSettings = settings.envelopeSettings;
    envSettings.attack.value = cube(rndr(-1.0, 1.0));
    envSettings.sustain.value = sqr(rndr(-1.0, 1.0));
    envSettings.decay.value = rndr(-1.0, 1.0);
    envSettings.punch.value = pow(Random().nextDouble() * 0.8, 2);

    var underValue = envSettings.attack.value +
        envSettings.sustain.value +
        envSettings.decay.value;
    if (underValue < 0.2) {
      envSettings.sustain.value += 0.2 + Random().nextDouble() * 0.3;
      envSettings.decay.value += 0.2 + Random().nextDouble() * 0.3;
    }

    // Low pass
    var lpfSettings = settings.lowPassFilterSettings;
    lpfSettings.resonance.value = rndr(-1.0, 1.0);
    lpfSettings.cutoffFreq.value = 1 - pow(Random().nextDouble(), 3);
    lpfSettings.cutoffSweep.value = pow(Random().nextDouble() * 2.0 - 1, 3);
    if (lpfSettings.cutoffFreq.value < 0.1 &&
        lpfSettings.cutoffSweep.value < -0.05) {
      lpfSettings.cutoffSweep.value = -lpfSettings.cutoffSweep.value;
    }

    // High pass
    var hpfSettings = settings.highPassFilterSettings;
    hpfSettings.cutoffFreq.value = pow(Random().nextDouble(), 5);
    hpfSettings.cutoffSweep.value = pow(Random().nextDouble() * 2.0 - 1, 5);

    // Flanger Phase
    var flanSettings = settings.flangerSettings;
    flanSettings.offset.value = pow(Random().nextDouble() * 2.0 - 1, 3);
    flanSettings.sweep.value = pow(Random().nextDouble() * 2.0 - 1, 3);

    // Retrigger
    settings.retriggerSettings.rate.value = Random().nextDouble() * 2.0 - 1;

    // Arpeggiation
    var arpSettings = settings.arpeggiationSettings;
    arpSettings.speed.value = Random().nextDouble() * 2.0 - 1;
    arpSettings.multiplier.value = Random().nextDouble() * 2.0 - 1;
  }

  // tone is in Hertz, for example 440.0
  void tone(double tone, WaveForm shape) {
    settings.defaults();

    var appSettings = settings.appSettings;
    // Damping volume in case this generates a loud sound
    appSettings.volume.value = playbackSoundVolume;

    appSettings.sampleRateSettings.rate.value = SampleRate.kHz44;
    appSettings.sampleSizeSettings.size.value = SampleSize.bits8;

    appSettings.waveformSettings.type.value = shape;

    // sqrt((440Hz / (oversampling = 8) / 441) - 0.001)
    // baseFreq = 0.35173363968773563 =- 440 Hz
    settings.frequencySettings.frequency.value = toIBaseFreq(tone);

    // Envelope
    var envSettings = settings.envelopeSettings;
    envSettings.attack.value = 0.0;

    // seconds = p^2 * 100000 / 44100
    envSettings.sustain.value = sqrt(1.0 / 100000 * 44100);
    // sustain = 0.664078309 // 1 sec
    // sustain = 0.939148551 // 2 sec

    envSettings.decay.value = 0.0;
    envSettings.punch.value = 0.0;
  }

  // Convert from external representation to internal
  double toIBaseFreq(double externalTone) {
    return sqrt((externalTone / 8.0 / 441.0) - 0.001);
  }

  WaveForm _generateRandomWaveNoNoise() {
    WaveForm shape = WaveForm.none;

    shape = _generateRandomWaveNoNoiseNoSaw();

    // If sine was picked then there could be a chance for sawtooth
    if (shape == WaveForm.sine && Random().nextDouble() > 0.5) {
      switch (madRand(1.0)) {
        case 0:
          shape = WaveForm.sawtoothRising;
        case 1:
          shape = WaveForm.sawtoothFalling;
      }
    }

    return shape;
  }

  WaveForm _generateRandomWaveNoNoiseNoSaw() {
    WaveForm shape = WaveForm.none;

    switch (madRand(2.0)) {
      case 0:
        shape = WaveForm.square;
      case 1:
        shape = WaveForm.triangle;
      case 2:
        shape = WaveForm.sine;
    }

    return shape;
  }

  double cube(double v) => v * v * v;
  double sqr(double v) => v * v;

  double rndr(double from, double to) {
    return Random().nextDouble() * (to - from) + from;
  }

  int madRand(double max) {
    return (Random().nextDouble() * max).floor().toInt();
  }
}
