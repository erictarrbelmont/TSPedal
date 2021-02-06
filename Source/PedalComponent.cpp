#include "PedalComponent.h"

void PedalKnobLookAndFeel::drawRotarySlider(
    Graphics &g,
    int x,
    int y,
    int width,
    int height,
    float sliderPosProportional,
    float rotaryStartAngle,
    float rotaryEndAngle,
    Slider &slider)
{
    Rectangle<int> bounds(x, y, width, height);

    // MARK: Knob body
    {
        const auto centre = bounds.getCentre();

        ColourGradient gradient;
        gradient.point1 = centre.withY(bounds.getY()).toFloat();
        gradient.point2 = centre.withX(bounds.getBottom()).toFloat();
        gradient.addColour(0.0, Colours::white.withAlpha(0.2f));
        gradient.addColour(1.0, Colours::transparentWhite);
        gradient.isRadial = true;
        g.setGradientFill(gradient);
        g.fillEllipse(bounds.toFloat());

        bounds = bounds.reduced(2);

        gradient.clearColours();
        gradient.point1 = centre.toFloat();
        gradient.point2 = centre.withX(0).toFloat();
        gradient.addColour(0.0, Colours::black);
        gradient.addColour(1.0, Colours::black.brighter(0.2f));
        gradient.isRadial = true;
        g.setGradientFill(gradient);
        g.fillEllipse(bounds.toFloat());

        bounds = bounds.reduced(3);

        const auto thumbColour = slider
            .findColour(Slider::thumbColourId)
            .withMultipliedSaturation(1.10f)
            .withMultipliedBrightness(1.85f);

        g.setColour(thumbColour);
        g.fillEllipse(bounds.toFloat());

        gradient.clearColours();
        gradient.point1 = centre.withY(bounds.getY()).toFloat();
        gradient.point2 = centre.withX(bounds.getBottom()).toFloat();
        gradient.addColour(0.0, thumbColour.brighter());
        gradient.addColour(1.0, thumbColour.darker());
        gradient.isRadial = true;
        g.setGradientFill(gradient);
        g.fillEllipse(bounds.toFloat());

        bounds = bounds.reduced(2);

        gradient.clearColours();
        gradient.point1 = centre.withY(bounds.getY()).toFloat();
        gradient.point2 = centre.withX(bounds.getBottom()).toFloat();
        gradient.addColour(0.0, thumbColour);
        gradient.addColour(1.0, thumbColour.darker(0.4f));
        gradient.isRadial = true;
        g.setGradientFill(gradient);
        g.fillEllipse(bounds.toFloat());
    }

    // MARK: Knob indicator
    {
        const float length = bounds.expanded(4).getWidth();
        const float angle  = rotaryStartAngle + sliderPosProportional
                           * (rotaryEndAngle - rotaryStartAngle);

        const Line<float> indicator(
            bounds.getCentre().getPointOnCircumference(length / 2.0f, angle),
            bounds.getCentre().getPointOnCircumference(length / 5.0f, angle)
        );

        g.setColour(Colours::black.brighter(0.1f));
        g.drawLine(indicator, 5);
    }
}

// MARK: -

PedalComponent::PedalComponent(TSPedalAudioProcessor& p,
    const StringRef     &name,
    const StringRef     &shortName,
    const Colour        &pedalColour,
    const KnobNames  &knobNames) : processor(p)
{
    setName(name);
    setComponentID(shortName);

    colour = pedalColour;

    knobs[0].addListener(this);
    knobs[0].setName(std::get<0>(knobNames));
    knobs[0].setTooltip(std::get<0>(knobNames));
    knobs[0].setColour(Slider::thumbColourId, colour);
    knobs[0].setSliderStyle(Slider::RotaryHorizontalVerticalDrag);
    knobs[0].setTextBoxStyle(Slider::NoTextBox, true, 0, 0);
    knobs[0].setRange(0.f,1.f);
    knobs[0].setValue(processor.driveValue);
    addAndMakeVisible(knobs[0]);

    knobs[1].addListener(this);
    knobs[1].setName(std::get<1>(knobNames));
    knobs[1].setTooltip(std::get<1>(knobNames));
    knobs[1].setColour(Slider::thumbColourId, colour);
    knobs[1].setSliderStyle(Slider::RotaryHorizontalVerticalDrag);
    knobs[1].setTextBoxStyle(Slider::NoTextBox, true, 0, 0);
    knobs[1].setRange(0.f,1.f);
    knobs[1].setValue(processor.toneValue);
    addAndMakeVisible(knobs[1]);
    
    knobs[2].addListener(this);
    knobs[2].setName(std::get<2>(knobNames));
    knobs[2].setTooltip(std::get<2>(knobNames));
    knobs[2].setColour(Slider::thumbColourId, colour);
    knobs[2].setSliderStyle(Slider::RotaryHorizontalVerticalDrag);
    knobs[2].setTextBoxStyle(Slider::NoTextBox, true, 0, 0);
    knobs[2].setRange(0.f,1.f);
    knobs[2].setValue(processor.outputValue);
    addAndMakeVisible(knobs[2]);

    // JUCE components offer a built-in image buffering system so that expensive
    // runtime graphics don't need to be redrawn constantly. With image
    // buffering on, your component will draw to an image and use it as a cache.
    // The cache will only be updated when repaint() is explicitly called on our
    // pedal component (this happens in the areas around the knobs whenever the
    // child component knobs are turned)
    setBufferedToImage(true);

    // JUCE's LookAndFeel class allows you to create sets of custom drawing
    // functions to override JUCE's default graphics. Here we override the
    // drawing of the rotary knobs using our PedalKnobLookAndFeel defined above
    knobs[0].setLookAndFeel(lookAndFeel);
    knobs[1].setLookAndFeel(lookAndFeel);
    knobs[2].setLookAndFeel(lookAndFeel);
}

