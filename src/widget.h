#ifndef __FAP3VIS_WIDGET_H
#define __FAP3VIS_WIDGET_H

#include <array>

#include <mifr.h>
#include <mprov.h>
#include "mwidget.h"
#include <mscel.h>
#include <des.h>
#include <dest.h>


#include <GL/glew.h>
#include <GL/gl.h>
#include <GLFW/glfw3.h>


class MWindow;
class FTPixmapFont;

/** @brief Widget base agent
 * Implements local providing (not completed) to support transition with agents context, ref ds_dee_sac
 * Uses embedded DES elements to create seamless DES, ref ds_dee
 * */
class AVWidget : public ADes, public MSceneElem, public MProvider,
    public MVStyleProvider, public MVStyleConsumer, public IDesEmbHost
{
    public:
	using TColor = struct {float r, g, b, a;};
    public:
	static const char* Type() { return "AVWidget";};
	AVWidget(const string& aType, const string& aName = string(), MEnv* aEnv = NULL);
	// From MSceneElem
	virtual string MSceneElem_Uid() const override { return getUid<MSceneElem>();}
	virtual void cleanSelem() override;
	virtual void Render() override;
	virtual void onRectInval(int aPblx, int aPbly, int aPtrx, int aPtry, float aDepth) override {}
	virtual void handleRectInval(int aPblx, int aPbly, int aPtrx, int aPtry, float aDepth) override {}
	virtual void onSeCursorPosition(double aX, double aY) override;
	virtual bool onMouseButton(TFvButton aButton, TFvButtonAction aAction, int aMods) override;
	virtual void getWndCoord(int aInpX, int aInpY, int& aOutX, int& aOutY) override;
	virtual float getDepth() override;
	virtual void getBgColor(float& r, float& g, float& b, float a) const override;
	virtual bool isChanged() const override;
	// From MNode
	virtual MIface* MNode_getLif(const char *aType) override;
	// From MUnit
	virtual void resolveIfc(const string& aName, MIfReq::TIfReqCp* aReq) override;
	// From MDesSyncable
	virtual MIface* MDesSyncable_getLif(const char *aType);
	virtual void update() override;
	virtual void confirm() override;
	// From MProvider
	virtual string MProvider_Uid() const override { return getUid<MSceneElem>(); }
	virtual MIface* MProvider_getLif(const char *aType) override { return nullptr;}
	virtual void MProvider_doDump(int aLevel, int aIdt, ostream& aOs) const override {}
	virtual const string& providerName() const override { return mProvName; }
	virtual MNode* createNode(const string& aType, const string& aName, MEnv* aEnv) override;
	virtual MNode* provGetNode(const string& aUri) override;
	virtual bool isProvided(const MNode* aElem) const override;
	virtual void setChromoRslArgs(const string& aRargs) override {}
	virtual void getChromoRslArgs(string& aRargs) override {}
	virtual MChromo* createChromo(const string& aRargs = string()) override { return nullptr;}
	virtual void getNodesInfo(vector<string>& aInfo) override {}
	virtual const string& modulesPath() const override { return mModPath;}
	virtual void setEnv(MEnv* aEnv) override;
	// From ADes.MAgent
	virtual MIface* MAgent_getLif(const char *aType) override;
	// From ADes.MObserver
	virtual void onObsContentChanged(MObservable* aObl, const MContent* aCont) override;
	// From IDesEmbHost
	virtual void registerIb(DesEIbb* aIap) override;
	virtual void registerOst(DesEOstb* aItem) override;
	virtual void logEmb(const TLog& aRec) override { Log(aRec);}
	// From MVStyleProvider
	virtual string MVStyleProvider_Uid() const override { return getUid<MVStyleProvider>(); }
	virtual bool getVStyleParam(const string& aId, string& aParam) override;
	// From MVStyleConsumer
	virtual string MVStyleConsumer_Uid() const override { return getUid<MVStyleConsumer>(); }
	// From ADes.MOwner
	virtual MIface* MOwner_getLif(const char *aType) override;
    protected:
	virtual void Init();
	/** @brief Handles cursor position change
	 * @param[in] aX, aY  Pos widget coordinates
	 * */
	virtual void onWdgCursorPos(int aX, int aY);

	/** @brief Indiaction that change is critical
	 * */
	virtual bool isChangeCrit() const;
	static void DrawLine(float x1, float y1, float x2, float y2, float depth);
	void mutateNode(MNode* aNode, const TMut& aMut);
    protected:
	void fillOutOverlayingBg();
	bool getLocalStyleParam(const string& aId, string& aParam) const;
	template <typename T> bool getStateSData(const string& aPsName, const string& aPName, T& aData) {
	    MNode* ps = ahostGetNode(aPsName);
	    MNode* state = ps ? ps->getNode(aPName) : nullptr;
	    return state ?  GetSData(state, aData) : false;
	}
	inline bool getLStyleParam(const string& aId, bool& aParam) const {
	    string data; bool res = getLocalStyleParam(aId, data); aParam = (data == "y"); return res;
	}
	template <typename T> bool getVisPar(const string& aId, T& aPar) {
	    return getStateSData(KUri_LocPars, aId, aPar);
	}
	int GetParInt(const string& aUri);
	void GetAlc(int& aX, int& aY, int& aW, int& aH);
	void getAlcWndCoord(int& aLx, int& aTy, int& aRx, int& aBy);
	MSceneElem* getOwnerSelem();
	static void CheckGlErrors();
	void GetCursorPosition(double& aX, double& aY);
	bool IsInnerWidgetPos(double aX, double aY);
	int WndX(int aX);
	int WndY(int aY);
	MWindow* Wnd();
	static string colorCntUri(const string& aType, const string& aPart);
	bool getHostContent(const GUri& aCuri, string& aRes) const;
	MUnit* getHostOwnerUnit();
	bool isOverlayed();
	// Utils
	bool rifDesIobs(DesEIbb& aIap, MIfReq::TIfReqCp* aReq);
	bool rifDesOsts(DesEOstb& aItem, MIfReq::TIfReqCp* aReq);
	// Internal transitions
	virtual void updateFont();
	virtual void updateRqsW() {}
    protected:
	string mProvName;
	string mModPath;
	bool mIsInitialised = false;
	GLuint mProgram;
	GLint mMvpLocation;
	TColor mBgColor;
	TColor mFgColor;
	vector<DesEIbb*> mIbs; /*!< Inputs buffered registry */
	vector<DesEOstb*> mOsts; /*!< Output states buffered registry */
	DesEIbs<string> mIbFontPath;   //!< Input "Font Paths"
	DesEIbs<string> mIbText;   //!< Input "Text"
	DesEOsts<int> mOstRqsW, mOstRqsH;   //!< Outputs "Rqs"
	DesEOst<DGuri> mOstLbpUri;   //!< Outputs "Mouse left button pressed"
	FTPixmapFont* mFont;
	int mPblx, mPbly, mPtrx, mPtry; //!< Previous iteration wnd coord
	bool mChanged;                  //!< Indication that widget is changed
	static const string KCnt_FontPath;
	static const string KUri_AlcX;
	static const string KUri_AlcY;
	static const string KUri_AlcW;
	static const string KUri_AlcH;
	static const int K_Padding;
	static const string KUri_LocPars;
	static const string KVp_Border;
};


