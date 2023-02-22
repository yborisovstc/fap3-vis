
#ifndef __FAP3VIS_CONTAINERL_H
#define __FAP3VIS_CONTAINERL_H

#include <map>
#include <mdes.h>
#include <mdata.h>
#include <desadp.h>

#include "widget.h"


/** @brief Widgets containter agent using approach of widgets linked to slot
 * With this approach each widget is assosiates to corresponding slot but not embedded to it
 * This container doesn't provide widgets allocation by itself but delegates it to slots
 * Each slot can have its own rules for allocating assosiated widget
 * This is containter version that supports DES controlling
 * */
class AVDContainer: public AVWidget
{
    public:
	using TCmpNames = AMnodeAdp::TCmpNames;
    public:
	static const char* Type() { return "AVDContainer";};
	AVDContainer(const string& aType, const string& aName = string(), MEnv* aEnv = NULL);
	virtual ~AVDContainer();
	// From Unit.MIfProvOwner
	virtual void resolveIfc(const string& aName, MIfReq::TIfReqCp* aReq) override;
	// From MSceneElem
	virtual void Render() override;
	virtual bool onMouseButton(TFvButton aButton, TFvButtonAction aAction, int aMods) override;
};


#endif // __FAP2VIS_CONTAITER_H

