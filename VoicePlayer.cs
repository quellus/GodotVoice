using System.Collections.Generic;
using System.ComponentModel;
using Godot;
using Godot.Collections;

namespace Voice;

public partial class VoicePlayer : Node
{
	private AudioStreamPlayer _audioStreamPlayer;
	[ExportGroup("Voice")]
	[Export] private AudioStream _voiceStream;
	[ExportGroup("Pause Intervals")]
	[Export] private double _beepInterval = 0.075;

	[Export] private Array<BreakInterval> _breakIntervals = [new BreakInterval(0.2, " ", false), new BreakInterval(0.4, ".,;!?", false)];

	[Signal] public delegate void OnVoiceBeepEventHandler();
	
	// Test Code
	[ExportGroup("Debug Settings")]
	[Export] private string _testVoiceLine = "";
	[Export] private double _testVoiceLineDelay;
	
	// Internal State Variables, Queued up Plays
	private double _clock;
	private readonly Queue<double> _beepTimes = [];

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		foreach (var breakInterval in _breakIntervals)
		{
			breakInterval.Initialize();
		}
		
		_audioStreamPlayer = GetChild<AudioStreamPlayer>(0);
		
		_audioStreamPlayer.Stream = _voiceStream;

		if (_testVoiceLine.Length > 0)
		{
			VoiceLine(_testVoiceLine, _testVoiceLineDelay);
		}
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		_clock += delta;
		if (!ShouldBeep()) return;
		_audioStreamPlayer.Stop();
		_audioStreamPlayer.Play();
		EmitSignal(SignalName.OnVoiceBeep);
	}

	private bool ShouldBeep()
	{
		if (!_beepTimes.TryPeek(out var nextBeep)) return false;
		if (!(nextBeep <= _clock)) return nextBeep <= _clock;
		_beepTimes.Dequeue();
		return nextBeep <= _clock;
	}
	
	// ReSharper disable once MemberCanBePrivate.Global
	public void VoiceLine(string lineToVoice, double extraDelay = 0.0)
	{
		var nextBeep = _clock + _beepInterval + extraDelay;

		foreach (var character in lineToVoice)
		{
			var updated = false;
			var shouldBeep = true;
			foreach (var interval in _breakIntervals)
			{
				if (!interval.CharSet.Contains(character)) continue;
				updated = true;
				shouldBeep = interval.ShouldBeep;
				nextBeep += interval.Interval;
				break;
			}

			if (!shouldBeep)
			{
				continue;
			}
			
			_beepTimes.Enqueue(nextBeep);
			if (!updated)
			{
				nextBeep += _beepInterval;
			}
		}
	}
}