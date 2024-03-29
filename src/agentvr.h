
#ifndef __FAP3VIS_AGENTVR_H
#define __FAP3VIS_AGENTVR_H

#include "widget.h"
#include "container.h"
#include "hlayout.h"
#include "magentvr.h"
#include "mmntp.h"


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
	virtual void SetModelMntp(MNode* aMdlMntp) override;
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
	MNode* mMdlMntp; /*!< Binded model mountpoint, not owned */
	MNode* mMdl; /*!< Binded model, not owned */
};

/** @brief Node compact representation widget ver 2
 * */
class ANodeCrp2 : public AAgentVr, public MVrp
{
    public:
 	/** @brief Input access point "MAG base" */
	class IapMagb: public MDesInpObserver {
	    public:
		IapMagb(ANodeCrp2* aHost): mHost(aHost) {}
		virtual void onInpUpdated() override { mHost->onMagbInpUpdated();}
		virtual string MDesInpObserver_Uid() const override {return MDesInpObserver::Type();}
		virtual void MDesInpObserver_doDump(int aLevel, int aIdt, ostream& aOs) const override {}
	    public:
		ANodeCrp2* mHost;
	};
	/** @brief MAG observer */
	class MagObs : public MObserver {
	    public:
		MagObs(ANodeCrp2* aHost): mHost(aHost), mOcp(this) {}
		// From MObserver
		virtual string MObserver_Uid() const {return MObserver::Type();}
		virtual MIface* MObserver_getLif(const char *aName) override { return nullptr;}
		virtual void onObsOwnedAttached(MObservable* aObl, MOwned* aOwned) override {
		    mHost->onMagOwnedAttached(aObl, aOwned);
		}
		virtual void onObsOwnedDetached(MObservable* aObl, MOwned* aOwned) override {
		    mHost->onMagOwnedDetached(aObl, aOwned);
		}
		virtual void onObsContentChanged(MObservable* aObl, const MContent* aCont) override {
		    mHost->onMagContentChanged(aObl, aCont);
		}
		virtual void onObsChanged(MObservable* aObl) override {
		    mHost->onMagChanged(aObl);
		}
	    public:
		TObserverCp mOcp;               /*!< Observer connpoint */
	    private:
		ANodeCrp2* mHost;
	};

    public:
	static const char* Type() { return "ANodeCrp2";};
	ANodeCrp2(const string& aType, const string& aName = string(), MEnv* aEnv = NULL);
	virtual ~ANodeCrp2();
	// From MSceneElem
	virtual void Render() override;
	virtual bool onMouseButton(TFvButton aButton, TFvButtonAction aAction, int aMods) override;
	// From MNode
	virtual MIface* MNode_getLif(const char *aName) override;
	// From MVrp
	virtual string MVrp_Uid() const override { return getUid<MVrp>();}
	virtual void SetEnv(MEnv* aEnv) override;
	virtual void SetModelMntp(MNode* aMdlMntp) override;
	virtual void SetModel(const string& aMdlUri) override;
	virtual string GetModelUri() const override;
	virtual void SetCrtlBinding(const string& aCtrUri) override {}
	// From MUnit
	virtual void resolveIfc(const string& aName, MIfReq::TIfReqCp* aReq) override;
	// From MDesSyncable
	virtual void update() override;
    protected:
	void onMagbInpUpdated();
	bool ApplyMagBase();
	bool UpdateMagBase(MNode* aMagBase);
	void UpdateMag();
	bool UpdateMag(MNode* aMag);
	void OnMagUpdated();
	virtual void onMagOwnedAttached(MObservable* aObl, MOwned* aOwned) {}
	virtual void onMagOwnedDetached(MObservable* aObl, MOwned* aOwned) {}
	virtual void onMagContentChanged(MObservable* aObl, const MContent* aCont) {}
	virtual void onMagChanged(MObservable* aObl) {}
	MViewMgr* getViewMgr();
	// From AVWidget
	virtual void Init() override;
    protected:
	// TODO to have shared font in visual env
	FTPixmapFont* mFont;
	MEnv* mBEnv; /*!< Binded env, not owned. TODO check if it is needed */
	MNode* mMdlMntp; /*!< Binded model mountpoint, not owned */
	MNode* mMdl; /*!< Binded model, not owned */
	IapMagb mIapMagb;  /*! IAP MAG base */
	bool mMdlBaseUpdated;
	MagObs mMagObs; /*!< Managed agent observer */
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
	virtual void resolveIfc(const string& aName, MIfReq::TIfReqCp* aReq) override;
	// From MSceneElem
	virtual void Render() override;
	// From MVrp
	virtual string MVrp_Uid() const override { return getUid<MVrp>();}
	virtual void SetEnv(MEnv* aEnv) override;
	virtual void SetModelMntp(MNode* aMdlMntp) override;
	virtual void SetModel(const string& aMdlUri) override;
	virtual string GetModelUri() const override;
	virtual void SetCrtlBinding(const string& aCtrUri) override;
	// From MDesSyncable
	virtual void update() override;
	virtual void confirm() override;
    protected:
	void OnInpModelUri();
	void ApplyModelUri();
	bool ApplyModelMntp();
	void GetModelUri(Sdata<string>& aData);
	// Local
	virtual void CreateRp();
	virtual void DestroyRp();
	void NotifyOnMdlUpdated();
    protected:
	MEnv* mBEnv; /*!< Binded env, not owned */
	MNode* mMdlMntp; /*!< Binded model mountpoint, not owned */
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
	using TAgtCp = NCpOnp<MAgent, MAhost>;  /*!< Agent conn point */
    public:
	static const char* Type() { return "AVrpView";};
	AVrpView(const string& aType, const string& aName = string(), MEnv* aEnv = NULL);
	// From MNode
	virtual MIface* MNode_getLif(const char *aName) override;
	// From MAgent
	virtual string MAgent_Uid() const override { return getUid<MAgent>();}
	virtual MIface* MAgent_getLif(const char *aType) override;
	// From MVrpView
	virtual string MVrpView_Uid() const override { return getUid<MVrpView>();}
	virtual void OnCompSelected(const MVrp* aComp) override;
	// From MViewMgr
	virtual string MViewMgr_Uid() const override { return getUid<MViewMgr>();}
	virtual MIface *MViewMgr_getLif(const char *aType) override;
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

