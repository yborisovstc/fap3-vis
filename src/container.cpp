
#include "mwindow.h"

#include "container.h"

////// ACnt
//
ACnt::ACnt(const string &aType, const string& aName, MEnv* aEnv): AgtBase(aType, aName, aEnv)
{
}

ACnt::~ACnt()
{
}

MIface* ACnt::MAgent_getLif(const char *aType)
{
    MIface* res = nullptr;
    if (res = checkLif2(aType, mMUnitPtr)); // To allow client to request IFR
    return res;
}

void ACnt::resolveIfc(const string& aName, MIfReq::TIfReqCp* aReq)
{
    if (aName == MWindow::Type()) {
	MUnit* owu = (*ahostNode()->owned()->pairsBegin())->provided()->lIf(owu);
	MWindow* ifr = owu->getSif(ifr);
	if (ifr && !aReq->binded()->provided()->findIface(ifr)) {
	    addIfpLeaf(ifr, aReq);
	}
    } else if (aName == MSceneElem::Type()) {
	auto* hostn = ahostNode();
	MUnit* hostu = hostn ? hostn->lIf(hostu) : nullptr;
	if (hostu) {
	    MDesAdapter* adp = hostu->getSif(adp);
	    if (adp) {
		auto* mgd = adp->getMag();
		if (mgd) {
		    // Request from owner, redirect to managed subs
		    MUnit* mgdu = mgd->lIf(mgdu);
		    if (mgdu) {
			mgdu->resolveIface(aName, aReq);
		    }
		}
	    }
	}
    } else if (aName == MSceneElemOwner::Type()) {
	// Request from managed subs, redirect upward
	auto* hostn = ahostNode();
	auto* ho = hostn->owned();
	auto pb = ho->pairsBegin();
	auto* hostnoCp = (pb != ho->pairsEnd()) ? *pb : nullptr;
	MOwner* hostno = hostnoCp ? hostnoCp->provided() : nullptr;
	MUnit* hostnou = hostno->lIf(hostnou);
	hostnou->resolveIface(aName, aReq);
    } else {
	Unit::resolveIfc(aName, aReq);
    }
}



//// AVDContainer

AVDContainer::AVDContainer(const string& aType, const string& aName, MEnv* aEnv): AVWidget(aType, aName, aEnv)
{
}

AVDContainer::~AVDContainer()
{
}

MIface* AVDContainer::MNode_getLif(const char *aType)
{
    MIface* res = nullptr;
    if (res = checkLif2(aType, mMSceneElemOwnerPtr));
    else if (res = AVWidget::MNode_getLif(aType));
    return res;
}

void AVDContainer::resolveIfc(const string& aName, MIfReq::TIfReqCp* aReq)
{
    AVWidget::resolveIfc(aName, aReq);
}

void AVDContainer::Render()
{
    //Log(TLog(EDbg, this) + "Render");

    if (mDrawOnComplete && isActive()) return;

    AVWidget::Render();

    MNode* host = ahostNode();
    // TODO All comps are tried. Tried to opt to have MSceneElem list
    auto* ho = host->owner();
    for (auto it = ho->pairsBegin(); it != ho->pairsEnd(); it++) {
	auto compo = (*it)->provided();
	MUnit* compu = compo ? compo->lIf(compu) : nullptr;
	MSceneElem* mse = compu ? compu->getSif(mse) : nullptr;
	if (mse && mse != this) {
	    try {
		mse->Render();
	    } catch (std::exception e) {
		LOGN(EErr, "Error on render [" + mse->Uid() + "]");
	    }
	}
    }
}

bool AVDContainer::onMouseButton(TFvButton aButton, TFvButtonAction aAction, int aMods)
{
    bool res = false;
    bool lres = AVWidget::onMouseButton(aButton, aAction, aMods);
    if (lres) {
	MNode* host = ahostNode();
	auto* ho = host->owner();
	for (auto it = ho->pairsBegin(); it != ho->pairsEnd(); it++) {
	    auto* compCp = *it;
	    if (compCp != owned()) {
		auto compo = compCp->provided();
		MUnit* compu = compo ? compo->lIf(compu) : nullptr;
		MSceneElem* mse = compu ? compu->getSif(mse) : nullptr;
		if (mse && mse != this) {
		    res = mse->onMouseButton(aButton, aAction, aMods);
		}
	    }
	}
    }
    return res;
}

void AVDContainer::getCoordOwrSeo(int& aOutX, int& aOutY, int aLevel)
{
    MSceneElemOwner* owner = GetScelOwner();
    if (owner && aLevel != 0) {
	int x = GetParInt(KUri_AlcX);
	int y = GetParInt(KUri_AlcY);
	owner->getCoordOwrSeo(aOutX, aOutY, aLevel - 1);
	aOutX += x;
	aOutY += y;
    } else {
	aOutX = 0;
	aOutY = 0;
    }
}
