
#ifndef __FAP3VIS_HLAYOUTL_H
#define __FAP3VIS_HLAYOUTL_H

#include <map>

#include "container.h"

/** @brief Vertical layout agent using approach of widgets linked to slot
 * */
class AHLayout: public ALinearLayout
{
    public:
	static const char* Type() { return "AHLayout";};
	AHLayout(const string& aType, const string& aName = string(), MEnv* aEnv = NULL);
	// From AVContainer
	virtual string GetSlotType() override;
};

#endif

