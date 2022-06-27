

#include <iostream> 
#include <rdata.h>
#include <FTGL/ftgl.h>

#include "utils.h"
#include "widget.h"
#include "mwindow.h"

#include "deps/linmath.h" // Ref https://github.com/glfw/glfw/tree/master/deps

const float KDepthDelta = -0.01;

static const struct
{
    float x, y;
    float r, g, b;
} vertices[3] =
{
    { -0.6f, -0.4f, 1.f, 0.f, 0.f },
    {  0.6f, -0.4f, 0.f, 1.f, 0.f },
    {   0.f,  0.6f, 0.f, 0.f, 1.f }
};

static const char* vertex_shader_text =
"#version 110\n"
"uniform mat4 MVP;\n"
"attribute vec3 vCol;\n"
"attribute vec2 vPos;\n"
"varying vec3 color;\n"
"void main()\n"
"{\n"
"    gl_Position = MVP * vec4(vPos, 0.0, 1.0);\n"
"    color = vCol;\n"
"}\n";

static const char* fragment_shader_text =
"#version 110\n"
"varying vec3 color;\n"
"void main()\n"
"{\n"
"    gl_FragColor = vec4(color, 1.0);\n"
"}\n";

const string KVP_Frame = "Frame";

const string KCnt_BgColor = "BgColor";
const string KCnt_FgColor = "FgColor";
const string AVWidget::KCnt_FontPath = "FontPath";
const string KCnt_R = "R";
const string KCnt_G = "G";
const string KCnt_B = "B";
const string KCnt_A = "A";
const string AVWidget::KUri_AlcX = "AlcX";
const string AVWidget::KUri_AlcY = "AlcY";
const string AVWidget::KUri_AlcW = "AlcW";
const string AVWidget::KUri_AlcH = "AlcH";

const string AVWidget::KUri_LocPars = "VisPars";

const string KUri_InpFontPath = "InpFont";
const string KUri_InpText = "InpText";
const string KUri_OutpRqsW = "OutpRqsW";
const string KUri_OutpRqsH = "OutpRqsH";
const string KUri_OutpName = "OutpName";
const string KUri_OutpLbpUri = "OutpLbpUri";

// Visualizatio paremeters
const string AVWidget::KVp_Border = "Border";

const int AVWidget::K_Padding = 5; /**< Base metric: Base padding */

static GLuint vertex_buffer, vertex_shader, fragment_shader;
static GLint mMvpLocation, vpos_location, vcol_location;

AVWidget::AVWidget(const string& aType, const string& aName, MEnv* aEnv): ADes(aType, aName, aEnv),
    mIsInitialised(false),
    mIbFontPath(this, KUri_InpFontPath), mIbText(this, KUri_InpText),
    mOstRqsW(this, KUri_OutpRqsW), mOstRqsH(this, KUri_OutpRqsH), mOstLbpUri(this, KUri_OutpLbpUri),
    mFont(nullptr), mBgColor({0.0, 0.0, 0.0, 0.0}), mFgColor({0.0, 0.0, 0.0, 0.0}), mChanged(true)
{
}

AVWidget::~AVWidget()
{
}

MIface* AVWidget::MAgent_getLif(const char *aType)
{
    MIface* res = nullptr;
    if (res = checkLif<MSceneElem>(aType));
    else if (res = ADes::MAgent_getLif(aType));
    return res;
}

MIface* AVWidget::MNode_getLif(const char *aType)
{
    MIface* res = nullptr;
    if (res = checkLif<MSceneElem>(aType));
    else if (res = checkLif<MProvider>(aType));
    else if (res = ADes::MNode_getLif(aType));
    return res;
}

MIface* AVWidget::MOwner_getLif(const char *aType)
{
    MIface* res = nullptr;
    if (res = checkLif<MSceneElem>(aType));
    else if (res = ADes::MNode_getLif(aType));
    return res;
}

MIface* AVWidget::MDesSyncable_getLif(const char *aType)
{
    MIface* res = nullptr;
    if (res = checkLif<MSceneElem>(aType)); // To allow DES access to Selem
    else if (res = ADes::MDesSyncable_getLif(aType));
    return res;
}

