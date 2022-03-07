
#include "container.h"

const string KWidgetRqsW_Name = "OutRqsW";
const string KWidgetRqsH_Name = "OutRqsH";
const string KCont_Padding = "Padding";
const string KWidgetCpName = "Cp";
const string KSlotCpName = "SCp";
const string KSlot_Name = "Slot";

const string K_CpUriInpAddWidget = "InpMutAddWidget";
const string K_CpUriInpRmWidget = "InpMutRmWidget";
const string K_CpUriCompNames = "OutCompNames";
const string K_CpUriCompCount = "OutCompsCount";

const MContainer::TPos AVContainer::KPosFirst = TPos(0, 0);
const MContainer::TPos AVContainer::KPosEnd = TPos(-1, -1);

AVContainer::AVContainer(const string& aType, const string& aName, MEnv* aEnv): AVWidget(aType, aName, aEnv), mMag(nullptr), mMutRmWidget(-1)
{
}

AVContainer::~AVContainer()
{
}

MIface* AVContainer::MNode_getLif(const char *aType)
{
    MIface* res = NULL;
    if (res = checkLif<MContainer>(aType));
    else res = AVWidget::MNode_getLif(aType);
    return res;
}

void AVContainer::resolveIfc(const string& aName, MIfReq::TIfReqCp* aReq)
{
    if (aName == MViewMgr::Type()) {
	MUnit* hownu = getHostOwnerUnit();
	if (hownu) {
	    hownu->resolveIface(aName, aReq);
	}
    } else if (aName == MDVarGet::Type()) {
	MNode* cmpCount = ahostGetNode(K_CpUriCompCount);
	if (isRequestor(aReq, cmpCount)) {
	    MIface* iface = dynamic_cast<MDVarGet*>(&mApCmpCount);
	    addIfpLeaf(iface, aReq);
	}
	MNode* cmpNames = ahostGetNode(K_CpUriCompNames);
	if (isRequestor(aReq, cmpNames)) {
	    MIface* iface = dynamic_cast<MDVarGet*>(&mApCmpNames);
	    addIfpLeaf(iface, aReq);
	}
    } else if (aName == MDesInpObserver::Type()) {
	MNode* mutAddWdt = ahostGetNode(K_CpUriInpAddWidget);
	if (isRequestor(aReq, mutAddWdt)) {
	    MIface* iface = dynamic_cast<MDesInpObserver*>(&mIapMutAddWdt);
	    addIfpLeaf(iface, aReq);
	}
	MNode* mutRmWdt = ahostGetNode(K_CpUriInpRmWidget);
	if (isRequestor(aReq, mutRmWdt)) {
	    MIface* iface = dynamic_cast<MDesInpObserver*>(&mIapMutRmWdt);
	    addIfpLeaf(iface, aReq);
	}
    } else {
	AVWidget::resolveIfc(aName, aReq);
    }
}

void AVContainer::onOwnerAttached()
{
    assert(!mMag);
    AVWidget::onOwnerAttached();
    MNode* magn = ahostNode();
    mMag = magn;
    MObservable* magob = mMag->lIf(magob);
    magob->addObserver(&mMagObs.mOcp);
}



