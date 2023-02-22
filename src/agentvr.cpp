
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

AEdgeCrp::AEdgeCrp(const string& aType, const string& aName, MEnv* aEnv): AVWidget(aType, aName, aEnv)
{ }

void AEdgeCrp::Render()
{
    if (!mIsInitialised) return;

    pair<int, int> pcp = GetVertCp(true);
    pair<int, int> qcp = GetVertCp(false);
    //Log(TLog(EDbg, this) + "P_Cp: " + to_string(pcp.first) + "-" + to_string(pcp.second) + ", Q_Cp: " + to_string(qcp.first) + "-" + to_string(qcp.second));

    int pDwX, pDwY;
    GetDirectWndCoord(pcp.first, pcp.second, pDwX, pDwY);
    int qDwX, qDwY;
    GetDirectWndCoord(qcp.first, qcp.second, qDwX, qDwY);

    GLint viewport[4];
    glGetIntegerv( GL_VIEWPORT, viewport );
    int vp_width = viewport[2], vp_height = viewport[3];
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0, (GLdouble)vp_width, 0, (GLdouble)vp_height, -1.0, 1.0);

    glColor3f(mFgColor.r, mFgColor.g, mFgColor.b);
    DrawLine(pDwX, pDwY, qDwX, qDwY);

    CheckGlErrors();
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

void AEdgeCrp::GetOwnerPtWndCoord(int aInpX, int aInpY, int& aOutX, int& aOutY)
{
    MSceneElem* owner = GetOwner();
    if (owner) {
	owner->getWndCoord(aInpX, aInpY, aOutX, aOutY);
    }
}

void AEdgeCrp::GetDirectWndCoord(int aInpX, int aInpY, int& aOutX, int& aOutY)
{
    int x,y;
    GetOwnerPtWndCoord(aInpX, aInpY, x, y);
    int wndWidth = 0, wndHeight = 0;
    Wnd()->GetFbSize(&wndWidth, &wndHeight);
    aOutX = x;
    aOutY = wndHeight - y;
}