void AVWidget::resolveIfc(const string& aName, MIfReq::TIfReqCp* aReq)
{
    if (aName == MWindow::Type()) {
	MUnit* owu = ahostNode()->owned()->firstPair()->provided()->lIf(owu);
	MWindow* ifr = owu->getSif(ifr);
	if (ifr && !aReq->binded()->provided()->findIface(ifr)) {
	    addIfpLeaf(ifr, aReq);
	}
    } else if (aName == MDesInpObserver::Type()) {
	for (auto iap : mIbs) {
	    rifDesIobs(*iap, aReq);
	}
    } else if (aName == MDVarGet::Type()) {
	for (auto item : mOsts) {
	    rifDesOsts(*item, aReq);
	}
    } else {
	ADes::resolveIfc(aName, aReq);
    }
}

bool AVWidget::rifDesIobs(DesEIbb& aIap, MIfReq::TIfReqCp* aReq)
{
    bool res = false;
    MNode* cp = getNode(aIap.getUri());
    if (isRequestor(aReq, cp)) {
	MIface* iface = dynamic_cast<MDesInpObserver*>(&aIap);
	addIfpLeaf(iface, aReq);
	res = true;
    }
    return res;
}

bool AVWidget::rifDesOsts(DesEOstb& aItem, MIfReq::TIfReqCp* aReq)
{
    bool res = false;
    MNode* cp = getNode(aItem.getCpUri());
    if (isRequestor(aReq, cp)) {
	MIface* iface = dynamic_cast<MDVarGet*>(&aItem);
	addIfpLeaf(iface, aReq);
	res = true;
    }
    return res;
}



void AVWidget::update()
{
    //Logger()->Write(EInfo, this, "Update");
    for (auto iap : mIbs) {
	if (iap->mActivated) {
	    iap->update();
	}
    }
    ADes::update();
}

void AVWidget::confirm()
{
    Logger()->Write(EInfo, this, "Confirm");
    for (auto iap : mIbs) {
	if (iap->mUpdated) {
	    iap->mChanged = false;
	    iap->confirm();
	}
    }
    if (mIbFontPath.mChanged) {
	updateFont();
	updateRqsW();
    }
    if (mIbText.mChanged) {
	updateRqsW();
    }
    ADes::confirm();
    if (!mIsInitialised) {
	Init();
	mIsInitialised = true;
    } else {
#ifdef _SIU_RDC_
	Render();
#endif
    }
    mChanged = true;
}

void AVWidget::CheckGlErrors()
{
    // check for errors
    const GLenum errCode = glGetError();
    if (errCode != GL_NO_ERROR){
	const GLubyte *errString;
	errString=gluErrorString(errCode);
	printf("error: %s\n", errString);
    }
}

// TODO Invalid data case is not handled. To handle.
int AVWidget::GetParInt(const string& aUri)
{
    int res = 0;
    MAhost* ahost = mAgtCp.firstPair()->provided();
    MNode* hostn = ahost ? ahost->lIf(hostn) : nullptr;
    MNode* pu = hostn ? hostn->getNode(aUri, this) : nullptr;
    MDVarGet* pvg = pu->lIf(pvg);
    MDtGet<Sdata<int>>* psi = pvg ? pvg->GetDObj(psi) : nullptr;
    Sdata<int> pi = 0;
    psi->DtGet(pi);
    return pi.mData;
}

void AVWidget::getAlcWndCoord(int& aLx, int& aTy, int& aRx, int& aBy)
{
    float wc = (float) GetParInt(KUri_AlcW);
    float hc = (float) GetParInt(KUri_AlcH);
    getWndCoord(0, 0, aLx, aTy);
    getWndCoord(wc, hc, aRx, aBy);
    int wndWidth = 0, wndHeight = 0;
    Wnd()->GetFbSize(&wndWidth, &wndHeight);
    aTy = wndHeight - aTy;
    aBy = aTy - hc;
}