void AVContainer::Render()
{
    Log(TLog(EDbg, this) + "Render");
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

MNode* AVContainer::AddWidget(const string& aName, const string& aType, const string& aHint)
{
    return InsertWidget(aName, aType, TPos(-1, -1));
}

bool AVContainer::RmWidget(int aSlotPos, const string& aHint)
{
    bool res = false;
    Logger()->Write(EInfo, this, "Start removing widget on slot [%d]", aSlotPos);
    MNode* host = ahostNode();
    MNode* slot = GetSlotByPos(TPos(aSlotPos,0));
    if (slot) {
	RmWidgetBySlot(slot);
    } else {
	Logger()->Write(EErr, this, "Cannot find slot [%d]", aSlotPos);
    }
    return res;
}

bool AVContainer::RmWidgetBySlot(MNode* aSlot)
{
    bool res = false;
    MNode* widget = GetWidgetBySlot(aSlot);
    if (widget) {
	// Remove widget
	string wname = widget->name();
	MNode* host = ahostNode();
	if (host) {
	    mutateNode(host, TMut(ENt_Rm, ENa_MutNode, wname));
	    Logger()->Write(EInfo, this, "Completed removing widget");
	    res = true;
	}
    } else {
	Log(TLog(EErr, this) + "Cannot find widget in slot [" + aSlot->name() + "]");
    }
    return res;
}

string AVContainer::GetSlotType()
{
    return string();
}

MNode* AVContainer::AppendSlot(MNode* aSlot)
{
    assert(false);
}

int AVContainer::GetLastSlotId()
{
    MNode* host = ahostNode();
    int lastSlotId = 0;
    auto compCp = host->owner()->firstPair();
    while (compCp) {
	auto compo = compCp->provided();
	MNode* comp = compo ? compo->lIf(comp) : nullptr;
	compCp = host->owner()->nextPair(compCp);
	MVCslot* comps = comp->lIf(comps);
	if (comps) {
	    int slotId = GetSlotId(comp->name());
	    lastSlotId = max(lastSlotId, slotId);
	}
    }
    return lastSlotId;
}

int AVContainer::GetSlotId(const string& aSlotName) const
{
    int res = -1;
    size_t sp = aSlotName.find_last_of('_');
    string id = aSlotName.substr(sp + 1);
    res = stoi(id);
    return res;
}

string AVContainer::GetSlotName(int aSlotId) const
{
    return KSlot_Name + "_" + to_string(aSlotId);
}

bool AVContainer::onMouseButton(TFvButton aButton, TFvButtonAction aAction, int aMods)
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
		if (mse) {
		    res = mse->onMouseButton(aButton, aAction, aMods);
		}
	    }
	    compCp = host->owner()->nextPair(compCp);
	}
    }
    return res;
}

MNode* AVContainer::InsertWidget(const string& aName, const string& aType, const TPos& aPos)
{
    MNode* host = ahostNode();
    // Add new slot
    string slotType = GetSlotType();
    assert(!slotType.empty());
    string slotName = GetSlotName(GetLastSlotId() + 1);
    mutateNode(host, TMut(ENt_Node, ENa_Id, slotName, ENa_Parent, slotType));
    MNode* newSlot = host->getNode(slotName);
    assert(newSlot);
    // Add new widget
    mutateNode(host, TMut(ENt_Node, ENa_Id, aName, ENa_Parent, aType));
    MNode* newWdg = host->getNode(aName);
    assert(newWdg);
    // Bind widget to slot
    string widgetCp = aName + "." + KWidgetCpName;
    string slotCp = newSlot->getUriS(this) + "." + KSlotCpName;
    mutateNode(host, TMut(ENt_Conn, ENa_P, widgetCp, ENa_Q, slotCp));
    // Append slot
    InsertSlot(newSlot, aPos);
    // Invalidate Iface cache
    invalidateIrm();
    return newWdg;
}

MContainer::TPos AVContainer::LastPos() const
{
    assert(false);
}

MNode* AVContainer::GetPrevSlotCp(MNode* aSlot)
{
    assert(false);
}

MNode* AVContainer::GetNextSlotCp(MNode* aSlot)
{
    assert(false);
}

MNode* AVContainer::GetNextSlot(MNode* aSlot)
{
    assert(false);
}

void AVContainer::RmSlot(MNode* aSlot)
{
    assert(false);
}


MNode* AVContainer::InsertSlot(MNode* aSlot, const TPos& aPos)
{
    assert(false);
}

MNode* AVContainer::GetSlotByPos(const TPos& aPos)
{
    assert(false);
}

MContainer::TPos AVContainer::PrevPos(const TPos& aPos) const
{
    assert(false);
}

MContainer::TPos AVContainer::NextPos(const TPos& aPos) const
{
    assert(false);
}

MNode* AVContainer::GetWidgetBySlot(MNode* aSlot)
{
    MNode* res = nullptr;
    MNode* slotCp = aSlot->getNode(KSlotCpName);
    assert(slotCp);
    MVert* slotCpv = slotCp->lIf(slotCpv);
    // Its allowed to not have widget assosiated
    if (slotCpv && (slotCpv->pairsCount() == 1)) {
	MVert* wdgCpv = slotCpv->getPair(0);
	assert(wdgCpv);
	MNode* wdgCp = wdgCpv->lIf(wdgCp);
	assert(wdgCp);
	auto* wdgOnrCp = wdgCp->owned()->firstPair();
	auto* wdgOwd = ahostNode()->owner()->findItem(wdgOnrCp);
	res = wdgOwd ? wdgOwd->provided()->lIf(res) : nullptr;
	//YB!! to implement
	//res = wdgCpu->GetMan();
    }
    return res;
}

