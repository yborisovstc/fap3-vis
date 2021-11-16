#ifndef __FAP3VIS_MAGENTVR_H
#define __FAP3VIS_MAGENTVR_H

#include <miface.h>


/** @brief Model's visual representation interface
 * */
class MVrp: public MIface
{
    public:
	static const char* Type() { return "MVrp";};
	virtual void SetEnv(MEnv* aEnv) = 0;
	virtual void SetModel(const string& aMdlUri) = 0;
	virtual string GetModelUri() const = 0;
	//virtual void OnCompSelected(const MVrp* aComp) = 0;
	/** @ Sets info of binding to controller
	 * @param[in]  aCtrUri - Controller absolute URI
	 * */
	virtual void SetCrtlBinding(const string& aCtrUri) = 0;
	// From MIface
	virtual string Uid() const override { return MVrp_Uid();}
	virtual string MVrp_Uid() const = 0;
};

/** @brief Model's visual representation view manager interface
 * View is the part of standard view-model app architecture
 * This is upper-layer agent managing the view
 * */
class MVrpView: public MIface
{
    public:
	static const char* Type() { return "MVrpView";};
	virtual void OnCompSelected(const MVrp* aComp) = 0;
	// From MIface
	virtual string Uid() const override { return MVrpView_Uid();}
	virtual string MVrpView_Uid() const = 0;
};


#endif
