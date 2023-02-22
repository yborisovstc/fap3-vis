
#ifndef __FAP3VIS_AGENTVR_H
#define __FAP3VIS_AGENTVR_H

#include "widget.h"
#include "container.h"
#include "mmntp.h"


/** @brief Agents Visual representation view manager
 * */
class AVrpView : public Unit, public MAgent
{
	using TAgtCp = NCpOnp<MAgent, MAhost>;  /*!< Agent conn point */
    public:
	static const char* Type() { return "AVrpView";};
	AVrpView(const string& aType, const string& aName = string(), MEnv* aEnv = NULL);
	// From MNode
	virtual MIface* MNode_getLif(const char *aName) override;
	// From MAgent
	virtual string MAgent_Uid() const override { return getUid<MAgent>();}
	virtual MIface* MAgent_getLif(const char *aType) override;
	// From Node.MOwned
	virtual void onOwnerAttached() override;
    protected:
	MNode* ahostNode();
	void CreateRp();
    protected:
	TAgtCp mAgtCp; /*!< Agent connpoint */ 
	MEnv* mBEnv; /*!< Binded env, not owned */
	MNode* mMdl; /*!< Binded model, not owned */
	string mCtrBnd; /*!< Binding to controller info: URI */
};

/** @brief Edge CRP widget agent
 * */
class AEdgeCrp : public AVWidget
{
    public:
	static const char* Type() { return "AEdgeCrp";};
	AEdgeCrp(const string& aType, const string& aName = string(), MEnv* aEnv = NULL);
	// From MSceneElem
	virtual void Render() override;
    protected:
	pair<int, int> GetVertCp(bool aLeft);
	void GetOwnerPtWndCoord(int aInpX, int aInpY, int& aOutX, int& aOutY);
	void GetDirectWndCoord(int aInpX, int aInpY, int& aOutX, int& aOutY);
    protected:
	// Internal transitions
	virtual void updateRqsW();
};


#endif