void AVContainer::OnMutAddWdg()
{
    mMutAddWdgChanged = true;
    onActivated(nullptr);
}

void AVContainer::OnMutRmWdg()
{
    mMutRmWdgChanged = true;
    onActivated(nullptr);
}


void AVContainer::MutAddWidget(const NTuple& aData)
{
    bool res = true;
    string name;
    string type;
    for (int i = 0; i < aData.mData.size(); i++) {
	NTuple::tComp item = aData.mData.at(i);
	if (item.first == "name") {
	    Sdata<string>* sd = dynamic_cast<Sdata<string>*>(item.second);
	    if (sd) {
		name = sd->mData;
	    } else {
		res = false; break;
	    }
	} else if (item.first == "type") {
	    Sdata<string>* sd = dynamic_cast<Sdata<string>*>(item.second);
	    if (sd) {
		type = sd->mData;
	    } else {
		res = false; break;
	    }
	}
    }
    if (res) {
	if (type != GUri::nil) {
	    MNode* newwdg = AddWidget(name, type);
	    if (newwdg) {
		Logger()->Write(EDbg, this, "Added widget [%s]", name.c_str());
	    } else {
		Logger()->Write(EDbg, this, "Failed adding widget [%s]", name.c_str());
	    }
	} else {
	    Logger()->Write(EDbg, this, "Ignoring adding widget of type [nil]");
	}
    }
}

void AVContainer::MutRmWidget(const Sdata<int>& aData)
{
    int slotId = aData.mData;
    // Remove assosiated widget
    //RmWidget(slotId);
    // Remove slot
    MNode* curSlot = GetSlotByPos(TPos(slotId, 0));
    if (curSlot) {
	RmSlot(curSlot);
    } else {
	Logger()->Write(EErr, this, "Cannot find slot in pos [%d]", slotId);
    }
}

void AVContainer::GetCompsCount(Sdata<int>& aData)
{
    aData.mData = mCompNames.mData.size();
    aData.mValid = true;
}



void AVContainer::onMagOwnedAttached(MObservable* aObl, MOwned* aOwned)
{
    if (mMag) {
	mCompNamesUpdated = true;
	onUpdated(nullptr);
    }
}

void AVContainer::onMagOwnedDetached(MObservable* aObl, MOwned* aOwned)
{
    if (mMag) {
	mCompNamesUpdated = true;
	onUpdated(nullptr);
    }
}

void AVContainer::onMagContentChanged(MObservable* aObl, const MContent* aCont)
{
}

void AVContainer::onMagChanged(MObservable* aObl)
{
}

void AVContainer::update()
{
    if (mMutAddWdgChanged) {
	MNode* inp = ahostGetNode(K_CpUriInpAddWidget);
	if (inp) {
	    NTuple data;
	    bool res = GetGData(inp, data);
	    if (res && data != mMutAddWidget) {
		MutAddWidget(data);
	    }
	}
	mMutAddWdgChanged = false;
    }
    if (mMutRmWdgChanged) {
	MNode* inp = ahostGetNode(K_CpUriInpRmWidget);
	if (inp) {
	    Sdata<int> data;
	    bool res = GetGData(inp, data);
	    if (res && data != mMutRmWidget) {
		MutRmWidget(data);
		onUpdated(nullptr);
	    }
	}
	mMutRmWdgChanged = false;
    }
    AVWidget::update();
}

void AVContainer::confirm()
{
    if (mMag) {
	if (mCompNamesUpdated) {
	    UpdateCompNames();
	    mCompNamesUpdated = false;
	    MNode* cp = ahostGetNode(K_CpUriCompNames);
	    NotifyInpsUpdated(cp);
	    // Comps count
	    cp = ahostGetNode(K_CpUriCompCount);
	    NotifyInpsUpdated(cp);
	}
    } else {
	Logger()->Write(EErr, this, "Managed agent is not attached");
    }
    AVWidget::confirm();
}

