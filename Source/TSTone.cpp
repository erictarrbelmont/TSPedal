/*
  ==============================================================================

    TSTone.cpp
    Created: 6 Feb 2021 1:59:16pm
    Author:  Hack Audio

  ==============================================================================
*/

#include "TSTone.h"



float TSTone::processSample(float Vi){
   
}

void TSTone::prepare(float newFs){
    
    if (Fs != newFs){
        Fs = newFs;
        updateCoefficients();
    }
    
}

void TSTone::setKnobs(float toneKnob, float outputKnob){
    
}

void TSTone::updateCoefficients(){
    
    Ts = 1.f/Fs;
    
}
