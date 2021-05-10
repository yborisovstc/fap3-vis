
#include "hlayout.h"

// ==== AHLayout ====

const string KSlotType = "ContainerMod.FHLayoutSlot";

AHLayout::AHLayout(const string& aName, MEnv* aEnv): ALinearLayout(aName, aEnv)
{
    if (aName.empty()) mName = Type();
}

string AHLayout::GetSlotType()
{
    return KSlotType;
}