void AVWidget::getBgColor(float& r, float& g, float& b, float a) const
{
    r = mBgColor.r;
    g = mBgColor.g;
    b = mBgColor.b;
    a = mBgColor.a;
}

float AVWidget::getDepth()
{
    float res = -0.5;
    // Owner of owner
    MOwner* owo = ahostNode()->owned()->pcount() > 0 ? ahostNode()->owned()->pairAt(0)->provided() : nullptr;
    MUnit* owu = owo ? owo->lIf(owu) : nullptr;
    MSceneElem* owse = owu ? owu->getSif(owse) : nullptr;
    if (owse) {
	float ownerDepth = owse->getDepth();
	if (true /*ownerDepth > KDepthDelta*/) {
	    res = ownerDepth - KDepthDelta;
	}
    }
    return res;
}

bool AVWidget::isOverlayed()
{
    int wlx, wwty, wrx, wwby;
    getAlcWndCoord(wlx, wwty, wrx, wwby);
    //return (wlx <= mPblx && wwby <= mPbly && wrx >= mPtrx && wwty >= mPtry);
    return (wlx == mPblx && wwby <= mPbly && wrx >= mPtrx && wwty == mPtry);
}

void AVWidget::fillOutOverlayingBg()
{
    int wlx, wwty, wrx, wwby;
    getAlcWndCoord(wlx, wwty, wrx, wwby);
    if (wrx != mPtrx || wwby != mPbly) {
	Log(TLog(EInfo, this) + "fillOvl: " + to_string(mPblx) + ", " + to_string(mPbly) + ", " + to_string(mPtrx) + ", " + to_string(mPtry) + ", " + to_string(wrx) + ", " + to_string(wwby));
	glColor4f(mBgColor.r, mBgColor.g, mBgColor.b, mBgColor.a);
	float depth = 0.0;
	// Right
	glPolygonMode(GL_FRONT, GL_FILL);
	glBegin(GL_POLYGON);
	glVertex3f(mPtrx, mPtry, depth);
	glVertex3f(mPtrx, mPbly, depth);
	glVertex3f(wrx, wwby, depth);
	glVertex3f(wrx, wwty, depth);
	glEnd();
	// Bottom
	glPolygonMode(GL_FRONT, GL_FILL);
	glBegin(GL_POLYGON);
	glVertex3f(mPblx, mPbly, depth);
	glVertex3f(mPblx, wwby, depth);
	glVertex3f(wrx, wwby, depth);
	glVertex3f(wrx, mPbly, depth);
	glEnd();
    }
}

#ifdef _SIU_UCI_
void AVWidget::cleanSelem()
{
    if (!mIsInitialised) return;
    MSceneElem* owrselem = getOwnerSelem();
    if (owrselem && isChangeCrit()) {
	//Log(TLog(EInfo, this) + "Clean: " + to_string(mPblx) + ", " + to_string(mPbly) + ", " + to_string(mPtrx) + ", " + to_string(mPtry));
	owrselem->onRectInval(mPblx, mPbly, mPtrx, mPtry, getDepth() - 0.001, this);
    }
}
#endif // _SIU_UCI_

#ifdef _SDR_
void AVWidget::cleanSelem()
{
    if (!mIsInitialised) return;
    MSceneElem* owrselem = getOwnerSelem();
    if (owrselem/* && !isOverlayed()*/) {
	//owrselem->onRectInval(mPblx, mPbly, mPtrx, mPtry, getDepth() - 0.001);
	float cr = 0.0, cg = 0.0, cb = 0.0, ca = 1.0;
//	owrselem->getBgColor(cr, cg, cb, ca);
	// Background
	float depth = getDepth() + 0.0001;
	Log(TLog(EInfo, this) + "Clean: " + to_string(mPblx) + ", " + to_string(mPbly) + ", " + to_string(mPtrx) + ", " + to_string(mPtry) + ", d: " + to_string(depth));
	glColor4f(cr, cg, cb, ca);
	glPolygonMode(GL_FRONT, GL_FILL);
	glBegin(GL_POLYGON);
	glVertex3f(mPtrx, mPtry, depth);
	glVertex3f(mPblx, mPtry, depth);
	glVertex3f(mPblx, mPbly, depth);
	glVertex3f(mPtrx, mPbly, depth);
	glEnd();
	// Border
	bool vpBorder;
	bool res = getVisPar(KVp_Border, vpBorder);
	if (res && vpBorder) {
	    glColor4f(cr, cg, cb, ca);
	    glPolygonMode(GL_FRONT, GL_LINE);
	    glBegin(GL_POLYGON);
	    glVertex3f(mPtrx, mPtry, depth);
	    glVertex3f(mPblx, mPtry, depth);
	    glVertex3f(mPblx, mPbly, depth);
	    glVertex3f(mPtrx, mPbly, depth);
	    glEnd();
	}
    }
}
#endif // _SDR_

