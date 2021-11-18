/*
  ==============================================================================

    TSClipper.cpp
    Created: 6 Feb 2021 2:26:49pm
    Author:  Hack Audio

  ==============================================================================
*/
#include <JuceHeader.h>
#include "TSClipper.h"

float TSClipper::processSample(float Vi){
    
}

void TSClipper::prepare(float newFs){
    
    if (Fs != newFs){
        Fs = newFs;
        updateCoefficients();
    }
    
}

void TSClipper::setKnob(float newDrive){
    
    if (drivePot != newDrive){
        drivePot = newDrive;
        updateCoefficients();
    }
}

void TSClipper::updateCoefficients(){
    
    Ts = 1.f/Fs;
    
    
}


