/*
  ==============================================================================

    TSTone.cpp
    Created: 6 Feb 2021 1:59:16pm
    Author:  Hack Audio

  ==============================================================================
*/

#include "TSTone.h"



float TSTone::processSample(float Vi){
    float Vo = b0*Vi + b1*x1 + b2*x2 + b3*x3 + b4*x4;
    float vx = Vi/(R6*Gz) + x1/Gz + x2*R2/(G2*Gz*P1);
    x1 = (2.f/R1)*(vx) - x1;
    x2 = (2.f/R2)*(vx/Gr + x2*(P1+R5)/Gr) - x2;
    x3 = (2.f/R3)*(vx/Gs + x3*(P2+R8)/Gs) - x3;
    x4 = 2*Vo/R11 + x4;
    return Vo;
}

void TSTone::prepare(float newFs){
    
    if (Fs != newFs){
        Fs = newFs;
        updateCoefficients();
    }
    
}

void TSTone::setKnobs(float toneKnob, float outputKnob){
    bool updateFlag = false;
    
    if (potTone != toneKnob){
        potTone = 0.00001f + 0.99998f*toneKnob;
        updateFlag = true;
    }
    
    if (potOut != outputKnob){
        potOut = 0.00001f + 0.999999f*outputKnob;
        updateFlag = true;
    }
    
    if (updateFlag){
        updateCoefficients();
    }
}

void TSTone::updateCoefficients(){
    
    Ts = 1.f/Fs;

    R1 = Ts/(2.f*C1);
    R2 = Ts/(2.f*C2);
    R3 = Ts/(2.f*C3);
    R4 = Ts/(2.f*C4);
    
    R10 = 100e3 * (1.f-potOut);
    R11 = 100e3 * potOut;

    P1 = 20000.f * potTone;
    P2 = 20000.f * (1.f-potTone);
    
    // Grouped resistances
    G2 = 1.f + R2/P1 + R5/P1;
    G3 = 1.f + R3/P2 + R8/P2;
    Gx = 1.f + R7/(G3*P2);
    Gz = (1.f/R1 + 1.f/R6 + 1.f/(G2*P1));
    Go = (1.f + R10/R11 + R9/R11 + R4/R11);
    Gr = 1.f + P1/R2 + R5/R2;
    Gs = 1.f + P2/R3 + R8/R3;
    
    b0 = Gx/(Go*R6*Gz);
    b1 = Gx/(Go*Gz);
    b2 = Gx*R2/(G2*Gz*Go*P1);
    b3 = -R3*R7/(Go*G3*P2);
    b4 = -R4/Go;
    
}
