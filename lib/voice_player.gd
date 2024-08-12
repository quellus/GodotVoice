class_name VoicePlayer extends Node

@export_group("External Objects")
@export var _audioStreamPlayer: AudioStreamPlayer
@export var _voiceStream: AudioStream
@export var _voiceLabel: Label
@export_group("Pause Intervals")
@export var _beepInterval: float = 0.075

@export var _clearTime: float = 2.00

@export var _breakIntervals: Array[BreakInterval]
	

# Test Code
@export_group("Debug Settings")
@export var _testVoiceLine: String = ""
@export var _testVoiceLineDelay: float

# Internal State Variables, Queued up Plays
var _clock: float
var _nextBeep: float = -1
var _mute: bool
var _muteText: bool

var _beepTimes: Array[BeepTime] = []

signal OnVoiceCompleteEventHandler()
signal OnVoiceClearEventHandler()

func _ready() -> void:
	for breakInterval in _breakIntervals:
		breakInterval.Initialize();
	
	_audioStreamPlayer.Stream = _voiceStream;

	if _testVoiceLine.length() > 0:
		VoiceLine(_testVoiceLine, _testVoiceLineDelay);

func _process(delta) -> void:
	_clock += delta;
	if !ShouldBeep() || _mute:
		return;
	_audioStreamPlayer.Stop();
	_audioStreamPlayer.Play();


func ShouldBeep() -> bool:
	if _beepTimes.size() <= 0:
		return false;
	var nextBeep = _beepTimes[0]
	if !nextBeep.Time <= _clock:
		return false;
	_beepTimes.pop_front();
	var beep = true;

	match nextBeep.Type:
		BeepTime.BeepType.Character:
			if !_muteText:
				_voiceLabel.Text += nextBeep.Character;
			for interval in _breakIntervals:
				if interval.CharSet.contains(nextBeep.Character) && !interval.ShouldBeep:
					beep = false;
		BeepTime.BeepType.Completed:
			HandleComplete();
			beep = false;
		BeepTime.BeepType.Cleared:
			HandleClear();
			beep = false;
		_:
			return false
	
	return beep;


func HandleComplete() -> void:
	OnVoiceCompleteEventHandler.emit()
	_mute = false
	_muteText = false


func HandleClear() -> void:
	OnVoiceClearEventHandler.emit()
	_voiceLabel.Text = "";

# ReSharper disable once MemberCanBePrivate.Global
func VoiceLine(lineToVoice: String, extraDelay: float = 0.0) -> float:
	if _nextBeep < _clock + extraDelay:
		_nextBeep = _clock + extraDelay

	for character in lineToVoice:
		var nextInterval = _beepInterval
		var breakAfter = false
		for interval in _breakIntervals:
			if interval.CharSet.contains(character):
				nextInterval = interval.Interval;
				breakAfter = interval.BreakAfter;

		if !breakAfter:
			_nextBeep += nextInterval;

		var new_beep_time = BeepTime.new()
		new_beep_time.Time = _nextBeep
		new_beep_time.Character = character
		new_beep_time.Type = BeepTime.BeepType.Character
		_beepTimes.append(new_beep_time)
		if breakAfter:
			_nextBeep += nextInterval;

	# Calculating how long this text takes to print
	var length = _nextBeep - _clock;

	var new_beep_time = BeepTime.new()
	new_beep_time.Time = _nextBeep
	new_beep_time.Character = ' '
	new_beep_time.Type = BeepTime.BeepType.Completed
	_beepTimes.append(new_beep_time)
	_nextBeep += _clearTime;
	
	new_beep_time = BeepTime.new()
	new_beep_time.Time = _nextBeep
	new_beep_time.Character = ' '
	new_beep_time.Type = BeepTime.BeepType.Cleared
	_beepTimes.append(new_beep_time)

	return length;

# ReSharper disable once MemberCanBePrivate.Global
func InterruptVoice() -> void:
	_mute = true

# ReSharper disable once MemberCanBePrivate.Global
func InterruptText() -> void:
	_muteText = true

# ReSharper disable once MemberCanBePrivate.Global
func ClearQueue() -> void:
	_beepTimes = []
	HandleComplete()
	_nextBeep = -1
