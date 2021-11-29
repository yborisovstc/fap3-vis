
#include "hlayout.h"

// ==== AHLayout ====

const string KSlotType = "ContainerMod.FHLayoutSlot";

AHLayout::AHLayout(const string& aType, const string& aName, MEnv* aEnv): ALinearLayout(aType, aName, aEnv)
{
}

string AHLayout::GetSlotType()
{
    return KSlotType;
}
