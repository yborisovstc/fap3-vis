#ifndef __FAP3VIS_WIDGET_H
#define __FAP3VIS_WIDGET_H

#include <mifr.h>

#include "mwidget.h"
#include <mscel.h>

#include <array>
#include <des.h>


#include <GL/glew.h>
#include <GL/gl.h>
#include <GLFW/glfw3.h>


class MWindow;

/** @brief Widget base agent
 * TODO to create for widget specific DES, that doesn't update owned MDesSyncable but just
 * does some internal work. Note, ADes (sysem embedded DES agent) cannot be used for that.
 * */
class AVWidget : public ADes, public MSceneElem, public MVCcomp
{
    public:
	using TColor = struct {float r, g, b, a;};
    public:
	static const char* Type() { return "AVWidget";};
	AVWidget(const string& aName = string(), MEnv* aEnv = NULL);
	// From MSceneElem
	virtual string MSceneElem_Uid() const override { return getUid<MSceneElem>();}
	virtual void Render() override;
	virtual void onSeCursorPosition(double aX, double aY) override;
	virtual bool onMouseButton(TFvButton aButton, TFvButtonAction aAction, int aMods) override;
	virtual void getWndCoord(int aInpX, int aInpY, int& aOutX, int& aOutY) override;
	// From MNode
	virtual MIface* MNode_getLif(const char *aType) override;
	// From MUnit
	virtual bool resolveIface(const string& aName, MIfReq::TIfReqCp* aReq) override;
	// From MDesSyncable
	virtual void update() override;
	virtual void confirm() override;
	// From MVCcomp
	virtual string MVCcomp_Uid() const override {return getUid<MVCcomp>();}
	// From ADes.MAgent
	virtual MIface* MAgent_getLif(const char *aType) override;
	virtual void onHostContentChanged(const MContent* aCont) override;
    protected:
	virtual void Init();
	/** @brief Handles cursor position change
	 * @param[in] aX, aY  Pos widget coordinates
	 * */
	virtual void onWdgCursorPos(int aX, int aY);
	static void DrawLine(float x1, float y1, float x2, float y2);
    protected:
	int GetParInt(const string& aUri);
	static void CheckGlErrors();
	void GetCursorPosition(double& aX, double& aY);
	bool IsInnerWidgetPos(double aX, double aY);
	int WndX(int aX);
	int WndY(int aY);
	MWindow* Wnd();
	static string colorCntUri(const string& aType, const string& aPart);
	bool getHostContent(const GUri& aCuri, string& aRes) const;
    protected:
	bool mIsInitialised = false;
	GLuint mProgram;
	GLint mMvpLocation;
	TColor mBgColor;
	TColor mFgColor;
	static const string KCnt_FontPath;
	static const string KUri_AlcX;
	static const string KUri_AlcY;
	static const string KUri_AlcW;
	static const string KUri_AlcH;
};

#endif // __FAP2VIS_WIDGET_H
