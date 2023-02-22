#ifndef __FAP3VIS_ENV_H
#define __FAP3VIS_ENV_H

#include <unit.h>
#include <syst.h>
#include <des.h>
#include <mdata.h>
#include <mvisenv.h>
#include <mwindow.h>


using namespace std;

class GLFWwindow;

/** @brief Visual environment
 * */
class AVisEnv:  public Unit
{
    public:
	static const char* Type() { return "AVisEnv";};
	AVisEnv(const string& aType, const string& aName, MEnv* aEnv);
	virtual ~AVisEnv();
	// From MNode
	virtual MIface* MNode_getLif(const char *aType) override;
	// From MContentOwner
	virtual void onContentChanged(const MContent* aCont) override;
    protected:
	void Construct();
	static const string mCont_Init;
};


/** @brief Top window
 * */
class GWindow: public Des, public MWindow
{
    public:
	static const char* Type() { return "GWindow";};
	GWindow(const string& aType, const string& aName, MEnv* aEnv);
	// From MNode
	virtual MIface* MNode_getLif(const char *aType) override;
	// From MContentOwner
	virtual void onContentChanged(const MContent* aCont) override;
	// From MWindow
	virtual string MWindow_Uid() const override { return getUid<MWindow>();}
	virtual void GetCursorPos(double& aX, double& aY) override;
	virtual void GetFbSize(int* aW, int* aH) const override;
	// From MDesSyncable
	virtual void update() override;
	virtual void confirm() override;
    protected:
	void Init();
	void Construct();
	void Render();
	const GLFWwindow* RawWindow() const { return mWindow;}
	static void onWindowSizeChanged (GLFWwindow *aWnd, int aW, int aH);
	static void onWindowClosed(GLFWwindow *aWnd);
	static void onCursorPosition(GLFWwindow *aWnd, double aX, double aY);
	static void onMouseButton(GLFWwindow *aWnd, int aButton, int aAction, int aMods);
	void onWindowClosed();
	/** @brief Handles cursor position
	 * @param[in] aX, aY screen coordinates relative to the top-left corner of the window
	 * */
	void onCursorPosition(double aX, double aY);
	/** @brief Handles mouse button events
	 * @param[in] aButton - button Id
	 * @param[in] aAction - action: GLFW_PRESS or GLFW_RELEASE
	 * @param[in] aMods - modes
	 * */
	void onMouseButton(TFvButton aButton, TFvButtonAction aAction, int aMods);
	static void RegisterInstance(GWindow* aInst);
	static GWindow* FindInstance(GLFWwindow* aWnd);
	//<! Window width native settier iface
	MDVarSet* StWidth();
	int GetParInt(const string& aUri);
    protected:
	bool mWndInit;
	GLFWwindow* mWindow;
	// TODO the instances mechanism seems is used just for assosiating GLFW window instance
	// with AGWindow instance. Why don't use glfwSetWindowUserPointer for that?
	static vector<GWindow*> mInstances; //!< Register of instances
};


/** @brief Launcher agent
 * */
class VDesLauncher: public DesLauncher
{
    public:
	static const char* Type() { return "VDesLauncher";};
	VDesLauncher(const string& aType, const string& aName = string(), MEnv* aEnv = NULL);
	// From DesLauncher
	virtual void OnIdle() override;
};

#endif

