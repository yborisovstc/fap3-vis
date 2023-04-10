
#include <iostream>

#include "visenv.h"
#include <mdata.h>
#include <node.h>
#include <prof.h>
#include <functional>
#include "mdata.h"
#include "mscene.h"

#include "GL/glew.h"
#include "GL/gl.h"
#include <GLFW/glfw3.h>

using namespace std;

const string AVisEnv::mCont_Init = "Init";

/** @brief Init data for profiler duration indicator */
const PindCluster<PindDurStat>::Idata KVisPindDurStatIdata = {
    "Vis duration stat",
    {
	{PVisEvents::EDurStat_Confirm, "VIS_CONF", 80000, false},
	{PVisEvents::EDurStat_Render, "VIS_REND", 80000, false},
    }
};

AVisEnv::AVisEnv(const string& aType, const string& aName, MEnv* aEnv): Unit(aType, aName, aEnv)
{
#ifdef PROFILING_ENABLED
    if (aEnv->profiler()) {
	aEnv->profiler()->addPind<PindCluster<PindDurStat>>(KVisPindDurStatIdata);
    }
#endif
    // Don't construct native agent here. Only heirs needs to be constructed fully.
    //Construct();
}

void AVisEnv::Construct()
{
    if (!glfwInit()) {
	// TODO handle error
	Log(EErr, TLog(this) + "Failed to init GLTF");
    }
}

AVisEnv::~AVisEnv()
{
    glfwTerminate();
}

MIface* AVisEnv::MNode_getLif(const char *aType)
{
    MIface* res = nullptr;
    res = Unit::MNode_getLif(aType);
    return res;
}

void AVisEnv::onContentChanged(const MContent* aCont)
{
    if (aCont->contName() == mCont_Init) {
	Construct();
    }
    Unit::onContentChanged(aCont);
}


// Top window

const string KWndCnt_Init = "Init";
const string KWndCnt_Init_Val = "Yes";
const string KUri_Width = "Width";
const string KUri_Height = "Height";

vector<GWindow*> GWindow::mInstances = {}; //!< Register of instances

GWindow::GWindow(const string& aType, const string& aName, MEnv* aEnv): Des(aType, aName, aEnv), mWndInit(false), mWindow(NULL)
{
}

MIface* GWindow::MNode_getLif(const char *aType)
{
    MIface* res = nullptr;
    if (res = checkLif<MWindow>(aType));
    else res = Des::MNode_getLif(aType);
    return res;
}

// TODO return Sdata, handle the data validity
int GWindow::GetParInt(const string& aUri)
{
    int res = 0;
    MNode* pu = getNode(aUri);
    MDVarGet* pvg = pu->lIf(pvg);
    if (pvg) {
	const Sdata<int>* psi = pvg->DtGet(psi);
	res = psi ? psi->mData : res;
    }
    return res;
}

void GWindow::Construct()
{
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 2);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 0);

    int width = GetParInt(KUri_Width);
    int height = GetParInt(KUri_Height);
    mWindow = glfwCreateWindow(width, height, "My Title", NULL, NULL);
    if (mWindow) {
	glfwSetWindowUserPointer(mWindow, this);
	glfwSetWindowCloseCallback(mWindow, onWindowClosed);
	glfwSetCursorPosCallback(mWindow, onCursorPosition);
	glfwSetMouseButtonCallback(mWindow, onMouseButton);
	glfwMakeContextCurrent(mWindow);
	//gladLoadGL(glfwGetProcAddress);
	// TODO  YB!! This interval affects window refreshing. With value 1 the unitvr frame is rendered only partially
	// To investigate
	glfwSwapInterval(2); //YB!!
	glewInit();
	// Register the window instance
	RegisterInstance(this);
	// Set viewport
	glViewport(0, 0, width, height);
    } else {
	// Window or context creation failed
	Log(EErr, TLog(this) + "Failed creating GLTF window");
    }
}

void GWindow::RegisterInstance(GWindow* aInst)
{
    mInstances.push_back(aInst);
}

GWindow* GWindow::FindInstance(GLFWwindow* aWnd)
{
    GWindow* res = NULL;
    for (auto inst: mInstances) {
	if (inst->RawWindow() == aWnd) {
	    res = inst;
	    break;
	}
    }
    return res;
}

MDVarSet* GWindow::StWidth()
{
    MDVarSet* res = NULL;
    MNode* widthu = getNode(KUri_Width);
    if (widthu) {
	res = widthu->lIf(res);
    }
    return res;
}

void GWindow::onWindowSizeChanged (GLFWwindow *aWnd, int aW, int aH)
{
    GWindow* wnd = FindInstance(aWnd);
    if (wnd) {
	MDVarSet* widthdv = wnd->StWidth();
	if (widthdv) {
	    widthdv->VDtSet(Sdata<int>(aW));
	}
    }
}