void AVContainer::NotifyInpsUpdated(MNode* aCp)
{
    MUnit* cpu = aCp->lIf(cpu);
    auto ifaces = cpu->getIfs<MDesInpObserver>();
    if (ifaces) for (auto iface : *ifaces) {
	MDesInpObserver* mobs = (MDesInpObserver*) iface;
	if (mobs) {
	    mobs->onInpUpdated();
	}
    }
}

MNode* AVContainer::GetLastSlot()
{
    MNode* res = nullptr;
    TPos pos = LastPos();
    res = GetSlotByPos(pos);
    return res;
}

void AVContainer::RmAllSlots()
{
    MNode* slot = GetLastSlot();
    while (slot) {
	RmSlot(slot);
	slot = GetLastSlot();
    }
}

MNode* AVContainer::getSlotByCp(MNode* aSlotCp)
{
    return nullptr;
}

bool AVContainer::areCpConnected(MNode* aHost, const GUri& aCp1Uri, const GUri& aCp2Uri)
{
    MNode* cp1 = aHost->getNode(aCp1Uri);
    MNode* cp2 = aHost->getNode(aCp2Uri);
    assert(cp1 && cp2);
    MVert* cp1v = cp1->lIf(cp1v);
    MVert* cp2v = cp2->lIf(cp2v);
    assert(cp1v && cp2v);
    return cp1v->isPair(cp2v);
}





// ==== AVSlot ====

const string KCompRqWExtd_Uri = "./InpRqsW/Int";
const string KCompRqHExtd_Uri = "./InpRqsH/Int";

VSlot::VSlot(const string& aType, const string& aName, MEnv* aEnv): Syst(aType, aName, aEnv)
{
}

MIface* VSlot::MNode_getLif(const char *aType)
{
    MIface* res = nullptr;
    if (res = checkLif<MVCslot>(aType));
    else res = Syst::MNode_getLif(aType);
    return res;
}

MIface* VSlot::MOwner_getLif(const char *aType)
{
    MIface* res = nullptr;
    if (res = checkLif<MNode>(aType)); // To enable navigation thru slots
    else res = Syst::MOwner_getLif(aType);
    return res;
}

// ==== ALinearLayout ====

const string KStartSlotName = "Start";
const string KEndSlotName = "End";
const string KSlotPrevCpName = "Prev";
const string KSlotNextCpName = "Next";

ALinearLayout::ALinearLayout(const string& aType, const string& aName, MEnv* aEnv): AVContainer(aType, aName, aEnv)
{
}

MNode* ALinearLayout::GetLastSlot()
{
    MNode* res = nullptr;
    MNode* host = ahostNode();
    MNode* end = host->getNode(KEndSlotName);
    MNode* start = host->getNode(KStartSlotName);
    if (end) {
	MVert* endv = end->lIf(endv);
	if (endv) {
	    MVert* lastv = endv->getPair(0);
	    if (lastv) {
		MNode* prevu = lastv->lIf(prevu);
		if (prevu) {
		    if (prevu != start) {
			MOwner* prevo = prevu->owned()->firstPair()->provided();
			res = prevo ? prevo->lIf(res) : nullptr;
			// YB!! solve
			//res = prevu->GetMan();
		    }
		}
	    }
	}
    }
    return res;
}

MNode* ALinearLayout::AppendSlot(MNode* aSlot)
{
    MNode* host = ahostNode();
    MNode* lastSlot = GetLastSlot();
    MNode* end = host->getNode(KEndSlotName);
    MNode* start = host->getNode(KStartSlotName);
    assert(start && end);
    string endUri = end->getUriS(this);
    string newSlotUri = aSlot->getUriS(this);
    string newSlotNextUri = newSlotUri + "." + KSlotNextCpName;
    string newSlotPrevUri = newSlotUri + "." + KSlotPrevCpName;
    TNs ns; MutCtx mctx(NULL, ns);
    if (lastSlot) {
	// There are slots already
	// Disconnect last slot from end
	string lastSlotUri = lastSlot->getUriS(this);
	string lastSlotPrevUri = lastSlotUri + "." + KSlotPrevCpName;
	mutateNode(host, TMut(ENt_Disconn, ENa_P, lastSlotPrevUri, ENa_Q, endUri));
	// Connect new slot to last slot
	mutateNode(host, TMut(ENt_Conn, ENa_P, lastSlotPrevUri, ENa_Q, newSlotNextUri));
    } else {
	// There are no slots yet
	// Connect new slot to start
	string startUri = start->getUriS(this);
	mutateNode(host, TMut(ENt_Conn, ENa_P, startUri, ENa_Q, newSlotNextUri));
    }
    // Connect new slot to end
    mutateNode(host, TMut(ENt_Conn, ENa_P, newSlotPrevUri, ENa_Q, endUri));
    return NULL; // TODO to fix
}

