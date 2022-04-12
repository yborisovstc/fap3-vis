

#include <iostream> 
#include <rdata.h>
#include <FTGL/ftgl.h>

#include "widget.h"
#include "mwindow.h"

#include "deps/linmath.h" // Ref https://github.com/glfw/glfw/tree/master/deps

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
    mFont(nullptr)
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
    Logger()->Write(EInfo, this, "Update");
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
    }
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


void AVWidget::Render()
{
    if (!mIsInitialised) return;

    // Debugging only, to remove
    float xc, yc, wc, hc;
    GetAlc(xc, yc, wc, hc);

    Log(TLog(EDbg, this) + "Render");
    // Get viewport parameters
    GLint viewport[4];
    glGetIntegerv( GL_VIEWPORT, viewport );
    int vp_width = viewport[2], vp_height = viewport[3];

    //glColor4f(mBgColor.r, mBgColor.g, mBgColor.b, mBgColor.a);
    //glEnable(GL_BLEND);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0, (GLdouble)vp_width, 0, (GLdouble)vp_height, -1.0, 1.0);

    // Window coordinates
    int wlx, wwty, wrx, wwby;
    getAlcWndCoord(wlx, wwty, wrx, wwby);

    // Background
    glColor4f(mBgColor.r, mBgColor.g, mBgColor.b, mBgColor.a);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glBegin(GL_POLYGON);
    glVertex2f(wlx, wwty);
    glVertex2f(wrx, wwty);
    glVertex2f(wrx, wwby);
    glVertex2f(wlx, wwby);
    glEnd();
    
    // Border
    bool vpBorder;
    bool res = getVisPar(KVp_Border, vpBorder);
    if (res && vpBorder) {
	glColor3f(mFgColor.r, mFgColor.g, mFgColor.b);
	DrawLine(wlx, wwty, wlx, wwby);
	DrawLine(wlx, wwby, wrx, wwby);
	DrawLine(wrx, wwby, wrx, wwty);
	DrawLine(wrx, wwty, wlx, wwty);
    }

    CheckGlErrors();
}

void AVWidget::Init()
{
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

void AVWidget::DrawLine(float x1, float y1, float x2, float y2)
{
    glBegin(GL_LINES);
    glVertex2f(x1, y1);
    glVertex2f(x2, y2);
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

void AVWidget::GetAlc(float& aX, float& aY, float& aW, float& aH)
{
    aX = (float) GetParInt(KUri_AlcX);
    aY = (float) GetParInt(KUri_AlcY);
    aW = (float) GetParInt(KUri_AlcW);
    aH = (float) GetParInt(KUri_AlcH);
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

