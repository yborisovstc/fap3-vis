
#ifndef __FAP3VIS_CONTAINERL_H
#define __FAP3VIS_CONTAINERL_H

#include <map>
#include <mdes.h>
#include <mdata.h>
#include <desadp.h>

#include "widget.h"

/** @brief Containter agent
 * Resolve MSceneElem redirecting to Controlled part
 * */
class ACnt: public AgtBase
{
    public:
	static const char* Type() { return "ACnt";};
	ACnt(const string &aType, const string& aName = string(), MEnv* aEnv = NULL);
	virtual ~ACnt();
	// From Unit.MIfProvOwner
	virtual void resolveIfc(const string& aName, MIfReq::TIfReqCp* aReq) override;
	// From MAgent
	virtual string MAgent_Uid() const override {return getUid<MAgent>();}
	virtual MIface* MAgent_getLif(const char *aName) override;
};

/** @brief Widgets containter agent using approach of widgets linked to slot
 * With this approach each widget is assosiates to corresponding slot but not embedded to it
 * This container doesn't provide widgets allocation by itself but delegates it to slots
 * Each slot can have its own rules for allocating assosiated widget
 * This is containter version that supports DES controlling
 * */
class AVDContainer: public AVWidget, public MSceneElemOwner
{
    public:
	using TCmpNames = AMnodeAdp::TCmpNames;
    public:
	static const char* Type() { return "AVDContainer";};
	AVDContainer(const string& aType, const string& aName = string(), MEnv* aEnv = NULL);
	virtual ~AVDContainer();
	// From MNode
	virtual MIface* MNode_getLif(const char *aType) override;
	// From Unit.MIfProvOwner
	virtual void resolveIfc(const string& aName, MIfReq::TIfReqCp* aReq) override;
	// From MSceneElem
	virtual void Render() override;
	virtual bool onMouseButton(TFvButton aButton, TFvButtonAction aAction, int aMods) override;
	// From MSceneElemOwner
	virtual string MSceneElemOwner_Uid() const override {return getUid<MSceneElemOwner>();}
	//virtual void getWndCoordSeo(int aInpX, int aInpY, int& aOutX, int& aOutY) override;
	virtual void getCoordOwrSeo(int& aOutX, int& aOutY, int aLevel = -1) override;
};


#endif // __FAP2VIS_CONTAITER_H

