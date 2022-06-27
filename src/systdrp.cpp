
#include "systdrp.h"

ASystDrp::ASystDrp(const string& aType, const string& aName, MEnv* aEnv): ANodeDrp(aType, aName, aEnv)
{
}

void ASystDrp::Render(bool aForce)
{
    AHLayout::Render(aForce);
}

void ASystDrp::CreateRp()
{
#if 0
    MUnit* host = GetMan();
    // Create right column for output connpoint
    MUnit* rcolu = InsertWidget("Column_R", "/*/Modules/ContainerModL/FVLayoutL", KPosFirst);
    MContainer* rcol = rcolu->GetSIfit(rcol);
    if (rcol) {
	for (int ind = 0; ind < mMdl->CompsCount(); ind++) {
	    MUnit* comp = mMdl->GetComp(ind);
	    MCompatChecker* cmpc = comp->GetObj(cmpc);
	    if (cmpc && cmpc->GetDir() == MCompatChecker::EOut) {
		string compUri = comp->GetUri(0,true);
		MUnit* vcompu = rcol->InsertWidget(comp->Name(), "/*/Modules/FvWidgetsL/FUnitCrp", KPosEnd);
		__ASSERT(vcompu);
		MVrp* vcompr = vcompu->GetSIfit(vcompr);
		__ASSERT(vcompr);
		vcompr->SetEnv(mEnv);
		vcompr->SetModel(compUri);
	    }
	}
    }
    // Layout next colums
    int colnum = 0;
    while (AreThereCompsRelToFirstColumn()) {
	MUnit* colu = InsertWidget("Column_" + to_string(colnum), "/*/Modules/ContainerModL/FVLayoutL", KPosFirst);
	__ASSERT(colu);
	LayoutBodyColumn(colu);
	colnum++;
    }
#endif
}

void ASystDrp::SetCrtlBinding(const string& aCtrUri)
{
#if 0
    __ASSERT(mCtrBnd.empty());
    MUnit* ctru = GetNode(aCtrUri);
    if (ctru) {
	mCtrBnd = aCtrUri;
    } else {
	Logger()->Write(EErr, this, "Wrong controller binding info [%s]", aCtrUri.c_str());
    }
#endif
}

bool ASystDrp::AreThereCompsRelToFirstColumn()
{
#if 0
    bool res = false;
    // Get column container
    MUnit* csl = GetSlotByPos(TPos(0,0));
    MUnit* col = GetWidgetBySlot(csl);
    MContainer* colc = col->GetSIfit(colc);
    __ASSERT(colc);
    TPos pos = KPosFirst;
    MUnit* cslot = colc->GetSlotByPos(pos);
    while ((pos != KPosEnd) && cslot && !res) {
	MUnit* wdg = GetWidgetBySlot(cslot);
	MVrp* wdgrp = wdg->GetSIfit(wdgrp);
	MUnit* mdl = mMdl->GetNode(wdgrp->GetModelUri());
	MVert* mdlv = mdl->GetObj(mdlv);
	for (int i = 0; i < mMdl->CompsCount() && !res; i++) {
	    MUnit* comp = mMdl->GetComp(i);
	    MVert* compv = comp->GetObj(compv);
	    if (compv && comp != mdl) {
		res = compv->IsLinked(mdlv);
	    }
	}
	pos = NextPos(pos);
	if (pos != KPosEnd) {
	    cslot = colc->GetSlotByPos(pos);
	}
    }
    return res;
#endif
    return false;
}

void ASystDrp::LayoutBodyColumn(MUnit* aColumn)
{
#if 0
    MContainer* colc = aColumn->GetSIfit(colc);
    __ASSERT(colc);
    // Get previous (right) column container
    MUnit* rcsl = GetSlotByPos(TPos(1,0));
    MUnit* rcol = GetWidgetBySlot(rcsl);
    MContainer* rcolc = rcol->GetSIfit(rcolc);
    __ASSERT(rcolc);
    TPos pos = KPosFirst;
    MUnit* rcslot = rcolc->GetSlotByPos(pos);
    // Walk round right column
    while ((pos != KPosEnd) && rcslot) {
	MUnit* rwdg = GetWidgetBySlot(rcslot);
	MVrp* rwdgrp = rwdg->GetSIfit(rwdgrp);
	MUnit* rmdl = mMdl->GetNode(rwdgrp->GetModelUri());
	MVert* rmdlv = rmdl->GetObj(rmdlv);
	// Walk thru model components, find linked and add Crp for it
	for (int i = 0; i < mMdl->CompsCount(); i++) {
	    MUnit* comp = mMdl->GetComp(i);
	    bool hasCrp = HasCrp(comp);
	    if (!hasCrp) {
		MVert* compv = comp->GetObj(compv);
		if (compv && comp != rmdl) {
		    bool linked = compv->IsLinked(rmdlv);
		    if (linked) {
			MUnit* vcompu = colc->InsertWidget(comp->Name(), "/*/Modules/FvWidgetsL/FUnitCrp", KPosFirst);
			__ASSERT(vcompu);
			MVrp* vcompr = vcompu->GetSIfit(vcompr);
			__ASSERT(vcompr);
			vcompr->SetEnv(mEnv);
			string compUri = comp->GetUri(0,true);
			vcompr->SetModel(compUri);
		    }
		}
	    }
	}
	pos = NextPos(pos);
	if (pos != KPosEnd) {
	    rcslot = rcolc->GetSlotByPos(pos);
	}
    }
#endif
}

bool ASystDrp::HasCrpInColumn(TPos aColumnPos, MUnit* aMdl)
{
    assert(aColumnPos != KPosEnd);
    bool res = false;
#if 0
    TPos pos = KPosFirst;
    MUnit* cslot = GetSlotByPos(aColumnPos);
    MUnit* col = GetWidgetBySlot(cslot);
    MContainer* colc = col->GetSIfit(colc);
    while ((pos != KPosEnd) && !res) {
	MUnit* cslot = colc->GetSlotByPos(aColumnPos);
	MUnit* crpu = GetWidgetBySlot(cslot);
	MVrp* crp = crpu->GetSIfit(crp);
	MUnit* mdl = mMdl->GetNode(crp->GetModelUri());
	res = (mdl == aMdl);
	pos = NextPos(pos);
    }
#endif
    return res;
}

bool ASystDrp::HasCrp(MUnit* aMdl)
{
    bool res = false;
#if 0
    TPos pos = KPosFirst;
    while ((pos != KPosEnd) && !res) {
	res = HasCrpInColumn(pos, aMdl);
	pos = NextPos(pos);
    }
#endif
    return res;
}