void AVWidget::Render(bool aForce)
{
    if (!mIsInitialised) return;

    float depth = getDepth();

    // Debugging only, to remove
    int xc, yc, wc, hc;
    GetAlc(xc, yc, wc, hc);

    //Log(TLog(EInfo, this) + "Render: " + to_string(xc) + ", " + to_string(yc) + ", " + to_string(wc) + ", " + to_string(hc) + ", d: " + to_string(depth));
    // Get viewport parameters
    GLint viewport[4];
    glGetIntegerv( GL_VIEWPORT, viewport );
    int vp_width = viewport[2], vp_height = viewport[3];

    // Window coordinates
    int wlx, wwty, wrx, wwby;
    getAlcWndCoord(wlx, wwty, wrx, wwby);
    mPblx = wlx; mPbly = wwby; mPtrx = wrx; mPtry = wwty;
    Log(TLog(EInfo, this) + "Render: " + to_string(mPblx) + ", " + to_string(mPbly) + ", " + to_string(mPtrx) + ", " + to_string(mPtry));

    // Background
    glColor4f(mBgColor.r, mBgColor.g, mBgColor.b, mBgColor.a);
    //glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
    glPolygonMode(GL_FRONT, GL_FILL);
    glBegin(GL_POLYGON);
    glVertex3f(wrx, wwty, depth);
    glVertex3f(wlx, wwty, depth);
    glVertex3f(wlx, wwby, depth);
    glVertex3f(wrx, wwby, depth);
    glEnd();

    // Border
    bool vpBorder;
    bool res = getVisPar(KVp_Border, vpBorder);
    if (res && vpBorder) {
	glColor4f(mFgColor.r, mFgColor.g, mFgColor.b, mFgColor.a);
	/*
	DrawLine(wlx, wwty, wlx, wwby, depth);
	DrawLine(wlx, wwby, wrx, wwby, depth);
	DrawLine(wrx, wwby, wrx, wwty, depth);
	DrawLine(wrx, wwty, wlx, wwty, depth);
	*/
	glPolygonMode(GL_FRONT, GL_LINE);
	glBegin(GL_POLYGON);
	glVertex3f(wrx, wwty, depth);
	glVertex3f(wlx, wwty, depth);
	glVertex3f(wlx, wwby, depth);
	glVertex3f(wrx, wwby, depth);
	glEnd();
    }

    CheckGlErrors();
    mChanged = false;
}

void AVWidget::Init()
{
    // TODO proto legacy? remove
    /*
    glGenBuffers(1, &vertex_buffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertex_buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

    vertex_shader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertex_shader, 1, &vertex_shader_text, NULL);
    glCompileShader(vertex_shader);
    CheckGlErrors();

    fragment_shader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragment_shader, 1, &fragment_shader_text, NULL);
    glCompileShader(fragment_shader);

    mProgram = glCreateProgram();
    glAttachShader(mProgram, vertex_shader);
    glAttachShader(mProgram, fragment_shader);
    glLinkProgram(mProgram);
    CheckGlErrors();

    mMvpLocation = glGetUniformLocation(mProgram, "MVP");
    vpos_location = glGetAttribLocation(mProgram, "vPos");
    vcol_location = glGetAttribLocation(mProgram, "vCol");
    glEnableVertexAttribArray(vpos_location);
    glVertexAttribPointer(vpos_location, 2, GL_FLOAT, GL_FALSE,
	    sizeof(vertices[0]), (void*) 0);
    glEnableVertexAttribArray(vcol_location);
    glVertexAttribPointer(vcol_location, 3, GL_FLOAT, GL_FALSE,
	    sizeof(vertices[0]), (void*) (sizeof(float) * 2));
	    */
}

