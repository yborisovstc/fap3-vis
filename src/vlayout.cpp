
#include "vlayout.h"

// ==== AVLayout ====

const string KSlotType = "ContainerMod.FVLayoutSlot";

AVLayout::AVLayout(const string& aType, const string& aName, MEnv* aEnv): ALinearLayout(aType, aName, aEnv)
{
}

string AVLayout::GetSlotType()
{
    return KSlotType;
}
