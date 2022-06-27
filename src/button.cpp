
#include <iostream> 
#include <FTGL/ftgl.h>

#include "button.h"
#include "mwindow.h"

const string KStateContVal = "";


AButton::AButton(const string& aType, const string& aName, MEnv* aEnv): AVWidget(aType, aName, aEnv)
{ }

MNode* AButton::GetStatePressed()
{
    return ahostNode()->getNode("Pressed");
}

bool AButton::onMouseButton(TFvButton aButton, TFvButtonAction aAction, int aMods)
{
    bool res = false;
    if (aButton == GLFW_MOUSE_BUTTON_LEFT && aAction == GLFW_PRESS) {
	double x = 0, y = 0;
	GetCursorPosition(x, y);
	if (IsInnerWidgetPos(x, y)) {
	    //cout << "UnitCrp [" << iMan->Name() << "], button" << endl;
	    MNode* spressed = GetStatePressed();
	    spressed->cntOw()->setContent(KStateContVal, "SB true");
	    // Activate "pressed" state to reset it
	    MDesInpObserver* spIo = spressed->lIf(spIo);
	    if (spIo) {
		spIo->onInpUpdated();
	    }
	}
    }
    return res;
}

void AButton::Render(bool aForce)
{
    //assert(mIsInitialised);
    if (!mIsInitialised) return;

    AVWidget::Render();

    int wlx, wty, wrx, wby;
    getAlcWndCoord(wlx, wty, wrx, wby);

    // Draw the name
    if (mFont) {
	int tW, tH;
	getTextRq(tW, tH);
	if ((wrx - wlx) >= tW && (wty - wby) >= tH) {
	    glColor4f(mFgColor.r, mFgColor.g, mFgColor.b, 1.0);
	    float depth = getDepth();
	    glRasterPos3f(wlx + 5, wby + 5, depth);
	    mFont->Render(mIbText.data().c_str());
	}
    }

    CheckGlErrors();
}

void AButton::Init()
{
    AVWidget::Init();
}

void AButton::updateRqsW()
{
    string& text = mIbText.data();
    int adv = (int) mFont->Advance(text.c_str());
    int tfh = (int) mFont->LineHeight();
    float llx, lly, llz, urx, ury, urz;
    mFont->BBox(text.c_str(), llx, lly, llz, urx, ury, urz);
    int minRw = (int) urx + 2 * K_Padding;
    mOstRqsW.updateData(minRw);
    int minRh = (int) ury + 2 * K_Padding;
    mOstRqsH.updateData(minRh);
}


void AButton::getTextRq(int& aW, int& aH)
{
    string& text = mIbText.data();
    int adv = (int) mFont->Advance(text.c_str());
    int tfh = (int) mFont->LineHeight();
    float llx, lly, llz, urx, ury, urz;
    mFont->BBox(text.c_str(), llx, lly, llz, urx, ury, urz);
    aW = (int) urx + 2 * K_Padding;
    aH = (int) ury + 2 * K_Padding;
}