string AVWidget::colorCntUri(const string& aType, const string& aPart)
{
    GUri res(aType);
    res.appendElem(aPart);
    return res;
}


void AVWidget::onObsContentChanged(MObservable* aObl, const MContent* aCont)
{
    string data;
    aCont->getData(data);
    MContentOwner* cow = Owner()->lIf(cow);
    if (cow) {
	if (aCont == cow->getCont(colorCntUri(KCnt_BgColor, KCnt_R))) {
	    mBgColor.r = stof(data);
	} else if (aCont == cow->getCont(colorCntUri(KCnt_BgColor, KCnt_G))) {
	    mBgColor.g = stof(data);
	} else if (aCont == cow->getCont(colorCntUri(KCnt_BgColor, KCnt_B))) {
	    mBgColor.b = stof(data);
	} else if (aCont == cow->getCont(colorCntUri(KCnt_BgColor, KCnt_A))) {
	    mBgColor.a = stof(data);
	} else if (aCont == cow->getCont(colorCntUri(KCnt_FgColor, KCnt_R))) {
	    mFgColor.r = stof(data);
	} else if (aCont == cow->getCont(colorCntUri(KCnt_FgColor, KCnt_G))) {
	    mFgColor.g = stof(data);
	} else if (aCont == cow->getCont(colorCntUri(KCnt_FgColor, KCnt_B))) {
	    mFgColor.b = stof(data);
	} else if (aCont == cow->getCont(colorCntUri(KCnt_FgColor, KCnt_A))) {
	    mFgColor.a = stof(data);
	}
    }
}

void AVWidget::onSeCursorPosition(double aX, double aY)
{
    // Window coordinates
    int wc = GetParInt(KUri_AlcW);
    int hc = GetParInt(KUri_AlcH);
    int wx0 = 0, wy0 = 0, wxw = 0, wyh = 0;
    getWndCoord(0, 0, wx0, wy0);
    getWndCoord(wc, hc, wxw, wyh);
    int wdX = aX - wx0;
    int wdY = aY - wy0;
    if (wdX >= 0 && wdX < wc && wdY >= 0 && wdY < hc) {
	onWdgCursorPos(wdX, wdY);
    }
}

bool AVWidget::IsInnerWidgetPos(double aX, double aY)
{
    int wc = GetParInt(KUri_AlcW);
    int hc = GetParInt(KUri_AlcH);
    int wlx = 0, wty = 0, wrx = 0, wby = 0;
    getWndCoord(0, 0, wlx, wty);
    getWndCoord(wc, hc, wrx, wby);
    int wndWidth = 0, wndHeight = 0;
    Wnd()->GetFbSize(&wndWidth, &wndHeight);
    int wwty = wndHeight - wty;
    int wwby = wwty - hc;
    return (aX > wlx && aX < wrx && aY > wwby && aY < wwty);
}

void AVWidget::onWdgCursorPos(int aX, int aY)
{
    //cout << "Widget [" << iMan->Name() << "], cursor, X: " << aX << ", Y:" << aY << endl;
}

MSceneElem* AVWidget::getOwnerSelem()
{
    MSceneElem* owner = nullptr;
    // Get access to owners owner via MAhost iface
    if (mAgtCp.firstPair()) {
	MAhost* ahost = mAgtCp.firstPair()->provided();
	MNode* ahn = ahost->lIf(ahn);
	auto ahnoCp = ahn->owned()->pcount() > 0 ? ahn->owned()->pairAt(0) : nullptr;
	MOwner* ahno = ahnoCp ? ahnoCp->provided() : nullptr;
	MUnit* ahnou = ahno->lIf(ahnou);
	owner = ahnou->getSif(owner);
    }
    return owner;
}

