
#include <FTGL/ftgl.h>
#include "label.h"


const string KCont_Text = "Text";

AVLabel::AVLabel(const string& aType, const string& aName, MEnv* aEnv): AVWidget(aType, aName, aEnv)
{
}

AVLabel::~AVLabel()
{
}

void AVLabel::onObsContentChanged(MObservable* aObl, const MContent* aCont)
{
    string data;
    aCont->getData(data);
    MContentOwner* cow = Owner()->lIf(cow);
    if (cow) {
	if (aCont == cow->getCont(KCont_Text)) {
	} else if (aCont == cow->getCont(KCnt_FontPath)) {
	    aCont->getData(mFontPath);
	}
    }
    AVWidget::onObsContentChanged(aObl, aCont);
}

void AVLabel::Render()
{
    if (!mIsInitialised) return;

    AVWidget::Render();

    int wlx, wty, wrx, wby;
    getAlcWndCoord(wlx, wty, wrx, wby);

    // Draw the name
    glColor3f(mFgColor.r, mFgColor.g, mFgColor.b);
    glRasterPos2f(wlx + 5, wby + 5);
    if (mFont) {
	mFont->Render(mIbText.data().c_str());
    }

    CheckGlErrors();
}

void AVLabel::onOwnerAttached()
{
    AVWidget::onOwnerAttached();
    getHostContent(KCnt_FontPath, mFontPath);
}

void AVLabel::updateRqsW()
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


