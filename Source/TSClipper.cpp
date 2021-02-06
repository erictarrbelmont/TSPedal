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
    float p = -Vi/(G4*R4) + R1/(G4*R4)*x1 - x2;
    
    int iter = 1;
    float b = 1.f;
    float fd = p + Vd/R2 + Vd/R3 + 2.f*Is * sinh(Vd/(eta*Vt));
    while (iter < 50 && abs(fd) > thr){
        float den = 2.f*Is/(eta*Vt) * cosh(Vd/(eta*Vt)) + 1.f/R2 + 1.f/R3;
        float Vnew = Vd - b*fd/den;
        float fn = p + Vnew/R2 + Vnew/R3 + 2.f*Is * sinh(Vnew/(eta*Vt));
        if (abs(fn) < abs(fd)){
            Vd = Vnew;
            b = 1.f;
        }
        else{
            b *= 0.5f;
        }
        fd = p + Vd/R2 + Vd/R3 + 2.f*Is * sinh(Vd/(eta*Vt));
        iter++;
    }
    float Vo = Vd + Vi;
    x1 = (2.f/R1)*(Vi/G1 + x1*R4/G1) - x1;
    x2 = (2.f/R2)*(Vd) - x2;
    
    return Vo;
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
    R1 = Ts/(2.f*C1);
    R2 = Ts/(2.*C2);
    P1 = drivePot*500e3;
    R3 = 51000.f + P1;
    R4 = 4700.f;
    
    // Combined Resistances
    G1 = (1.f + R4/R1);
    G4 = (1.f + R1/R4);
    
}


