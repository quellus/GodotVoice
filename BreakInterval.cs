using System.Collections.Generic;
using System.ComponentModel;
using Godot;

namespace Voice;

[GlobalClass]
public partial class BreakInterval : Resource
{
    [Export, Description("The amount of time to pause before the next beep")] 
    public double Interval;
    [Export, Description("A string containing the INDIVIDUAL CHARACTERS that will trigger this Break Interval")] 
    private string _characters;
    [Export, Description("Whether this Break Interval will trigger a beep or not")] 
    public bool ShouldBeep;
    public readonly HashSet<char> CharSet = [];

    // ReSharper disable once UnusedMember.Global
    public BreakInterval()
    {
        Interval = 0.0;
        _characters = "";
        ShouldBeep = false;
    }
    
    public BreakInterval(double interval, string characters, bool shouldBeep)
    {
        Interval = interval;
        _characters = characters;
        ShouldBeep = shouldBeep;
    }

    public void Initialize()
    {
        foreach (var character in _characters)
        {
            CharSet.Add(character);
        }
    }
}