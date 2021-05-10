
#include "mwindow.h"
#include "alignment.h"

const string KSlotName = "Slot";
const string KSlotCpName = "SCp";
const string KWidgetCpName = "Cp";

AAlignment::AAlignment(const string& aName, MEnv* aEnv): AVContainer(aName, aEnv)
{
    if (aName.empty()) mName = Type();
}

MNode* AAlignment::AddWidget(const string& aName, const string& aType, const string& aHint)
{
    MNode* host = ahostNode();
    // No need to add new slot, it is already there
    string slotUri = KSlotName;
    MNode* slot = host->getNode(slotUri);
    assert(slot);
    // Add new widget
    mutateNode(host, TMut(ENt_Node, ENa_Id, aName, ENa_Parent, aType));
    string newWdgUri = aName;
    MNode* newWdg = host->getNode(newWdgUri);
    assert(newWdg);
    // Bind widget to slot
    string widgetCp = aName + "." + KWidgetCpName;
    string slotCp = slot->getUriS(this);
    mutateNode(host, TMut(ENt_Conn, ENa_P, widgetCp, ENa_Q, slotCp + "/" + KSlotCpName));
    // Invalidate Iface cache
    invalidateIrm();
    return newWdg;
}

MNode* AAlignment::GetSlotByPos(const TPos& aPos)
{
    MNode* res = nullptr;
    if (aPos == KPosFirst) {
	MNode* host = ahostNode();
	res = host->getNode(KSlotName);
    }
    return res;
}

void AAlignment::UpdateCompNames()
{
    mCompNames.mData.clear();
    MNode* slot = GetSlotByPos(KPosFirst);
    if (slot) {
	MNode* widget = GetWidgetBySlot(slot);
	if (widget) {
	    mCompNames.mData.push_back(widget->name());
	}
    }
}

void AAlignment::MutRmWidget(const Sdata<int>& aData)
{
    int slotId = aData.mData;
    // Only remove assosiated widget, keep the slot 
    RmWidget(slotId);
}


