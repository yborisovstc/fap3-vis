
#include "vlayout.h"

// ==== AVLayout ====

const string KSlotType = "ContainerMod.FVLayoutSlot";

AVLayout::AVLayout(const string& aName, MEnv* aEnv): ALinearLayout(aName, aEnv)
{
    if (aName.empty()) mName = Type();
}

string AVLayout::GetSlotType()
{
    return KSlotType;
}
