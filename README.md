# RetroVibratoWeb
A web version RetroVibrato that it in turn is based off of sfrxr.js

![RetroVibratoWeb_P1 gif](retrovibratoweb_p1.gif)

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

# Tasks
- ☑ Settings sliders
- ☑ State management figured out
- ☒ Load/saving json and updating GUI
- ☒ Saving wave file via download
- ☒ Porting generator algorithm from Ranger-Go-IGE
- ☒ Add Generator selector (top)
- ☒ Add Wave form selector (under top)
- ☒ Add volume slider (next)
- ☒ Add SampleSize 
- ☒ Implement play button
- ☒ Add Help popup
