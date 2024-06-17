Godot Voice:
Welcome to Godot Voice, a simple animated & voiced dialog text library for Godot.

Usage:
To say a line, call `VoiceLine` with the string you want to animate and voice, if you want to add a specified amount of time that it will wait prior to starting to display, you can include the `extraDelay` optional parameter.

Configuration:
Godot Voice heavily uses the Godot Editor to configure the voice quality. The most important piece is `Beep Interval`, `Clear Time` and `Break Intervals`. These are how you configure the time between each individual character and I will go into further detail later. You will want to set a `Voice Stream` and `Voice Label` as these are the audio that gets played as well as the location that gets printed into.

Most characters in the string you pass in will use the `Beep Interval` as the amount of time between each sound played
Additionally, `Clear Time` is the amount of time that it will take after the text has printed to the Label before it gets cleared out
Finally, there is the `Beep Interval`

Beep Intervals:
Beep Intervals are a custom resource that provide 4 options.
1. Interval: The amount of time before/after displaying the characters defined in #2
2. Characters: A String that's really an array of characters, each individual character in this string will use the interval defined in #1
3. Should Beep: A bool that defines whether this character should cause a sound to play when rendered
4. Break After: A bool that defines whether the character is printed before or after the Interval defined in #1. If this is true, the character will print immediately and the defined pause will happen after it is displayed

Additionally if you just want to configure a new voice without hooking any functionality up, look in `Debug Settings`, if `Test Voice Line` and `Test Voice Line Delay` are set to anything other than the defaults, the text will automatically print after the specified delay.
