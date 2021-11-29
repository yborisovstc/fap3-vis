
#include <iostream> 
#include <FTGL/ftgl.h>

#include "agentvr.h"
#include "mvrcontroller.h"
#include "mwindow.h"


const string KCont_Text = "Text";

AAgentVr::AAgentVr(const string& aType, const string& aName, MEnv* aEnv): AVWidget(aType, aName, aEnv)
{
}

AAgentVr::~AAgentVr()
{
}

void AAgentVr::Render()
{
    assert(mIsInitialised);

    float xc = (float) GetParInt("AlcX");
    float yc = (float) GetParInt("AlcY");
    float wc = (float) GetParInt("AlcW");
    float hc = (float) GetParInt("AlcH");

    Logger()->Write(EInfo, this, "Render");
    // Get viewport parameters
    GLint viewport[4];
    glGetIntegerv( GL_VIEWPORT, viewport );
    int vp_width = viewport[2], vp_height = viewport[3];

    glColor3f(mBgColor.r, mBgColor.g, mBgColor.b);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0, (GLdouble)vp_width, 0, (GLdouble)vp_height, -1.0, 1.0);
    glBegin(GL_LINES);
    glVertex2f(xc, yc);
    glVertex2f(xc, yc + hc);
    glVertex2f(xc + wc, yc + hc);
    glVertex2f(xc + wc, yc);
    glEnd();

    glFlush();
    CheckGlErrors();
}

void AAgentVr::DrawLine(float x1, float y1, float x2, float y2)
{
    glBegin(GL_LINES);
    glVertex2f(x1, y1);
    glVertex2f(x2, y2);
    glEnd();
}


const string KTitle = "Hello World!";
const string KStateContVal = "Value";


ANodeCrp::ANodeCrp(const string& aType, const string& aName, MEnv* aEnv): AAgentVr(aType, aName, aEnv), mFont(NULL),
    mBEnv(nullptr), mMdl(nullptr)
{
}

ANodeCrp::~ANodeCrp()
{
    if (mFont) {
	delete mFont;
    }
}

MIface* ANodeCrp::MNode_getLif(const char *aType)
{
    MIface* res = NULL;
    if (res = checkLif<MVrp>(aType));
    else res = AAgentVr::MNode_getLif(aType);
    return res;
}


void ANodeCrp::Render()
{
    assert(mIsInitialised);

    float xc = (float) GetParInt("AlcX");
    float yc = (float) GetParInt("AlcY");
    float wc = (float) GetParInt("AlcW");
    float hc = (float) GetParInt("AlcH");

    Logger()->Write(EInfo, this, "Render");
    // Get viewport parameters
    GLint viewport[4];
    glGetIntegerv( GL_VIEWPORT, viewport );
    int vp_width = viewport[2], vp_height = viewport[3];

    glColor3f(mBgColor.r, mBgColor.g, mBgColor.b);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0, (GLdouble)vp_width, 0, (GLdouble)vp_height, -1.0, 1.0);
    glLineWidth(K_LineWidth);

    // Window coordinates
    int wlx = 0, wty = 0, wrx = 0, wby = 0;
    getWndCoord(0, 0, wlx, wty);
    getWndCoord(wc, hc, wrx, wby);
    int wndWidth = 0, wndHeight = 0;
    Wnd()->GetFbSize(&wndWidth, &wndHeight);
    int wwty = wndHeight - wty;
    int wwby = wwty - hc;

    // Background
    glColor3f(mBgColor.r, mBgColor.g, mBgColor.b);
    glBegin(GL_POLYGON);
    glVertex2f(wlx, wwty);
    glVertex2f(wlx, wwby);
    glVertex2f(wrx, wwty);
    glVertex2f(wrx, wwby);
    glEnd();

    // Draw border
    glColor3f(mFgColor.r, mFgColor.g, mFgColor.b);
    DrawLine(wlx, wwty, wlx, wwby);
    DrawLine(wlx, wwby, wrx, wwby);
    DrawLine(wrx, wwby, wrx, wwty);
    DrawLine(wrx, wwty, wlx, wwty);
    // Draw name divider
    int nameDivH = K_BFontSize + 2 * K_BPadding;
    int wys = wwty - nameDivH;
    DrawLine(wlx, wys, wrx, wys);
    // Draw the name
    const string& titleText = (mMdl != nullptr) ? mMdl->name() : KTitle;
    glRasterPos2f(wlx + K_BPadding, wys + K_BPadding);
    mFont->Render(titleText.c_str());

    CheckGlErrors();
}