void ALinearLayout::RmSlot(MNode* aSlot)
{
    string sname = aSlot->name();
    Logger()->Write(EInfo, this, "Start removing slot [%s]", sname.c_str());
    MNode* host = ahostNode();
    // Remove assosiated widget
    bool res = RmWidgetBySlot(aSlot);
    if (res) {
	// Get prev and next
	MNode* prevSlotCp = GetPrevSlotCp(aSlot);
	string prevSlotUri = prevSlotCp->getUriS(this);
	MNode* nextSlotCp = GetNextSlotCp(aSlot);
	string nextSlotUri = nextSlotCp->getUriS(this);
	// Remove slot, also disconnects from prev and next
	mutateNode(host, TMut(ENt_Rm, ENa_MutNode, sname));
	// Connect prev and next
	mutateNode(host, TMut(ENt_Conn, ENa_P, prevSlotUri, ENa_Q, nextSlotUri));
	Logger()->Write(EInfo, this, "Completed removing slot");
    }
}

MNode* ALinearLayout::InsertSlot(MNode* aSlot, const TPos& aPos)
{
    MNode* host = ahostNode();
    MNode* curSlot = GetSlotByPos(aPos);
    MNode* end = host->getNode(KEndSlotName);
    MNode* start = host->getNode(KStartSlotName);
    assert(start && end);
    string startUri = start->getUriS(this);
    string endUri = end->getUriS(this);
    string newSlotUri = aSlot->getUriS(this);
    string newSlotNextUri = newSlotUri + "." + KSlotNextCpName;
    string newSlotPrevUri = newSlotUri + "." + KSlotPrevCpName;
    if (curSlot) {
	string curSlotUri = curSlot->getUriS(this);
	string curSlotNextUri = curSlotUri + "." + KSlotNextCpName;
	string curSlotPrevUri = curSlotUri + "." + KSlotPrevCpName;
	MNode* prevSlotCp = GetPrevSlotCp(curSlot);
	assert(prevSlotCp);
	string prevSlotPrevUri = prevSlotCp->getUriS(this);
	if (areCpConnected(host, prevSlotPrevUri, curSlotNextUri)) {
	    // Disconnect  cur slot from prev slot
	    mutateNode(host, TMut(ENt_Disconn, ENa_P, prevSlotPrevUri, ENa_Q, curSlotNextUri));
	}
	// Connect new slot to prev slot
	mutateNode(host, TMut(ENt_Conn, ENa_P, prevSlotPrevUri, ENa_Q, newSlotNextUri));
	// Connect new slot to cur slot
	mutateNode(host, TMut(ENt_Conn, ENa_P, newSlotPrevUri, ENa_Q, curSlotNextUri));
    } else {
	if (aPos == KPosFirst) {
	    // There is no slots yet
	    // Connect new slot to start
	    mutateNode(host, TMut(ENt_Conn, ENa_P, startUri, ENa_Q, newSlotNextUri));
	    // Connect new slot to end
	    mutateNode(host, TMut(ENt_Conn, ENa_P, newSlotPrevUri, ENa_Q, endUri));
	} else if (aPos == KPosEnd) {
	    MNode* prevSlot = GetLastSlot();
	    string prevSlotPrevUri;
	    if (prevSlot) {
		prevSlotPrevUri = prevSlot->getUriS(this) + "." + KSlotPrevCpName;
	    } else {
		prevSlotPrevUri = startUri;
	    }
	    if (areCpConnected(host, prevSlotPrevUri, endUri)) {
		mutateNode(host, TMut(ENt_Disconn, ENa_P, prevSlotPrevUri, ENa_Q, endUri));
	    }
	    mutateNode(host, TMut(ENt_Conn, ENa_P, prevSlotPrevUri, ENa_Q, newSlotNextUri));
	    mutateNode(host, TMut(ENt_Conn, ENa_P, newSlotPrevUri, ENa_Q, endUri));
	} else {
	    assert(false);
	}
    }
    return NULL; // TODO to fix
}

