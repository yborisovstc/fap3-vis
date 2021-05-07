
#include <FTGL/ftgl.h>
#include "label.h"


const string KCont_Text = "Text";

AVLabel::AVLabel(const string& aName, MEnv* aEnv): AVWidget(aName, aEnv)
{
    if (aName.empty()) mName = Type();
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
    float xc = (float) GetParInt(KUri_AlcX);
    float yc = (float) GetParInt(KUri_AlcY);
    float wc = (float) GetParInt(KUri_AlcW);
    float hc = (float) GetParInt(KUri_AlcH);

    /* Create a pixmap font from a TrueType file. */
    FTGLPixmapFont font(mFontPath.c_str());

    if(font.Error()) {
	return;
    }

    GLint viewport[4];
    glGetIntegerv( GL_VIEWPORT, viewport );
    int vp_width = viewport[2], vp_height = viewport[3];

    glClearColor(0.0, 0.0, 0.0, 0.0); // Don't clear window
    glClear(GL_COLOR_BUFFER_BIT);
    
    glColor3f(mBgColor.r, mBgColor.g, mBgColor.b);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0, (GLdouble)vp_width, 0, (GLdouble)vp_height, -1.0, 1.0);
 
    // Set the font size and render a small text.
    font.FaceSize(hc);
    glRasterPos2f(xc, yc);
    font.Render("Hello World!");
    CheckGlErrors();
}

void AVLabel::onOwnerAttached()
{
    AVWidget::onOwnerAttached();
    getHostContent(KCnt_FontPath, mFontPath);
}
