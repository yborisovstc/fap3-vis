
#ifndef __FAP3VIS_AGENTVR_H
#define __FAP3VIS_AGENTVR_H

#include "widget.h"
#include "container.h"
#include "hlayout.h"
#include "magentvr.h"


/** @brief Agent visual representation widget
 * Base agent for agents representations
 * */
class AAgentVr : public AVWidget
{
    public:
	static const char* Type() { return "AAgentVr";};
	AAgentVr(const string& aType, const string& aName = string(), MEnv* aEnv = NULL);
	virtual ~AAgentVr();
	// From MSceneElem
	virtual void Render() override;
    protected:
	static void DrawLine(float x1, float y1, float x2, float y2);
    protected:
	const int K_BFontSize = 18; /**< Base metric: Base font (unit name) size. */
	const int K_BPadding = 3; /**< Base metric: Base padding */
	const int K_LineWidth = 1; /**< Base metric: Line width */
	const int K_MinBodyHeight = 20; /**< Minimum body height */
};

class FTPixmapFont;

/** @brief Node compact representation widget
 * */
class ANodeCrp : public AAgentVr, public MVrp
{
    public:
	static const char* Type() { return "ANodeCrp";};
	ANodeCrp(const string& aType, const string& aName = string(), MEnv* aEnv = NULL);
	virtual ~ANodeCrp();
	// From MSceneElem
	virtual void Render() override;
	virtual bool onMouseButton(TFvButton aButton, TFvButtonAction aAction, int aMods) override;
	// From MNode
	virtual MIface* MNode_getLif(const char *aName) override;
	// From MVrp
	virtual string MVrp_Uid() const override { return getUid<MVrp>();}
	virtual void SetEnv(MEnv* aEnv) override;
	virtual void SetModel(const string& aMdlUri) override;
	virtual string GetModelUri() const override;
	virtual void SetCrtlBinding(const string& aCtrUri) override {}
    protected:
	MViewMgr* getViewMgr();
	// From AVWidget
	virtual void Init() override;
    protected:
	// TODO to have shared font in visual env
	FTPixmapFont* mFont;
	MEnv* mBEnv; /*!< Binded env, not owned. TODO check if it is needed */
	MNode* mMdl; /*!< Binded model, not owned */
};

/** @brief Unit detail representation widget
 * */
class ANodeDrp : public AHLayout, public MVrp
{
    public:
	static const char* Type() { return "ANodeDrp";};
	ANodeDrp(const string& aType, const string& aName = string(), MEnv* aEnv = NULL);
	// From MNode
	virtual MIface* MNode_getLif(const char *aName) override;
	// From MUnit
	virtual bool resolveIfc(const string& aName, MIfReq::TIfReqCp* aReq) override;
	// From MSceneElem
	virtual void Render() override;
	// From MVrp
	virtual string MVrp_Uid() const override { return getUid<MVrp>();}
	virtual void SetEnv(MEnv* aEnv) override;
	virtual void SetModel(const string& aMdlUri) override;
	virtual string GetModelUri() const override;
	virtual void SetCrtlBinding(const string& aCtrUri) override;
	// From MDesSyncable
	virtual void update() override;
	virtual void confirm() override;
    protected:
	void OnInpModelUri();
	void ApplyModelUri();
	void GetModelUri(Sdata<string>& aData);
	// Local
	virtual void CreateRp();
	virtual void DestroyRp();
	void NotifyOnMdlUpdated();
    protected:
	MEnv* mBEnv; /*!< Binded env, not owned */
	MNode* mMdl; /*!< Binded model, not owned */
	string mCtrBnd; /*!< Binding to controller info: URI */
	AAdp::AdpIap mIapModelUri = AAdp::AdpIap(*this, [this]() {OnInpModelUri();}); /*!< Input access point: Model Uri */
	AAdp::AdpPap<string> mPapModelUri = AAdp::AdpPap<string>(*this, [this](Sdata<string>& aData) {GetModelUri(aData);}); /*!< Param access point: Model Uri */
	bool mModelUriChanged = true;
	string mModelUri;
};


/** @brief Agents Visual representation view manager
 * */
class AVrpView : public Unit, public MVrpView, public MViewMgr, public MAgent
{
    public:
	static const char* Type() { return "AVrpView";};
	AVrpView(const string& aType, const string& aName = string(), MEnv* aEnv = NULL);
	// From MNode
	virtual MIface* MNode_getLif(const char *aName) override;
	// From MAgent
	virtual string MAgent_Uid() const override { return getUid<MAgent>();}
	virtual MIface* MAgent_getLif(const char *aType) override;
	// From MVrpView
	virtual void OnCompSelected(const MVrp* aComp) override;
    protected:
	void CreateRp();
    protected:
	MEnv* mBEnv; /*!< Binded env, not owned */
	MNode* mMdl; /*!< Binded model, not owned */
	string mCtrBnd; /*!< Binding to controller info: URI */
};

#endif