void AVWidget::getWndCoord(int aInpX, int aInpY, int& aOutX, int& aOutY)
{
    // Get access to owners owner via MAhost iface
    MAhost* ahost = mAgtCp.firstPair()->provided();
    MNode* ahn = ahost->lIf(ahn);
    auto ahnoCp = ahn->owned()->pcount() > 0 ? ahn->owned()->pairAt(0) : nullptr;
    MOwner* ahno = ahnoCp ? ahnoCp->provided() : nullptr;
    MUnit* ahnou = ahno->lIf(ahnou);
    MSceneElem* owner = ahnou->getSif(owner);
    if (owner) {
	int x = GetParInt(KUri_AlcX);
	int y = GetParInt(KUri_AlcY);
	owner->getWndCoord(x + aInpX, y + aInpY, aOutX, aOutY);
    } else {
	aOutX = aInpX;
	aOutY = aInpY;
    }
}

int AVWidget::WndX(int aX)
{
    int wx = 0, wy = 0;
    getWndCoord(aX, 0, wx, wy);
    return wx;
}

int AVWidget::WndY(int aY)
{
    int wx = 0, wy = 0;
    getWndCoord(0, aY, wx, wy);
    return wy;
}

bool AVWidget::onMouseButton(TFvButton aButton, TFvButtonAction aAction, int aMods)
{
    bool res = false;
    double x = 0, y = 0;
    GetCursorPosition(x, y);
    if (IsInnerWidgetPos(x, y)) {
	//cout << "Widget [" << iMan->Name() << "], button" << endl;
	if (aButton == EFvBtnLeft && aAction == EFvBtnActPress) {
	    mOstLbpUri.updateData(GUri(ahostNode()->name()));
	} else if (aButton == EFvBtnLeft && aAction == EFvBtnActRelease) {
	    mOstLbpUri.updateInvalid();
	}
	res = true;
    }
    return res;
}

void AVWidget::GetCursorPosition(double& aX, double& aY)
{
    MWindow* wnd = Wnd();
    wnd->GetCursorPos(aX, aY);
}


MWindow* AVWidget::Wnd()
{
    auto ifs = defaultIfProv(MWindow::Type())->ifaces();
    MWindow* mwnd = ifs->empty() ? nullptr : (MWindow*) ifs->at(0);
    return mwnd;
}

void AVWidget::DrawLine(float x1, float y1, float x2, float y2, float depth)
{
    glBegin(GL_LINES);
    glVertex3f(x1, y1, depth);
    glVertex3f(x2, y2, depth);
    glEnd();
}

bool AVWidget::getHostContent(const GUri& aCuri, string& aRes) const
{
    bool res = false;
    MAhost* ahost = const_cast<TAgtCp&>(mAgtCp).firstPair()->provided();
    MContentOwner* cnto = ahost ? ahost->lIf(cnto) : nullptr;
    if (cnto) {
	res = cnto->getContent(aCuri, aRes);
    }
    return res;
 
}

MUnit* AVWidget::getHostOwnerUnit()
{
    MUnit* res = nullptr;
    MAhost* ahost = mAgtCp.firstPair()->provided();
    MNode* ahn = ahost->lIf(ahn);
    auto ahnoCp = ahn->owned()->pcount() > 0 ? ahn->owned()->pairAt(0) : nullptr;
    MOwner* ahno = ahnoCp ? ahnoCp->provided() : nullptr;
    res = ahno->lIf(res);
    return res;
}

void AVWidget::mutateNode(MNode* aNode, const TMut& aMut)
{
    MChromo* chr = mEnv->provider()->createChromo(); chr->Init(ENt_Note);
    chr->Root().AddChild(aMut);
    aNode->mutate(chr->Root(), false, MutCtx(), true);
    delete chr;
}

void AVWidget::GetAlc(int& aX, int& aY, int& aW, int& aH)
{
    aX = GetParInt(KUri_AlcX);
    aY = GetParInt(KUri_AlcY);
    aW = GetParInt(KUri_AlcW);
    aH = GetParInt(KUri_AlcH);
}

