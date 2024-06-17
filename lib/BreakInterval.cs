using System.Collections.Generic;
using Godot;

namespace Voice;

[GlobalClass]
public partial class BreakInterval : Resource
{
    [Export] public double Interval;
    [Export] private string _characters;
    [Export] public bool ShouldBeep;
    [Export] public bool BreakAfter;
    public readonly HashSet<char> CharSet = [];

    // ReSharper disable once UnusedMember.Global
    public BreakInterval()
    {
        Interval = 0.0;
        _characters = "";
        ShouldBeep = false;
    }
    
    public BreakInterval(double interval, string characters, bool shouldBeep, bool breakAfter)
    {
        Interval = interval;
        _characters = characters;
        ShouldBeep = shouldBeep;
        BreakAfter = breakAfter;
    }

    public void Initialize()
    {
        foreach (var character in _characters)
        {
            CharSet.Add(character);
        }
    }
}