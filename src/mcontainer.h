#ifndef __FAP3VIS_MCONTAINER_H
#define __FAP3VIS_MCONTAINER_H

#include <miface.h>


/** @brief Container slot
 * Represents container slot in connection to container component
 * */
class MVCslot: public MIface
{
    public:
	static const char* Type() { return "MVCslot";};
	// From MIface
	virtual string Uid() const override { return MVCslot_Uid();}
	virtual string MVCslot_Uid() const = 0;
};


/** @brief Visual representation view interface
 * View is the part of standard view-model app architecture
 * This is upper-layer agent managing the view
 * */
class MViewMgr: public MIface
{
    public:
	static const char* Type() { return "MViewMgr";};
	// From MIface
	virtual string Uid() const override { return MViewMgr_Uid();}
	virtual string MViewMgr_Uid() const = 0;
	virtual MIface *getLif(const char *aType) { return MViewMgr_getLif(aType);}
	virtual MIface *MViewMgr_getLif(const char *aType) = 0;
};

class MNode;

/** @brief Container interface
 * */
// TODO To verify the current design: is using of 'universal' position type valid?
// probably we need to have specific ifaces for layout variants (linear, 2d etc) where
// specific pos type is defined.
class MContainer: public MIface
{
    public:
	/** @brief Slot position type: 0..n - regular pos, -1 - after last */
	using TPos = pair<int, int>;
    public:
	static const char* Type() { return "MContainer";};
	// From MIface
	virtual string Uid() const override { return MContainer_Uid();}
	virtual string MContainer_Uid() const = 0;
	/** @brief Creates widget of given type and name and then appends it
	 * @return Pointer to added widget unit
	 * */
	virtual MNode* AddWidget(const string& aName, const string& aType, const string& aHint = string()) = 0;
	/** @brief Creates widget of given type and name and inserts it before given position
	 * @param  aPos position the widget to be inserted, -1 means 'before first position'
	 * @return Pointer to added widget unit
	 * */
	virtual MNode* InsertWidget(const string& aName, const string& aType, const TPos& aPos) = 0;
	/** @brief Removes slot by Id and assosiated widget
	 * @param  Id of slot to be removed
	 * @return Sign of success
	 * */
	virtual bool RmWidget(int aSlotId, const string& aHint = string()) = 0;
	/** @brief Gets last slot postion */
	virtual TPos LastPos() const = 0;
	/** @brief Gets slot by slot postion */
	virtual MNode* GetSlotByPos(const TPos& aPos) = 0;
	// From MIface
};


#endif

