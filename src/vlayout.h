
#ifndef __FAP3VIS_VLAYOUTL_H
#define __FAP3VIS_VLAYOUTL_H

#include <map>

#include "container.h"

/** @brief Vertical layout agent using approach of widgets linked to slot
 * */
class AVLayout: public ALinearLayout
{
    public:
	static const char* Type() { return "AVLayout";};
	AVLayout(const string& aType, const string& aName = string(), MEnv* aEnv = NULL);
	// From AVContainer
	virtual string GetSlotType() override;
};

#endif

