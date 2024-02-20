# RetroVibratoWeb
A web version RetroVibrato that it in turn is based off of [jsfxr](https://sfxr.me/).

This app generates arcade sounds from the 70s and 80s. 

Rev 2

![RetroVibratoWeb_P2 gif](retrovibratoweb_p2.gif)

[RetroVi
# Notes
Some of the json files have what appear to be invalid values, for example, JettsonSaucer.json has negative envelope Attack and Decay but the range is from 0->1.

I believe this was from the Mutate() and Random generators. It has code that could potentially generate negative values, for example:
```go
Mutate is:
i.baseValues.attack += frnd(0.1) - 0.05

Random is:
o.baseValues.attack = cube(rndr(-1.0, 1.0))
```
One kind of fix would be to *abs(add 0.5)* to anything < 0.

The fix for Random would be to check what the range is and use that instead of hardcoded (-1,1)

# Menus
- Generators
- Wave Forms
- Volume slider
- Save
    - sfxr
    - wave
- Load
    - sfxr
- Sample Rate
    - 44 KHz
    - 22 KHz
    - 11 KHz
    - 5.5 KHz
- Autoplay checkbox
- Email
    - Email address
    - Type
        - sfxr
        - wave
- About

# Tasks
*Left off at ...*

- ☑ Settings sliders
- ☑ State management. Used Provider
- ☑ Load json and updating GUI
- ☑ Saving json and updating GUI
- ☑ Clicking a slider label resets it to Reset value
- ☑ Add Generator selector (top)
- ☑ Add Wave form selector (under top)
- ☑ Add volume slider (next)
- ☑ Add SampleSize 
- ☒ Porting generator algorithm from Ranger-Go-IGE
- ☒ Implement play button
- ☒ Saving wave file via download
- ☒ Add Help popup

# Audio

[Just Audio package](https://pub.dev/documentation/just_audio/latest/)

https://pub.dev/packages/audiofileplayer
audiofileplayer 2.0.1


## Just Audio package
https://stackoverflow.com/questions/67078045/flutter-just-audio-package-how-play-audio-from-bytes

Streaming audio in Flutter with Just Audio (unfortunately it is behind medium's paywal)
- [Part 1](https://suragch.medium.com/playing-short-audio-clips-in-flutter-with-just-audio-3c80eb7eb6ea)
- [Part 2](https://suragch.medium.com/steaming-audio-in-flutter-with-just-audio-7435fcf672bf)