
#include <FTGL/ftgl.h>
#include "label.h"


AVLabel::AVLabel(const string& aType, const string& aName, MEnv* aEnv): AVWidget(aType, aName, aEnv)
{ }

void AVLabel::Render(bool aForce)
{
    if (!mIsInitialised) return;

    AVWidget::Render(aForce);

    int wlx, wty, wrx, wby;
    getAlcWndCoord(wlx, wty, wrx, wby);

    // Draw the name
    glColor3f(mFgColor.r, mFgColor.g, mFgColor.b);
    glRasterPos2f(wlx + 5, wby + 5);
    if (mFont) {
	// Don't render text if allocation is not suitable
	int alcW = GetParInt(KUri_AlcW);
	int aclH = GetParInt(KUri_AlcH);
	if (alcW >= mOstRqsW.mData.mData && aclH >= mOstRqsH.mData.mData) {
	    mFont->Render(mIbText.data().c_str());
	}
    }
    CheckGlErrors();
}

void AVLabel::updateRqsW()
{
    string& text = mIbText.data();
    if (mFont) {
	int adv = (int) mFont->Advance(text.c_str());
	int tfh = (int) mFont->LineHeight();
	float llx, lly, llz, urx, ury, urz;
	mFont->BBox(text.c_str(), llx, lly, llz, urx, ury, urz);
	int minRw = (int) urx + 2 * K_Padding;
	mOstRqsW.updateData(minRw);
	int minRh = (int) ury + 2 * K_Padding;
	mOstRqsH.updateData(minRh);
    }
}