/** @brief Widget transition base
 * */
class TrWBase: public TrBase, public MDVarGet
{
    public:
	static const char* Type() { return "TrWBase";};
	TrWBase(AVWidget* aHost, const string& aType, const string& aName = string(), MEnv* aEnv = NULL);
	// From MNode
	virtual MIface* MNode_getLif(const char *aType) override;
	// From MDVarGet
	virtual string MDVarGet_Uid() const override { return getUid<MDVarGet>();}
    protected:
	AVWidget* mHost;
};

#if 0
class TrWFont: public TrBase, public MDVarGet, public MDtGet<Sdata<string>>
{
    using Tdata = Sdata<string>;
    public:
	enum { EInpFont, EInpParent };
    public:
	static const char* Type() { return "TrWFont";};
	TrWFont(const string& aType, const string& aName = string(), MEnv* aEnv = NULL);
	virtual string GetInpUri(int aId) const = 0;
	// From MNode
	virtual MIface* MNode_getLif(const char *aType) override;
	// From MDVarGet
	virtual string MDVarGet_Uid() const override { return getUid<MDVarGet>();}
	virtual MIface* DoGetDObj(const char *aName) override;
	virtual string VarGetIfid() const override;
	// From MDtGet
	virtual void DtGet(Tdata& aData) override;
    protected:
	Tdata mRes;  /*<! Cached result */
};
#endif




#endif // __FAP2VIS_WIDGET_H
