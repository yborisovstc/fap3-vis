
#ifndef __FAP3VIS_ALIGNMENT_H
#define __FAP3VIS_ALIGNMENT_H

#include "container.h"


/** @brief Alignment container
 * */
class AAlignment: public AVContainer
{
    public:
	static const char* Type() { return "AAlignment";};
	AAlignment(const string& aName = string(), MEnv* aEnv = NULL);
	// From MContainer
	virtual MNode* GetSlotByPos(const TPos& aPos) override;
	virtual MNode* AddWidget(const string& aName, const string& aType, const string& aHint = string()) override;
	virtual void UpdateCompNames() override;
	virtual void MutRmWidget(const Sdata<int>& aData) override;
};

#endif // __FAP2VIS_VLAYOUT_H

