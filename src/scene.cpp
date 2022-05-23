

#include <GL/glew.h>
#include <GL/gl.h>
#include <GLFW/glfw3.h>

#include "scene.h"
#include "mscel.h"
#include "mwindow.h"
#include "mcontainer.h"

const string KWndCnt_Init = "Init";
const string KWndCnt_Init_Val = "Yes";

GtScene::GtScene(const string& aType, const string& aName, MEnv* aEnv): Des(aType, aName, aEnv), mWndInit(false)
{
}

void GtScene::Construct()
{
}

MIface* GtScene::MNode_getLif(const char *aType)
{
    MIface* res = nullptr;
    if (res = checkLif<MScene>(aType));
    else res = Des::MNode_getLif(aType);
    return res;
}

void GtScene::RenderScene(void)
{
    // Depth 0.75 correspond view coord z=-0.5 because projection z_near=-1.0, z_far=1.0
    // but viewport transformation z range = 0..1.0
    // So on projection transformation z -0.5 goes to zp=0.5 (z scale is -1.0, ref glOrtho)
    // -0.5 depth is transformed as (zp - z_near)/(z_far - z_near) = (0.5+1)/1.0 + 1.0) = 0.75
    glClearDepth(0.76);
    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    /*
    for (int ind = 0; ind < owner()->pcount(); ind++) {
	auto compCp = owner()->pairAt(ind);
	MOwned* comp = compCp ? compCp->provided() : nullptr;
	MUnit* compu = comp->lIf(compu);
	MSceneElem* mse = compu ? compu->getSif(mse) : nullptr;
	if (mse) {
	    mse->Render();
	}
    }
    */

    glFlush();
}

void GtScene::update()
{
    //Logger()->Write(EInfo, this, "Update");
    Des::update();
}

void GtScene::confirm()
{
    //Logger()->Write(EInfo, this, "Confirm");
    //RenderScene();

    auto changed = mUpdated;

#ifdef _SIU_RDC_
    // Clean previous rendering parts first
    for (auto comp : mUpdated) {
	MSceneElem* compse = comp->lIf(compse);
	if (compse) {
	    compse->cleanSelem();
	}
    }
    glFlush();
#endif // _SIU_RDC_

    Des::confirm();

#ifdef _SDR_
    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    // Render current state 
    for (auto comp : changed) {
	MSceneElem* compse = comp->lIf(compse);
	if (compse) {
	    compse->Render();
	}
    }
#endif // _SDR_

#ifdef _SIU_UCI_
    // Render current state 
    for (auto comp : changed) {
	MSceneElem* compse = comp->lIf(compse);
	if (compse && compse->isChanged()) {
	    compse->Render();
	}
    }
#endif // _SIU_UCI_

}


void GtScene::onCursorPosition(double aX, double aY)
{
    for (int ind = 0; ind < owner()->pcount(); ind++) {
	auto compCp = owner()->pairAt(ind);
	MOwned* comp = compCp ? compCp->provided() : nullptr;
	MUnit* compu = comp->lIf(compu);
	MSceneElem* mse = compu ? compu->getSif(mse) : nullptr;
	if (mse) {
	    mse->onSeCursorPosition(aX, aY);
	}
    }
}

void GtScene::onMouseButton(TFvButton aButton, TFvButtonAction aAction, int aMods)
{
    for (int ind = 0; ind < owner()->pcount(); ind++) {
	auto compCp = owner()->pairAt(ind);
	MOwned* comp = compCp ? compCp->provided() : nullptr;
	MUnit* compu = comp->lIf(compu);
	MSceneElem* mse = compu ? compu->getSif(mse) : nullptr;
	if (mse) {
	    mse->onMouseButton(aButton, aAction, aMods);
	}
    }
}

void GtScene::resolveIfc(const string& aName, MIfReq::TIfReqCp* aReq)
{
    if (aName == MWindow::Type()) {
	MUnit* owu = Owner()->lIf(owu);
	MWindow* ifr = owu->getSif(ifr);
	if (ifr && !aReq->binded()->provided()->findIface(ifr)) {
	    addIfpLeaf(ifr, aReq);
	}
    } else if (aName == MViewMgr::Type()) {
	MUnit* owu = Owner()->lIf(owu);
	owu->resolveIface(aName, aReq);
    } else {
	Des::resolveIfc(aName, aReq);
    }
}