PedalComponent::~PedalComponent()
{
    // When using custom LookAndFeel objects, you must remember to reset any
    // components referencing them!
    knobs[0].setLookAndFeel(nullptr);
    knobs[1].setLookAndFeel(nullptr);
    knobs[2].setLookAndFeel(nullptr);
}

void PedalComponent::mouseUp(const MouseEvent &e)
{
    const auto buttonArea = getLocalBounds().removeFromBottom(175).reduced(15);

    // Here we can implement a very simple switch by simply setting the pedal's
    // enablement (and alpha) if the user clicks down and releases over the
    // "rubber" area
    const bool buttonClicked = buttonArea.contains(e.getPosition())
                            && buttonArea.contains(e.mouseDownPosition.toInt());

    if (buttonClicked)
    {
        setEnabled(!isEnabled());
        setAlpha(isEnabled() ? 1.0f : 0.4f);
        processor.effectOn = !processor.effectOn;
    }
}

void PedalComponent::paint(Graphics &g)
{
    const Graphics::ScopedSaveState _state(g);

    auto bounds = getLocalBounds();

    // MARK: Pedal body
    {
        g.setColour(colour.darker(0.1f));
        g.fillRoundedRectangle(bounds.toFloat(), 12.0f);

        ColourGradient gradient;
        gradient.point1 = bounds.getBottomLeft().toFloat();
        gradient.point2 = bounds.getCentre().withX(0).toFloat();
        gradient.addColour(0.0, colour.darker(0.4f));
        gradient.addColour(1.0, colour);
        g.setGradientFill(gradient);
        g.fillRoundedRectangle(bounds.reduced(2).toFloat(), 12.0f);
    }

    // Reduce our bounds to give us a small margin when drawing
    bounds.reduce(15, 15);

    // MARK: Foot area rubber
    {
        auto buttonArea = bounds.removeFromBottom(175);

        ColourGradient gradient;
        gradient.point1 = buttonArea.getBottomLeft().toFloat();
        gradient.point2 = buttonArea.getTopLeft().toFloat();
        gradient.addColour(0.0, Colours::black.withAlpha(0.33f));
        gradient.addColour(0.1, Colours::transparentWhite);
        gradient.addColour(0.9, Colours::transparentBlack);
        gradient.addColour(1.0, Colours::black.withAlpha(0.33f));
        g.setGradientFill(gradient);
        g.fillRoundedRectangle(buttonArea.toFloat(), 12.0f);

        buttonArea = buttonArea.reduced(2);

        g.setColour(Colours::black.brighter(0.2));
        g.fillRoundedRectangle(buttonArea.toFloat(), 12.0f);

        gradient.clearColours();
        gradient.point1 = buttonArea.getBottomLeft().toFloat();
        gradient.point2 = buttonArea.getTopLeft().toFloat();
        gradient.addColour(0.0, Colours::black);
        gradient.addColour(0.9, Colours::black.withAlpha(0.5f));
        gradient.addColour(1.0, Colours::white.withAlpha(0.25f));
        g.setGradientFill(gradient);
        g.fillRoundedRectangle(buttonArea.toFloat(), 12.0f);

        buttonArea = buttonArea.reduced(2);

        gradient.clearColours();
        gradient.point1 = buttonArea.getBottomLeft().toFloat();
        gradient.point2 = buttonArea.getTopLeft().toFloat();
        gradient.addColour(0.0, Colours::black.brighter(0.1));
        gradient.addColour(1.0, Colours::black.brighter(0.2));
        g.setGradientFill(gradient);
        g.fillRoundedRectangle(buttonArea.toFloat(), 12.0f);

        buttonArea = buttonArea.removeFromBottom(75).reduced(15);

        for (float ratio = 0.0f; ratio < 1.0f; ratio += 0.33f)
        {
            g.setColour(Colours::white.withAlpha(0.33f));
            g.drawHorizontalLine(
                buttonArea.getY() + buttonArea.getHeight() * ratio,
                buttonArea.getX(),
                buttonArea.getRight()
            );

            g.setColour(Colours::black.withAlpha(0.66f));
            g.drawHorizontalLine(
                buttonArea.getY() + 1 + buttonArea.getHeight() * ratio,
                buttonArea.getX(),
                buttonArea.getRight()
            );
            g.drawHorizontalLine(
                buttonArea.getY() - 1 + buttonArea.getHeight() * ratio,
                buttonArea.getX(),
                buttonArea.getRight()
            );
        }
    }

    // MARK: Pedal name and identifier
    {
        g.setFont(24.0f);
        g.setColour(Colours::black.withAlpha(0.75f));

        g.drawText(
            getComponentID(),
            bounds.removeFromBottom(32),
            Justification::centredRight
        );

        g.drawText(
            getName(),
            bounds.removeFromBottom(32),
            Justification::centredRight
        );
    }

    // MARK: Foot area lighting
    for (int i = 0; i < 2; ++i)
    {
        auto lightingArea = bounds
            .removeFromBottom(20 - (i * 7))
            .withX(1)
            .withRight(getWidth() - 1);

        // Flip which side (top or bottom) we're rounding based on our iterator
        Path roundedTop;
        roundedTop.addRoundedRectangle(
            lightingArea.getX(),     lightingArea.getY(),
            lightingArea.getWidth(), lightingArea.getHeight(),
            12.0f, 12.0f, // cornerSizeX, cornerSizeY
            i == 0,       // curveTopLeft
            i == 0,       // curveTopRight
            i == 1,       // curveBottomLeft
            i == 1        // curveBottomRight
        );

        ColourGradient gradient;
        gradient.point1 = lightingArea.getTopLeft().toFloat();
        gradient.point2 = lightingArea.getBottomLeft().toFloat();
        gradient.addColour(0.0, Colours::transparentWhite);
        gradient.addColour(0.5, Colours::white.withAlpha(0.33f));
        gradient.addColour(1.0, Colours::transparentWhite);
        g.setGradientFill(gradient);
        g.fillPath(roundedTop);
    }

    // MARK: Knobs background area
    {
        auto lightingArea = bounds
            .removeFromTop(160)
            .withY(5)
            .withX(5)
            .withRight(getWidth() - 5);

        Path roundedTop;
        roundedTop.addRoundedRectangle(
            lightingArea.getX(),     lightingArea.getY(),
            lightingArea.getWidth(), lightingArea.getHeight(),
            12.0f, 12.0f, // cornerSizeX, cornerSizeY
            true,         // curveTopLeft
            true,         // curveTopRight
            false,        // curveBottomLeft
            false         // curveBottomRight
        );

        ColourGradient gradient;
        gradient.point1 = lightingArea.getBottomLeft().toFloat();
        gradient.point2 = lightingArea.getTopLeft().toFloat();
        gradient.addColour(0.0, Colours::black);
        gradient.addColour(1.0, Colours::black.brighter(0.1f));
        g.setGradientFill(gradient);
        g.fillPath(roundedTop);
    }

    // MARK: Knob labels
    {
        g.setColour(Colours::white.withAlpha(0.75f));
        g.setFont(16.0f);
        for (const auto& knob : knobs)
            g.drawText(
                knob.getName(),
                knob.getBounds().translated(0, 32),
                Justification::centredBottom
            );
    }
}

void PedalComponent::resized()
{
    // FlexBox is a powerful layout system adopted from web development
    // standards. Here we create a simple horizontal layout to evenly space our
    // knobs out without having to manually calculate positions.
    FlexBox flexbox;
    flexbox.justifyContent = FlexBox::JustifyContent::spaceAround;
    flexbox.alignContent   = FlexBox::AlignContent::center;
    flexbox.alignItems     = FlexBox::AlignItems::center;

    for (auto& knob : knobs)
        flexbox.items.add(FlexItem(70.0f, 70.0f, knob));

    flexbox.performLayout(getLocalBounds().removeFromTop(160));
}


void PedalComponent::sliderValueChanged(Slider * slider){
    if (slider == &knobs[0]){
        processor.driveValue = knobs[0].getValue();
    }
    if (slider == &knobs[1]){
        processor.toneValue = knobs[1].getValue();
    }
    if (slider == &knobs[2]){
        processor.outputValue = knobs[2].getValue();
    }
}
