class_name BreakInterval extends Resource

@export var interval: float
@export var _characters: String
@export var ShouldBeep: bool
@export var BreakAfter: bool
var CharSet: String = ""
 
#public BreakInterval()
#{
	#Interval = 0.0;
	#_characters = "";
	#ShouldBeep = false;
#}

#public BreakInterval(double interval, string characters, bool shouldBeep, bool breakAfter)
#{
	#Interval = interval;
	#_characters = characters;
	#ShouldBeep = shouldBeep;
	#BreakAfter = breakAfter;
#}

func Initialize():
	for character in _characters:
		CharSet += character