MContainer::TPos ALinearLayout::PrevPos(const TPos& aPos) const
{
    assert(aPos != KPosFirst);
    TPos res = aPos;
    res.first--;
    return res;
}

MContainer::TPos ALinearLayout::NextPos(const TPos& aPos) const
{
    assert(aPos != KPosEnd);
    TPos res = aPos;
    res.first++;
    return res;
}

MNode* ALinearLayout::GetSlotByPos(const TPos& aPos)
{
    MNode* res = nullptr;
    if (aPos == KPosEnd) {
    } else if (aPos == KPosFirst) {
	MNode* host = ahostNode();
	MNode* start = host->getNode(KStartSlotName);
	assert(start);
	MVert* startv = start->lIf(startv);
	if (startv->pairsCount() == 1) {
	    MVert* first_next = startv->getPair(0);
	    MNode* first_nextn = first_next->lIf(first_nextn);
	    MOwner* first_nexto = first_nextn->owned()->firstPair()->provided();
	    res = first_nexto ? first_nexto->lIf(res) : nullptr;
	}
    } else {
	TPos pos = KPosFirst;
	MNode* slot = GetSlotByPos(KPosFirst);
	while (pos != aPos) {
	    slot = GetNextSlot(slot);
	    pos = NextPos(pos);
	}
	res = slot;
    }
    return res;
}

MNode* ALinearLayout::GetPrevSlotCp(MNode* aSlot)
{
    MNode* res = nullptr;
    MNode* slot_nextu = aSlot->getNode(KSlotNextCpName);
    MVert* slot_nextv = slot_nextu->lIf(slot_nextv);
    if (slot_nextv->pairsCount() == 1) {
	MVert* res_prev = slot_nextv->getPair(0);
	res = res_prev->lIf(res);
    }
    return res;
}

MNode* ALinearLayout::GetNextSlotCp(MNode* aSlot)
{
    MNode* res = nullptr;
    MNode* slot_prevu = aSlot->getNode(KSlotPrevCpName);
    MVert* slot_prevv = slot_prevu->lIf(slot_prevv);
    if (slot_prevv->pairsCount() == 1) {
	MVert* res_next = slot_prevv->getPair(0);
	res = res_next->lIf(res);
    } else {
	Log(TLog(EErr, this) + "Slot [" + aSlot->getUriS() + "] Prev CP is not connected");
    }
    return res;
}

MNode* ALinearLayout::GetNextSlot(MNode* aSlot)
{
    MNode* res = nullptr;
    MNode* ncp = GetNextSlotCp(aSlot);
    MOwner* ncpo = ncp ? ncp->owned()->firstPair()->provided() : nullptr;
    MNode* nsl = ncpo ? ncpo->lIf(nsl) : nullptr;
    MVCslot* nsls = nsl ? nsl->lIf(nsls) : nullptr;
    if (nsls) {
	res = nsl;
    }
    return res;
}

void ALinearLayout::UpdateCompNames()
{
    mCompNames.mData.clear();
    MNode* slot = GetSlotByPos(TPos(0,0));
    while (slot) {
	MNode* widget = GetWidgetBySlot(slot);
	if (widget) {
	    mCompNames.mData.push_back(widget->name());
	}
	slot = GetNextSlot(slot);
    }
}


//// AVDContainer

AVDContainer::AVDContainer(const string& aType, const string& aName, MEnv* aEnv): AVWidget(aType, aName, aEnv)
{
}

AVDContainer::~AVDContainer()
{
}

void AVDContainer::resolveIfc(const string& aName, MIfReq::TIfReqCp* aReq)
{
    if (aName == MViewMgr::Type()) {
	MUnit* hownu = getHostOwnerUnit();
	if (hownu) {
	    hownu->resolveIface(aName, aReq);
	}
    } else {
	AVWidget::resolveIfc(aName, aReq);
    }
}

void AVDContainer::Render()
{
    Log(TLog(EDbg, this) + "Render");
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
		if (mse) {
		    res = mse->onMouseButton(aButton, aAction, aMods);
		}
	    }
	    compCp = host->owner()->nextPair(compCp);
	}
    }
    return res;
}




