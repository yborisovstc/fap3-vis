
#include <iostream>

#include "visenv.h"
#include <mdata.h>
#include <node.h>
#include <prof.h>
#include <functional>
#include "mdata.h"
#include "mscene.h"
#include <visprof_id.h>

#include "GL/glew.h"
#include "GL/gl.h"
#include <GLFW/glfw3.h>
#include <FTGL/ftgl.h>

using namespace std;


static const struct
{
    float x, y;
    float r, g, b;
} vertices[3] =
{
    { -0.6f, -0.4f, 1.f, 0.f, 0.f },
    {  0.6f, -0.4f, 0.f, 1.f, 0.f },
    {   0.f,  0.6f, 0.f, 0.f, 1.f }
};

static const char* vertex_shader_text =
"#version 110\n"
"uniform mat4 MVP;\n"
"attribute vec3 vCol;\n"
"attribute vec2 vPos;\n"
"varying vec3 color;\n"
"void main()\n"
"{\n"
"    gl_Position = MVP * vec4(vPos, 0.0, 1.0);\n"
"    color = vCol;\n"
"}\n";

static const char* fragment_shader_text =
"#version 110\n"
"varying vec3 color;\n"
"void main()\n"
"{\n"
"    gl_FragColor = vec4(color, 1.0);\n"
"}\n";



const string AVisEnv::mCont_Init = "Init";

static GLuint vertex_buffer, vertex_shader, fragment_shader;
static GLint vpos_location, vcol_location;

/** @brief Init data for profiler duration indicator */
const PindCluster<PindDurStat>::Idata KVisPindDurStatIdata = {
    "Vis duration stat",
    {
	{PVisEvents::EDurStat_Confirm, "VIS_CONF", 80000, false},
	{PVisEvents::EDurStat_Render, "VIS_REND", 80000, false},
	{PVisEvents::EDurStat_WdgCnf, "WDG_CONF", 80000, false},
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
    if (glfwInit()) {
	if (!mIsInitialised) {
	    //Init();
	    mIsInitialised = true;
	}
    } else {
	// TODO handle error
	Log(EErr, TLog(this) + "Failed to init GLTF");
    }
}

void AVisEnv::CheckGlErrors()
{
    // check for errors
    const GLenum errCode = glGetError();
    if (errCode != GL_NO_ERROR){
	const GLubyte *errString;
	errString=gluErrorString(errCode);
	printf("error: %s\n", errString);
    }
}

void AVisEnv::Init()
{
    glGenBuffers(1, &vertex_buffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertex_buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

    vertex_shader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertex_shader, 1, &vertex_shader_text, NULL);
    glCompileShader(vertex_shader);
    CheckGlErrors();

    fragment_shader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragment_shader, 1, &fragment_shader_text, NULL);
    glCompileShader(fragment_shader);

    mProgram = glCreateProgram();
    glAttachShader(mProgram, vertex_shader);
    glAttachShader(mProgram, fragment_shader);
    glLinkProgram(mProgram);
    CheckGlErrors();

    mMvpLocation = glGetUniformLocation(mProgram, "MVP");
    vpos_location = glGetAttribLocation(mProgram, "vPos");
    vcol_location = glGetAttribLocation(mProgram, "vCol");
    glEnableVertexAttribArray(vpos_location);
    glVertexAttribPointer(vpos_location, 2, GL_FLOAT, GL_FALSE,
	    sizeof(vertices[0]), (void*) 0);
    glEnableVertexAttribArray(vcol_location);
    glVertexAttribPointer(vcol_location, 3, GL_FLOAT, GL_FALSE,
	    sizeof(vertices[0]), (void*) (sizeof(float) * 2));
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
	// GL context init
	InitGlCtx();
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
    //if (false) {
	Construct();
	glfwSetWindowUserPointer(mWindow, this);
	glfwSetWindowSizeCallback(mWindow, onWindowSizeChanged);
	mWndInit = true;
    }
    Des::confirm();
    if (mCnt++ == 0) {
	mCnt = 0;
	if (mWndInit) {
	    Render();
	    glfwSwapBuffers(mWindow);
	}
    }
    if (mWndInit) {
    glfwPollEvents();
    }
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

void GWindow::InitGlCtx()
{
    glGenBuffers(1, &vertex_buffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertex_buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

    vertex_shader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertex_shader, 1, &vertex_shader_text, NULL);
    glCompileShader(vertex_shader);
    CheckGlErrors();

    fragment_shader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragment_shader, 1, &fragment_shader_text, NULL);
    glCompileShader(fragment_shader);

    mProgram = glCreateProgram();
    glAttachShader(mProgram, vertex_shader);
    glAttachShader(mProgram, fragment_shader);
    glLinkProgram(mProgram);
    CheckGlErrors();

    mMvpLocation = glGetUniformLocation(mProgram, "MVP");
    vpos_location = glGetAttribLocation(mProgram, "vPos");
    vcol_location = glGetAttribLocation(mProgram, "vCol");
    glEnableVertexAttribArray(vpos_location);
    glVertexAttribPointer(vpos_location, 2, GL_FLOAT, GL_FALSE,
	    sizeof(vertices[0]), (void*) 0);
    glEnableVertexAttribArray(vcol_location);
    glVertexAttribPointer(vcol_location, 3, GL_FLOAT, GL_FALSE,
	    sizeof(vertices[0]), (void*) (sizeof(float) * 2));

}

void GWindow::CheckGlErrors()
{
    // check for errors
    const GLenum errCode = glGetError();
    if (errCode != GL_NO_ERROR){
	const GLubyte *errString;
	errString=gluErrorString(errCode);
	printf("error: %s\n", errString);
    }
}


/// VDesLauncher

VDesLauncher::VDesLauncher(const string& aType, const string& aName, MEnv* aEnv): DesLauncher(aType, aName, aEnv)
{
}

void VDesLauncher::OnIdle()
{
    DesLauncher::OnIdle();
    glfwPollEvents();
}