void ANodeCrp::Init()
{
    AAgentVr::Init();

    MContentOwner* hostcnto = ahostNode()->lIf(hostcnto);
    string fontPath;
    hostcnto->getContent(KCnt_FontPath, fontPath);
    mFont = new FTPixmapFont(fontPath.c_str());
    mFont->FaceSize(K_BFontSize);
    const string& titleText = (mMdl != nullptr) ? mMdl->name() : KTitle;
    int adv = (int) mFont->Advance(titleText.c_str());
    int tfh = (int) mFont->LineHeight();
    MNode* host = ahostNode();
    MNode* rw = host->getNode("RqsW");
    MNode* rh = host->getNode("RqsH");
    // Requisition
    MContentOwner* rwco = rw->lIf(rwco);
    string data = "SI " + to_string(adv + 2 * K_BPadding);
    rwco->setContent("", data);
    MContentOwner* rhco = rh->lIf(rhco);
    int minRh = K_MinBodyHeight + tfh + 2 * K_BPadding;
    data = "SI " + to_string(minRh);
    rhco->setContent("", data);
}

void ANodeCrp::SetEnv(MEnv* aEnv)
{
    assert(mEnv == nullptr && aEnv != nullptr);
    mEnv = aEnv;
}

void ANodeCrp::SetModel(const string& aMdlUri)
{
    assert(mMdl == nullptr);
    MNode* mdl = mEnv->Root()->getNode(aMdlUri);
    assert(mdl != nullptr);
    mMdl = mdl;
}

MViewMgr* ANodeCrp::getViewMgr()
{
    MNode* ahn = ahostNode();
    MOwner* ahno = ahn->owned()->pairAt(0) ? ahn->owned()->pairAt(0)->provided() : nullptr;
    MUnit* ahnou = ahno ? ahno->lIf(ahnou) : nullptr;
    MViewMgr* obs = ahnou ? ahnou->getSif(obs) : nullptr;
    return obs;
}


bool ANodeCrp::onMouseButton(TFvButton aButton, TFvButtonAction aAction, int aMods)
{
    bool res = false;
    if (aButton == EFvBtnLeft && aAction == EFvBtnActPress) {
	double x = 0, y = 0;
	GetCursorPosition(x, y);
	if (IsInnerWidgetPos(x, y)) {
	    MViewMgr* view = getViewMgr();
	    if (view) {
		MVrpView* vrpView = view->lIf(vrpView);
		if (vrpView) {
		    vrpView->OnCompSelected(this);
		    res = true;
		}
	    }
	}
    }
    return res;
}

string ANodeCrp::GetModelUri() const
{
    assert(mMdl);
    return mMdl->getUriS(nullptr);
}
	

// Node DRP

const string K_CpInpModelUri = "InpModelUri";
const string K_CpOutModelUri = "OutModelUri";

ANodeDrp::ANodeDrp(const string& aType, const string& aName, MEnv* aEnv): AHLayout(aType, aName, aEnv),
    mBEnv(nullptr), mMdl(nullptr)
{
}

MIface* ANodeDrp::MNode_getLif(const char *aType)
{
    MIface* res = NULL;
    if (res = checkLif<MVrp>(aType));
    else res = AHLayout::MNode_getLif(aType);
    return res;
}

void ANodeDrp::Render()
{
    AHLayout::Render();
}

void ANodeDrp::SetEnv(MEnv* aEnv)
{
    assert(mEnv == nullptr && aEnv != nullptr);
    mEnv = aEnv;
}

void ANodeDrp::SetModel(const string& aMdlUri)
{
    assert(mMdl == nullptr);
    MNode* mdl = mEnv->Root()->getNode(aMdlUri);
    assert(mdl != nullptr);
    mMdl = mdl;
    CreateRp();
}

void ANodeDrp::CreateRp()
{
    // Remove current slots first
    RmAllSlots();
    // Create new slots
    MNode* host = ahostNode();
    auto* compCp = mMdl->owner()->firstPair();
    while (compCp) {
	MOwned* comp = compCp->provided();
	MNode* compn = comp->lIf(compn);
	string compUri = compn->getUriS(nullptr);
	InsertWidget(compn->name(), "FvWidgets.FNodeCrp", KPosEnd);
	MNode* vcompn = host->getNode(compn->name());
	assert(vcompn != nullptr);
	MUnit* vcompu = vcompn->lIf(vcompu);
	MVrp* vcompr = vcompu ? vcompu->getSif(vcompr) : nullptr;
	assert(vcompr != nullptr);
	//vcompr->SetEnv(mEnv);
	vcompr->SetModel(compUri);
	compCp = mMdl->owner()->nextPair(compCp);
    }
}

void ANodeDrp::DestroyRp()
{
}

void ANodeDrp::SetCrtlBinding(const string& aCtrUri)
{
    assert(mCtrBnd.empty());
    MNode* ctru = getNode(aCtrUri);
    if (ctru) {
	mCtrBnd = aCtrUri;
    } else {
	Logger()->Write(EErr, this, "Wrong controller binding info [%s]", aCtrUri.c_str());
    }
}


