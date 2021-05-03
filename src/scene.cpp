

#include <GL/glew.h>
#include <GL/gl.h>
#include <GLFW/glfw3.h>

#include "scene.h"
#include "mscel.h"
#include "mwindow.h"
//#include "mcontainer.h"

const string KWndCnt_Init = "Init";
const string KWndCnt_Init_Val = "Yes";

GtScene::GtScene(const string& aName, MEnv* aEnv): Des(aName, aEnv), mWndInit(false)
{
    if (aName.empty()) mName = Type();
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
    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT);

    for (int ind = 0; ind < owner()->pcount(); ind++) {
	auto compCp = owner()->pairAt(ind);
	MOwned* comp = compCp ? compCp->provided() : nullptr;
	MUnit* compu = comp->lIf(compu);
	MSceneElem* mse = compu ? compu->getSif(mse) : nullptr;
	if (mse) {
	    mse->Render();
	}
    }
    glFlush();
}

void GtScene::update()
{
    Logger()->Write(EInfo, this, "Update");
    Des::update();
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
	MSceneElem* mse = compu->getSif(mse);
	if (mse) {
	    mse->onMouseButton(aButton, aAction, aMods);
	}
    }
}

bool GtScene::resolveIfc(const string& aName, MIfReq::TIfReqCp* aReq)
{
    bool res = true;
    if (aName == MWindow::Type()) {
	MUnit* owu = Owner()->lIf(owu);
	MWindow* ifr = owu->getSif(ifr);
	if (ifr && !aReq->binded()->provided()->findIface(ifr)) {
	    addIfpLeaf(ifr, aReq);
	    res = true;
	}
    } else {
	Des::resolveIfc(aName, aReq);
    }
    return res;
}


