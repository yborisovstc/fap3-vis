
#ifndef __FAP3VIS_CONTAINERL_H
#define __FAP3VIS_CONTAINERL_H

#include <map>
#include <mdes.h>
#include <mdata.h>
#include <desadp.h>

#include "mcontainer.h"
#include "widget.h"

/** @brief Widgets containter agent using approach of widgets linked to slot
 * With this approach each widget is assosiates to corresponding slot but not embedded to it
 * This container doesn't provide widgets allocation by itself but delegates it to slots
 * Each slot can have its own rules for allocating assosiated widget
 * */
class AVContainer: public AVWidget, public MContainer
{
    public:
	using TCmpNames = AMnodeAdp::TCmpNames;
	friend AAdp::AdpMagObs<AVContainer>;
    public:
	static const char* Type() { return "AVContainer";};
	AVContainer(const string& aName = string(), MEnv* aEnv = NULL);
	virtual ~AVContainer(); 
	// From MNode.MIface
	virtual MIface* MNode_getLif(const char *aName) override;
	// From Unit.MIfProvOwner
	virtual bool resolveIfc(const string& aName, MIfReq::TIfReqCp* aReq) override;
	// From Node.MOwned
	virtual void onOwnerAttached() override;
	// From MSceneElem
	virtual void Render() override;
	virtual bool onMouseButton(TFvButton aButton, TFvButtonAction aAction, int aMods) override;
	// From MContainer
	virtual MNode* AddWidget(const string& aName, const string& aType, const string& aHint = string()) override;
	virtual MNode* InsertWidget(const string& aName, const string& aType, const TPos& aPos) override;
	virtual bool RmWidget(int aSlotPos, const string& aHint = string()) override;
	virtual TPos LastPos() const override;
	// From MDesSyncable
	virtual void update() override;
	virtual void confirm() override;
	// Local
	virtual string GetSlotType();
	virtual MNode* AppendSlot(MNode* aSlot);
	virtual MNode* InsertSlot(MNode* aSlot, const TPos& aPos);
	virtual void RmSlot(MNode* aSlot);
	virtual int GetLastSlotId();
	virtual int GetSlotId(const string& aSlotName) const;
	virtual string GetSlotName(int aSlotId) const;
	virtual MNode* GetPrevSlotCp(MNode* aSlot);
	virtual MNode* GetNextSlotCp(MNode* aSlot);
	virtual MNode* GetNextSlot(MNode* aSlot);
	virtual MNode* GetSlotByPos(const TPos& aPos) override;
	virtual TPos PrevPos(const TPos& aPos) const;
	virtual TPos NextPos(const TPos& aPos) const;
	virtual MNode* GetWidgetBySlot(MNode* aSlot);
	virtual MNode* GetLastSlot();
	// Local
	void RmAllSlots();
    protected:
	// Local
	void MutAddWidget(const NTuple& aData);
	virtual void MutRmWidget(const Sdata<int>& aData);
	void GetCompsCount(Sdata<int>& aData);
	void GetCompNames(AMnodeAdp::TCmpNames& aData) { aData = mCompNames;}
	void OnMutAddWdg();
	void OnMutRmWdg();
	bool RmWidgetBySlot(MNode* aSlot);
	MNode* getSlotByCp(MNode* aSlotCp);
	virtual void UpdateCompNames() {}
	/** @brief Notifies dependencies of input updated */
	void NotifyInpsUpdated(MNode* aCp);
	// For managed agent (host) observer
	virtual void OnMagCompDeleting(const MNode* aComp, bool aSoft = true, bool aModif = false);
	virtual void OnMagCompAdding(const MNode* aComp, bool aModif = false);
	virtual bool OnMagCompChanged(const MNode* aComp, const string& aContName = string(), bool aModif = false);
	virtual bool OnMagChanged(const MNode* aComp);
	virtual bool OnMagCompRenamed(const MNode* aComp, const string& aOldName);
	virtual void OnMagCompMutated(const MNode* aNode);
	virtual void OnMagError(const MNode* aComp);
    protected:
	static const TPos KPosFirst;
	static const TPos KPosEnd;
	NTuple mMutAddWidget;     /*!< Mutation: append component */
	Sdata<int> mMutRmWidget;     /*!< Mutation: remove component */
	MNode* mMag = NULL;       /*!< Managed object, host */
	TCmpNames mCompNames;     /*!< Component names, observable data */
	bool mCompNamesUpdated = true;
	bool mMutAddWdgChanged = false;
	bool mMutRmWdgChanged = false;
	// Comps count param adapter. Even if the count can be get via comp names vector we support separate param for convenience
	AAdp::AdpPap<int> mApCmpCount = AAdp::AdpPap<int>(*this, [this](Sdata<int>& aData) {GetCompsCount(aData);}); /*!< Comps count access point */
	AAdp::AdpPapB<TCmpNames> mApCmpNames = AAdp::AdpPapB<TCmpNames>([this](TCmpNames& aData) {GetCompNames(aData);}); /*!< Comp names access point */
	AAdp::AdpIap mIapMutAddWdt = AAdp::AdpIap(*this, [this]() {OnMutAddWdg();}); /*!< Mut Add_Widget input access point */
	AAdp::AdpIap mIapMutRmWdt = AAdp::AdpIap(*this, [this]() {OnMutRmWdg();}); /*!< Mut Remove_Widget input access point */
};

/** @brief Container's slot base using approach of widghet to slot assosiation via link
 * */
// TODO Do we need specific agent for slot?
class VSlot: public Syst, public MVCslot
{
    public:
	static const char* Type() { return "VSlot";};
	VSlot(const string& aName = string(), MEnv* aEnv = NULL);
	// From MNode
	virtual MIface* MNode_getLif(const char *aName) override;
	// From MVCslot
	virtual string MVCslot_Uid() const {return MVCslot::Type();}
};

/** @brief Linear layout base agent
 * */
class ALinearLayout: public AVContainer
{
    public:
	static const char* Type() { return "ALinearLayout";};
	ALinearLayout(const string& aName = string(), MEnv* aEnv = NULL);
	// From AVContainer
	virtual MNode* AppendSlot(MNode* aSlot) override;
	virtual MNode* InsertSlot(MNode* aSlot, const TPos& aPos) override;
	virtual void RmSlot(MNode* aSlot) override;
	virtual MNode* GetSlotByPos(const TPos& aPos) override;
	virtual MNode* GetPrevSlotCp(MNode* aSlot) override;
	virtual MNode* GetNextSlotCp(MNode* aSlot) override;
	virtual MNode* GetNextSlot(MNode* aSlot) override;
	virtual TPos PrevPos(const TPos& aPos) const override;
	virtual TPos NextPos(const TPos& aPos) const override;
	virtual void UpdateCompNames() override;
    protected:
	MNode* GetLastSlot();
};

;

#endif // __FAP2VIS_CONTAITER_H

