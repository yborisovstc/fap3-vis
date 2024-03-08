
#include <iostream> 
#include <FTGL/ftgl.h>

#include "agentvr.h"
#include "mwindow.h"
#include "mlink.h"
#include "des.h"



// Agents Visual representation view manager

static const string K_UriNodeSelected = "NodeSelected";

AVrpView::AVrpView(const string& aType, const string& aName, MEnv* aEnv): Unit(aType, aName, aEnv), mAgtCp(this)
{
}

MIface* AVrpView::MNode_getLif(const char *aType)
{
    MIface* res = NULL;
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

MNode* AVrpView::ahostNode()
{
    MAhost* ahost = mAgtCp.firstPair()->provided();
    MNode* hostn = ahost ? ahost->lIf(hostn) : nullptr;
    return hostn;
}


void AVrpView::onOwnerAttached()
{
    bool res = false;
    // Registering in agent host
    MActr* ac = Owner()->lIf(ac);
    res = ac->attachAgent(&mAgtCp);
    if (!res) {
	Logger()->Write(EErr, this, "Cannot attach to host");
    }
}



// Edge CRP

const string K_PLeftCpUri = "VertPApAlc";
const string K_QRightCpUri = "VertQApAlc";
const string K_StartSeg = "LeftVertAlcCp";
const string K_RightBridge = "RightVertAlcCp";
const string K_DrpAdpUri = "DrpAdp";
const string K_SegCountUri = "DrpAdp.EdgeColRank";

AEdgeCrp::AEdgeCrp(const string& aType, const string& aName, MEnv* aEnv): AVWidget(aType, aName, aEnv)
{ }

void AEdgeCrp::Render()
{
    if (!mIsInitialised) return;

    GLint viewport[4];
    glGetIntegerv( GL_VIEWPORT, viewport );
    int vp_width = viewport[2], vp_height = viewport[3];
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0, (GLdouble)vp_width, 0, (GLdouble)vp_height, -1.0, 1.0);

    glColor3f(mFgColor.r, mFgColor.g, mFgColor.b);

    // Draw Edge CRP default segments slots
    DrawSegment("LtSlot");
    DrawSegment("RtSlot");
    DrawSegment("VsSlot");
    // Traversing with Edge CRP regular segments slots
    int i = 0;
    bool res = false;
    do {
	string sname = "Rs_" + to_string(i++ + 1);
	// Vertical sub-segment
	res = DrawSegment(sname + ".Vs");
	// Horizontal sub-segment
	res &= DrawSegment(sname + ".Hs");
    } while (res);
    CheckGlErrors();
}

bool AEdgeCrp::DrawSegment(const string& aSegName)
{
    bool res = false;
    int lX, lY, rX, rY;
    int lwX, lwY, rwX, rwY;
    bool valid = true;
    auto* drpAdpn = ahostNode()->getNode(K_DrpAdpUri);
    MDesAdapter* drpAdp = drpAdpn ? drpAdpn->lIf(drpAdp) : nullptr;
    auto* drp = drpAdp ? drpAdp->getMag() : nullptr;
    if (drp) {
	string segName = ahostNode()->name() + "_" + aSegName;
	auto* wcp = drp->getNode(segName + ".Coords");
	if (wcp) {
	    valid &= GetSegCoord(wcp, "LeftX", lX);
	    valid &= GetSegCoord(wcp, "LeftY", lY);
	    valid &= GetSegCoord(wcp, "RightX", rX);
	    valid &= GetSegCoord(wcp, "RightY", rY);
	    LOGN(EDbg, "Seg [" + aSegName + "]:" + to_string(lX) + ", "  + to_string(lY) + ", " + to_string(rX) + ", " + to_string(rY));
	    if (valid) {
		GetDirectWndCoord(lX, lY, lwX, lwY);
		GetDirectWndCoord(rX, rY, rwX, rwY);
		DrawLine(lwX, lwY, rwX, rwY);
		res = true;
	    }
	}
    }
    return res;
}

const DtBase* AEdgeCrp::GetStOutpData(const GUri& aCpUri, const string& aTypeSig)
{
    const DtBase* res = nullptr;
    auto* cpn = ahostNode()->getNode(aCpUri);
    if (cpn) {
	MUnit* cpu = cpn->lIf(cpu);
	MDVarGet* cpg = cpu ? cpu->getSif(cpg) : nullptr;
	res = cpg ? cpg->VDtGet(aTypeSig) : nullptr;
    }
    return res;
}


bool AEdgeCrp::GetSegCoord(MNode* aWdgCp, const GUri& aCpUri, int& aData)
{
    bool res = false;
    aData = -1;
    auto* ccp = aWdgCp->getNode(aCpUri);
    if (ccp) {
	MUnit* ccpu = ccp->lIf(ccpu);
	MDVarGet* ccpg = ccpu->getSif(ccpg);
	if (ccpg) {
	    const Sdata<int>* data = reinterpret_cast<const Sdata<int>*>(ccpg->VDtGet(data->TypeSig()));
	    if (data) {
		res = data->IsValid();
		if (res) {
		    aData = data->mData;
		}
	    }
	}
    }
    return res;
}

void AEdgeCrp::updateRqsW()
{
    mOstRqsW.updateData(20);
    mOstRqsH.updateData(20);
}

pair<int, int> AEdgeCrp::GetVertCp(bool aP)
{
    pair<int, int> res(-1, -1);
    MDVarGet* pvg = GetDataVg(aP ? K_PLeftCpUri : K_QRightCpUri);
    if (pvg) {
	const Pair<Sdata<int>>* dpi = pvg->DtGet(dpi);
	if (dpi) {
	    res.first = dpi->mData.first.mData;
	    res.second = dpi->mData.second.mData;
	}
    }
    return res;
}

void AEdgeCrp::GetDirectWndCoord(int aInpX, int aInpY, int& aOutX, int& aOutY)
{
    int x,y;
    getWndCoord(aInpX, aInpY, x, y);
    int wndWidth = 0, wndHeight = 0;
    Wnd()->GetFbSize(&wndWidth, &wndHeight);
    aOutX = x;
    aOutY = wndHeight - y;
}
