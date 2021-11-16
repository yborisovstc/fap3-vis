#ifndef __FAP3VIS_MVRCONTROLLER_H
#define __FAP3VIS_MVRCONTROLLER_H

#include <miface.h>

class MVrp;

/** @brief Model's visual representation controller interface
 * Manages main aspects of representation
 * */
class MVrController: public MIface
{
    public:
	static const char* Type() { return "MVrController";};
	virtual void CreateModel(const string& aSpecPath) = 0;
	virtual void OnRpSelected(const MVrp* aRp) = 0;
	virtual MUnit* ModelRoot() = 0;
	virtual void ApplyCursor(const string& aCursor) = 0;
	// From MIface
	virtual string Uid() const override { return MVrController_Uid();}
	virtual string MVrController_Uid() const = 0;
};

#endif
