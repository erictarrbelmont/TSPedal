/*
  ==============================================================================

    TSTone.h
    Created: 6 Feb 2021 1:59:16pm
    Author:  Hack Audio

  ==============================================================================
*/

#pragma once


class TSTone{
public:
    
    float processSample(float x);
    
    void prepare(float newFs);
    
    void setKnobs(float toneKnob, float outputKnob);
    
private:
    
    void updateCoefficients();
    
    float Fs = 48000.f;
    float Ts = 1.f/Fs;
    
    
};
