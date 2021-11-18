/*
  ==============================================================================

    TSClipper.h
    Created: 6 Feb 2021 2:26:49pm
    Author:  Hack Audio

  ==============================================================================
*/

#pragma once


class TSClipper{
public:

    float processSample(float Vi);
    
    void prepare(float newFs);
    
    void setKnob(float newDrive);
    
    
    
private:
    
    
    
    void updateCoefficients();
};
