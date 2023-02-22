
#include "container.h"


//// AVDContainer

AVDContainer::AVDContainer(const string& aType, const string& aName, MEnv* aEnv): AVWidget(aType, aName, aEnv)
{
}

AVDContainer::~AVDContainer()
{
}

void AVDContainer::resolveIfc(const string& aName, MIfReq::TIfReqCp* aReq)
{
    AVWidget::resolveIfc(aName, aReq);
}

void AVDContainer::Render()
{
    //Log(TLog(EDbg, this) + "Render");

    AVWidget::Render();

    MNode* host = ahostNode();
    auto compCp = host->owner()->firstPair();
    while (compCp) {
	auto compo = compCp->provided();
	MUnit* compu = compo ? compo->lIf(compu) : nullptr;
	MSceneElem* mse = compu ? compu->getSif(mse) : nullptr;
	if (mse && mse != this) {
	    mse->Render();
	}
	compCp = host->owner()->nextPair(compCp);
    }
}

bool AVDContainer::onMouseButton(TFvButton aButton, TFvButtonAction aAction, int aMods)
{
    bool res = false;
    bool lres = AVWidget::onMouseButton(aButton, aAction, aMods);
    if (lres) {
	MNode* host = ahostNode();
	auto compCp = host->owner()->firstPair();
	while (compCp) {
	    if (compCp != owned()) {
		auto compo = compCp->provided();
		MUnit* compu = compo ? compo->lIf(compu) : nullptr;
		MSceneElem* mse = compu ? compu->getSif(mse) : nullptr;
		if (mse && mse != this) {
		    res = mse->onMouseButton(aButton, aAction, aMods);
		}
	    }
	    compCp = host->owner()->nextPair(compCp);
	}
    }
    return res;
}