void AVWidget::registerIb(DesEIbb* aIb)
{
    MNode* cp = Provider()->createNode(aIb->mCpType, aIb->getUri(), mEnv);
    assert(cp);
    bool res = attachOwned(cp);
    assert(res);
    mIbs.push_back(aIb);
}

void AVWidget::registerOst(DesEOstb* aItem)
{
    MNode* cp = Provider()->createNode(aItem->mCpType, aItem->getCpUri(), mEnv);
    assert(cp);
    bool res = attachOwned(cp);
    assert(res);
    mOsts.push_back(aItem);
}

void AVWidget::updateFont()
{
    if (mFont) {
	delete mFont; mFont = nullptr;
    }
    mFont = new FTPixmapFont(mIbFontPath.data().c_str());
    mFont->FaceSize(18);
}

bool AVWidget::getLocalStyleParam(const string& aId, string& aParam) const
{
    bool res = false;
    return res;
}

bool AVWidget::getVStyleParam(const string& aId, string& aParam)
{
    bool res = false;
    return res;
}

// Local provider

MNode* AVWidget::createNode(const string& aType, const string& aName, MEnv* aEnv)
{
    MNode* res = nullptr;
    return res;
}

MNode* AVWidget::provGetNode(const string& aUri)
{
    MNode* res = nullptr;
    return res;
}

bool AVWidget::isProvided(const MNode* aElem) const
{
    return false;
}

void AVWidget::setEnv(MEnv* aEnv)
{
}

bool AVWidget::isChangeCrit() const
{
    bool res = false;
    // If alloc is changed and the new alloc overlays the previous one ?
    auto self = const_cast<AVWidget*>(this);
    res = !self->isOverlayed();
    return res;
}

bool AVWidget::isChanged() const
{
    return mChanged;
}

void AVWidget::handleRectInval(int aBlx, int aBly, int aTrx, int aTry, float aDepth)
{
    Log(TLog(EInfo, this) + "hrecinv: " + to_string(aBlx) + ", " + to_string(aBly) + ", " + to_string(aTrx) + ", " + to_string(aTry));
    int wlx, wwty, wrx, wwby;
    getAlcWndCoord(wlx, wwty, wrx, wwby);
    TInvlRec invr(aBlx, aBly, aTrx, aTry);
    TInvlRec selfr(wlx, wwby, wrx, wwty);
    if (invr.intersects(selfr) || selfr.intersects(invr)) {
	Render(true);
    }
}

#if 0
// TrWBase

TrWBase::TrWBase(const string& aType, const string& aName, MEnv* aEnv): TrBase(aType, aName, aEnv) { }

MIface* TrWBase::MNode_getLif(const char *aType)
{
    MIface* res = nullptr;
    if (res = checkLif<MDVarGet>(aType));
    else res = TrBase::MNode_getLif(aType);
    return res;
}

MIface* TrWBase::DoGetDObj(const char *aName)
{
    return checkLif<MDtGet<Tdata>>(aType);
}

string TrMut::VarGetIfid() const
{
    return MDtGet<Tdata>::Type();
}


// Transition "Widget Font"

TrWFont::TrWFont(AVWidget* aHost, const string& aType, const string& aName, MEnv* aEnv): TrWBase(aHost, aType, aName, aEnv)
{
    AddInput(GetInpUri(EInpParent));
    AddInput(GetInpUri(EInpName));
}

string TrMutNode::GetInpUri(int aId) const
{
    if (aId == EInpParent) return "Parent";
    else if (aId == EInpName) return "Name";
    else return string();
}

void TrMutNode::DtGet(DMut& aData)
{
    bool res = false;
    string name;
    res = GetInpSdata(EInpName, name);
    if (res) {
	string parent;
	res = GetInpSdata(EInpParent, parent);
	if (res) {
	    aData.mData = TMut(ENt_Node, ENa_Parent, parent, ENa_Id, name);
	    aData.mValid = true;
	} else {
	    aData.mValid = false;
	}
    } else {
	aData.mValid = false;
    }
    mRes = aData;
}

#endif

