
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
    if (res = checkLif<MDesSyncable>(aType));
    else if (res = checkLif<MUnit>(aType)); // To allow client to request IFR
    return res;
}

void ACnt::resolveIfc(const string& aName, MIfReq::TIfReqCp* aReq)
{
    if (aName == MWindow::Type()) {
	MUnit* owu = ahostNode()->owned()->firstPair()->provided()->lIf(owu);
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
	auto hostnoCp = hostn->owned()->pcount() > 0 ? hostn->owned()->pairAt(0) : nullptr;
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
    if (res = checkLif<MSceneElemOwner>(aType));
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

    AVWidget::Render();

    MNode* host = ahostNode();
    auto compCp = host->owner()->firstPair();
    while (compCp) {
	auto compo = compCp->provided();
	MUnit* compu = compo ? compo->lIf(compu) : nullptr;
	MSceneElem* mse = compu ? compu->getSif(mse) : nullptr;
	if (mse && mse != this) {
	    //mse->Render();
	    try {
		mse->Render();
	    } catch (std::exception e) {
		LOGN(EErr, "Error on render [" + mse->Uid() + "]");
	    }
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

/*
void AVDContainer::getWndCoordSeo(int aInpX, int aInpY, int& aOutX, int& aOutY)
{
    // Get access to owners owner via MAhost iface
    MAhost* ahost = mAgtCp.firstPair()->provided();
    MNode* ahn = ahost->lIf(ahn);
    auto ahnoCp = ahn->owned()->pcount() > 0 ? ahn->owned()->pairAt(0) : nullptr;
    MOwner* ahno = ahnoCp ? ahnoCp->provided() : nullptr;
    MUnit* ahnou = ahno->lIf(ahnou);
    MSceneElemOwner* owner = ahnou->getSif(owner);
    if (owner) {
	int x = GetParInt(KUri_AlcX);
	int y = GetParInt(KUri_AlcY);
	owner->getWndCoordSeo(x + aInpX, y + aInpY, aOutX, aOutY);
    } else {
	aOutX = aInpX;
	aOutY = aInpY;
    }
}
*/

void AVDContainer::getCoordOwrSeo(int& aOutX, int& aOutY, int aLevel)
{
    // Get access to owners owner via MAhost iface
    MAhost* ahost = mAgtCp.firstPair()->provided();
    MNode* ahn = ahost->lIf(ahn);
    auto ahnoCp = ahn->owned()->pcount() > 0 ? ahn->owned()->pairAt(0) : nullptr;
    MOwner* ahno = ahnoCp ? ahnoCp->provided() : nullptr;
    MUnit* ahnou = ahno->lIf(ahnou);
    MSceneElemOwner* owner = ahnou->getSif(owner);
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