bool ANodeDrp::resolveIfc(const string& aName, MIfReq::TIfReqCp* aReq)
{
    bool res = true;
    if (aName == MVrController::Type()) {
	// TBI
    } else if (aName == MDesInpObserver::Type()) {
	MNode* mdn = ahostNode()->getNode(K_CpInpModelUri);
	MIfProvOwner* mdpo = mdn ? mdn->lIf(mdpo) : nullptr;
	if (mdpo && aReq->provided()->isRequestor(mdpo)) {
	    MIface* iface = dynamic_cast<MDesInpObserver*>(&mIapModelUri);
	    addIfpLeaf(iface, aReq);
	}
    } else if (aName == MDVarGet::Type()) {
	MNode* mdn = ahostNode()->getNode(K_CpOutModelUri);
	MIfProvOwner* mdpo = mdn ? mdn->lIf(mdpo) : nullptr;
	if (mdpo && aReq->provided()->isRequestor(mdpo)) {
	    MIface* iface = dynamic_cast<MDVarGet*>(&mPapModelUri);
	    addIfpLeaf(iface, aReq);
	}
    } else {
	AHLayout::resolveIfc(aName, aReq);
    }
    return res;

}

void ANodeDrp::GetModelUri(Sdata<string>& aData)
{
    aData.mData = GetModelUri();
    aData.mValid = true;
}

string ANodeDrp::GetModelUri() const
{
    return mMdl ? mMdl->getUriS(nullptr) : GUri::nil;
}

void ANodeDrp::OnInpModelUri()
{
    mModelUriChanged = true;
    onActivated(nullptr);
}

void ANodeDrp::ApplyModelUri()
{
    MNode* inp = ahostNode()->getNode(K_CpInpModelUri);
    if (inp) {
	string uris;
	bool res = GetSData(inp, uris);
	if (res) {
	    if (uris != mModelUri && uris != GUri::nil) {
		MNode* mdl = ahostNode()->getNode(uris);
		if (mdl) {
		    mMdl = mdl;
		    CreateRp();
		    NotifyOnMdlUpdated();
		    Logger()->Write(EDbg, this, "Model applied [%s]", uris.c_str());
		} else {
		    Logger()->Write(EErr, this, "Couldn't find the model [%s]", uris.c_str());
		}
		mModelUri = uris;
	    }
	}
    }
}

void ANodeDrp::NotifyOnMdlUpdated()
{
    MNode* outMdlUri = ahostNode()->getNode(K_CpOutModelUri);
    if (outMdlUri) {
	MUnit* outMdlUriu = outMdlUri->lIf(outMdlUriu);
	MIfProv* ifp = outMdlUriu ? outMdlUriu->defaultIfProv(MDesInpObserver::Type()) : nullptr;
	MIfProv::TIfaces* ifcs = ifp ? ifp->ifaces() : nullptr;
	for (auto ifc : *ifcs) {
	    MDesInpObserver* mobs = dynamic_cast<MDesInpObserver*>(ifc);
	    mobs->onInpUpdated();
	}
    }
}

void ANodeDrp::update()
{
    if (mModelUriChanged) {
	ApplyModelUri();
	mModelUriChanged = false;
    }
    AHLayout::update();
}

void ANodeDrp::confirm()
{
    AHLayout::confirm();
}


// Agents Visual representation view manager

AVrpView::AVrpView(const string& aType, const string& aName, MEnv* aEnv): Unit(aType, aName, aEnv)
{
}

MIface* AVrpView::MNode_getLif(const char *aType)
{
    MIface* res = NULL;
    if (res = checkLif<MVrpView>(aType));
    if (res = checkLif<MViewMgr>(aType));
    if (res = checkLif<MAgent>(aType));
    else res = Unit::MNode_getLif(aType);
    return res;
}

MIface* AVrpView::MAgent_getLif(const char *aType)
{
    MIface* res = NULL;
    if (res = checkLif<MUnit>(aType));
    return res;
}

void AVrpView::OnCompSelected(const MVrp* aComp)
{
    string selUri = aComp->GetModelUri();
    /*
    MElem* eowner = iMan->GetObj(eowner);
    string newVal = "SS " + selUri;
    eowner->AppendMutation(TMut(ENt_Cont, ENa_Targ, "./NodeSelected", ENa_Id, "Value", ENa_MutVal, newVal));
    TNs ns; MutCtx mctx(NULL, ns);
    eowner->Mutate(true, false, false, mctx);
    Logger()->Write(EInfo, this, "NodeSelected, updated to [%s]", newVal.c_str());
    */
}