void GWindow::onWindowClosed(GLFWwindow *aWnd)
{
    GWindow* wnd = reinterpret_cast<GWindow*>(glfwGetWindowUserPointer(aWnd));
    if (wnd != NULL) {
	wnd->onWindowClosed();
    }
}

void GWindow::onCursorPosition(GLFWwindow *aWnd, double aX, double aY)
{
    GWindow* wnd = reinterpret_cast<GWindow*>(glfwGetWindowUserPointer(aWnd));
    if (wnd != NULL) {
	wnd->onCursorPosition(aX, aY);
    }
}

void GWindow::onMouseButton(GLFWwindow *aWnd, int aButton, int aAction, int aMods)
{
    GWindow* wnd = reinterpret_cast<GWindow*>(glfwGetWindowUserPointer(aWnd));
    if (wnd != NULL) {
	TFvButton btn = aButton == GLFW_MOUSE_BUTTON_RIGHT ? EFvBtnRight : EFvBtnLeft;
	TFvButtonAction act = aAction == GLFW_PRESS ? EFvBtnActPress : EFvBtnActRelease;
	wnd->onMouseButton(btn, act, aMods);
    }
}

void GWindow::onWindowClosed()
{
    // Notify of closing
    //OnError(this);
    // TODO This is tmp solution design the proper one
    mEnv->StopSystem();
}

void GWindow::onCursorPosition(double aX, double aY)
{
    //cout << "Cursor, X: " << aX << ", Y: " << aY << endl;

    MNode* scene = getNode("Scene");
    MUnit* sceneu = scene ? scene->lIf(sceneu) : nullptr;
    if (sceneu) {
	MScene* mscene = sceneu->getSif(mscene);
	if (mscene) {
	    int width, height;
	    glfwGetWindowSize(mWindow, &width, &height);
	    mscene->onCursorPosition(aX, height - aY);
	}
    } else {
	Log(EErr, TLog(this) + "Missing scene");
    }
}

void GWindow::onMouseButton(TFvButton aButton, TFvButtonAction aAction, int aMods)
{
    //cout << "Window, onMouseButton" << endl;

    MNode* scene = getNode("Scene");
    MUnit* sceneu = scene ? scene->lIf(sceneu) : nullptr;
    if (sceneu) {
	MScene* mscene = sceneu->getSif(mscene);
	if (mscene) {
	    mscene->onMouseButton(aButton, aAction, aMods);
	}
    } else {
	Log(EErr, TLog(this) + "Missing scene");
    }
}

// TODO Why we use rendering hier separate from DES sync hier?
void GWindow::Render()
{
    LOGN(EDbg, "Render");
    PFL_DUR_STAT_START(PVisEvents::EDurStat_Render);
    MNode* scene = getNode("Scene");
    MUnit* sceneu = scene ? scene->lIf(sceneu) : nullptr;
    if (sceneu) {
	MScene* mscene = sceneu->getSif(mscene);
	if (mscene) {
	    mscene->RenderScene();
	}
    } else {
	Log(EErr, TLog(this) + "Missing scene");
    }
    PFL_DUR_STAT_REC(PVisEvents::EDurStat_Render);
}

void GWindow::update()
{
    //Logger()->Write(EInfo, this, "Update");
    Des::update();
}

void GWindow::confirm()
{
    PFL_DUR_STAT_START(PVisEvents::EDurStat_Confirm);
    //Logger()->Write(EInfo, this, "Confirm");
    if (!mWndInit) {
	Construct();
	glfwSetWindowUserPointer(mWindow, this);
	glfwSetWindowSizeCallback(mWindow, onWindowSizeChanged);
	mWndInit = true;
    }
    Des::confirm();
    Render();
    glfwSwapBuffers(mWindow);
    glfwPollEvents();
    PFL_DUR_STAT_REC(PVisEvents::EDurStat_Confirm);
}

void GWindow::onContentChanged(const MContent* aCont)
{
    if (aCont->contName() == KWndCnt_Init) {
	//Construct();
    }
    return Des::onContentChanged(aCont);
}

void GWindow::GetCursorPos(double& aX, double& aY)
{
    double y = 0;
    glfwGetCursorPos(mWindow, &aX, &y);
    int width, height;
    glfwGetWindowSize(mWindow, &width, &height);
    aY = height - y;
}

void GWindow::GetFbSize(int* aW, int* aH) const
{
    if (mWindow) {
	glfwGetWindowSize(mWindow, aW, aH);
    } else {
	*aW = -1; *aH = -1;
    }
}


/// VDesLauncher

VDesLauncher::VDesLauncher(const string& aType, const string& aName, MEnv* aEnv): DesLauncher(aType, aName, aEnv)
{
}

void VDesLauncher::OnIdle()
{
    glfwPollEvents();
}

