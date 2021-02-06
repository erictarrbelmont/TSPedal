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
    
    const float eta = 1.f; // Change for non-ideal diode
    const float Is = 1e-15;
    const float Vt = 26e-3;
    
    float Fs = 48000.f;
    float Ts = 1.f/Fs;
    
    float C1 = 47e-9;
    float R1 = Ts/(2.f*C1);
    float C2 = 51e-12;
    float R2 = Ts/(2.*C2);
    float drivePot = 1.f;
    float P1 = drivePot*500e3;
    float R3 = 51000.f + P1;
    float R4 = 4700.f;

    // Combined Resistances
    float G1 = (1.f + R4/R1);
    float G4 = (1.f + R1/R4);
    
    // States
    float x1 = 0.f;
    float x2 = 0.f;
    float Vd = 0.f;
    
    float thr = 0.00000000001f;
    
    void updateCoefficients();
};
