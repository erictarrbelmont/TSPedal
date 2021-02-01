/*
  ==============================================================================

    This file contains the basic framework code for a JUCE plugin editor.

  ==============================================================================
*/

#pragma once

#include <JuceHeader.h>
#include "PluginProcessor.h"
#include "PedalComponent.h"

using KnobNames = std::tuple<StringRef,StringRef,StringRef>;

//==============================================================================
/**
*/
class TSPedalAudioProcessorEditor  : public juce::AudioProcessorEditor
{
public:
    TSPedalAudioProcessorEditor (TSPedalAudioProcessor&);
    ~TSPedalAudioProcessorEditor() override;

    //==============================================================================
    
    void paint (juce::Graphics&) override;
    void resized() override;

private:
    // This reference is provided as a quick way for your editor to
    // access the processor object that created it.
    TSPedalAudioProcessor& audioProcessor;
    
    Rectangle<int> PedalSize = {265,475};
    StringRef PedalName = "Tube Screamer";
    StringRef PedalShortName = "TS-1";
    KnobNames PedalKnobNames = {"Drive","Tone","Output"};
    Colour PedalColour = Colour(0xFF14BB67);
    
    PedalComponent pedal{audioProcessor,PedalName,PedalShortName,PedalColour,PedalKnobNames};

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (TSPedalAudioProcessorEditor)
};
