#ifndef __FAP3VIS_VISPROV_H
#define __FAP3VIS_VISPROV_H


#include "prov.h"


/** @brief Default provider
 * */
class VisProv: public ProvBase
{
    public:
	VisProv(const string& aName, MEnv* aEnv);
	virtual ~VisProv();
	// From ProvBase
	virtual const TFReg& FReg() const override {return mReg;}
	// From MProvider
	virtual void getNodesInfo(vector<string>& aInfo);
	virtual const string& modulesPath() const;
	virtual void setChromoRslArgs(const string& aRargs) {}
	virtual void getChromoRslArgs(string& aRargs) {}
	virtual MChromo* createChromo(const string& aRargs = string());
    private:
	static const TFReg mReg;
};


#endif
