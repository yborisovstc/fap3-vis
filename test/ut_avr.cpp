#include <stdlib.h>
//#include "../src/mwidget.h"
#include <sys/types.h>
#include <signal.h>
#include <iostream>
#include <fstream>
#include <env.h>
#include <elem.h>
#include <mdes.h>
#include <mdata.h>
#include <prof.h>
#include "../src/visprov.h"
#include "../src/mvisenv.h"
#include "../src/mwindow.h"
#include "../src/mscel.h"

#include <cppunit/extensions/HelperMacros.h>

#include <GLFW/glfw3.h>

/*
 * To run particular test suite: ./ut-fap2vis-lib [test_suite_name] for instance ./ut-fap2vis-lib Ut_ExecMagt
 */


/** @brief Agents visual representatin UT
 * */
class Ut_avr : public CPPUNIT_NS::TestFixture
{
    CPPUNIT_TEST_SUITE(Ut_avr);
    //CPPUNIT_TEST(test_Node);
    ///CPPUNIT_TEST(test_NodeDrp);
    //    CPPUNIT_TEST(test_NodeDrp_Asr_1);
    //    CPPUNIT_TEST(test_VrCtrl);
    CPPUNIT_TEST(test_SystDrp);
    //CPPUNIT_TEST(test_NodeCrp_2);
    //CPPUNIT_TEST(test_VertDrp);
    //CPPUNIT_TEST(test_VertDrp_2);
    //CPPUNIT_TEST(test_VertDrp_3);
    CPPUNIT_TEST_SUITE_END();
    public:
    virtual void setUp();
    virtual void tearDown();
    private:
    MNode* constructSystem(const string& aFname);
    private:
    void test_Node();
    void test_NodeDrp();
    void test_NodeDrp_Asr_1();
    void test_VrCtrl();
    void test_VertDrp();
    void test_VertDrp_2();
    void test_VertDrp_3();
    void test_SystDrp();
    void test_NodeCrp_2();
    private:
    Env* mEnv;
};

CPPUNIT_TEST_SUITE_REGISTRATION( Ut_avr );
CPPUNIT_TEST_SUITE_NAMED_REGISTRATION(Ut_avr, "Ut_avr");

static MDesSyncable* sSync;

MNode* Ut_avr::constructSystem(const string& aSpecn)
{
    string ext = "chs";
    string spec = aSpecn + string(".") + "chs";
    string log = aSpecn + "_" + ext + ".log";
    mEnv = new Env(spec, log);
    CPPUNIT_ASSERT_MESSAGE("Fail to create Env", mEnv != 0);
    mEnv->ImpsMgr()->ResetImportsPaths();
    mEnv->ImpsMgr()->AddImportsPaths("../modules");
    mEnv->ImpsMgr()->AddImportsPaths("../../fap3/modules");
    mEnv->constructSystem();
    MNode* root = mEnv->Root();
    MElem* eroot = root ? root->lIf(eroot) : nullptr;
    CPPUNIT_ASSERT_MESSAGE("Fail to get root", root && eroot);
    return root;
}

void Ut_avr::setUp()
{
    sSync = NULL;
}

void Ut_avr::tearDown()
{
    CPPUNIT_ASSERT_EQUAL_MESSAGE("tearDown", 0, 0);
}

void Ut_avr::test_Node()
{
    printf("\n === Node CRP test\n");
    const string specn("ut_avr_node");
    string ext = "chs";
    string spec = specn + string(".") + ext;
    string log = specn + "_" + ext + ".log";
    mEnv = new Env(spec, log);
    CPPUNIT_ASSERT_MESSAGE("Fail to create Env", mEnv != 0);
    //mEnv->ImpsMgr()->ResetImportsPaths();
    mEnv->ImpsMgr()->AddImportsPaths("../modules");
    VisProv* visprov = new VisProv("VisProv", mEnv);
    mEnv->addProvider(visprov);
    mEnv->constructSystem();
    MNode* root = mEnv->Root();
    CPPUNIT_ASSERT_MESSAGE("Fail to get root", root != 0);

    MNode* visenv = root->getNode("Test.Env.VisEnvAgt");
    CPPUNIT_ASSERT_MESSAGE("Fail to get env agent node", visenv != 0);

    bool res = mEnv->RunSystem(100);
    CPPUNIT_ASSERT_MESSAGE("Failed running system", res);

    delete mEnv;
}

void Ut_avr::test_NodeDrp()
{
    printf("\n === Node DRP test 1\n");
    MNode* root = constructSystem("ut_avr_node_drp");
    // Run
    bool run = mEnv->RunSystem(200, 20);
    CPPUNIT_ASSERT_MESSAGE("Fail to run system", run);

    delete mEnv;
}

void Ut_avr::test_VertDrp()
{
    printf("\n === Vertex DRP test 1\n");
    MNode* root = constructSystem("ut_avr_vert_drp");
    // Run
    bool run = mEnv->RunSystem(200, 100);
    CPPUNIT_ASSERT_MESSAGE("Fail to run system", run);

    delete mEnv;
}

void Ut_avr::test_VertDrp_2()
{
    printf("\n === Vertex DRP test 2 - edges\n");
    MNode* root = constructSystem("ut_avr_vert_drp_2");
    // Run
    //bool run = mEnv->RunSystem(200, 100);
    PFLC_INIT("ut_avr_vert_drp_2_vis");
    bool run = mEnv->RunSystem(200, 50);
    CPPUNIT_ASSERT_MESSAGE("Fail to run system", run);
    PFL_SAVE(); // Metrics for Env Profiler
    PFLC_SAVE();// Metrics for Common Profiler

    delete mEnv;
}

void Ut_avr::test_VertDrp_3()
{
    printf("\n === Vertex DRP test 3 - VertDRP as widget in hlayout\n");
    MNode* root = constructSystem("ut_avr_vert_drp_3");
    PFLC_INIT("ut_avr_vert_drp_2_vis");
    bool run = mEnv->RunSystem(200, 50);
    CPPUNIT_ASSERT_MESSAGE("Fail to run system", run);
    PFL_SAVE(); // Metrics for Env Profiler
    PFLC_SAVE();// Metrics for Common Profiler

    delete mEnv;
}




/** @brief Test of node DRP ASR
 * */
void Ut_avr::test_NodeDrp_Asr_1()
{
    cout << endl << "=== Test node DRP ASR: simple switching ===" << endl;

    const string specn("ut_avr_nodedrp_asr_1");
    string ext = "chs";
    string spec = specn + string(".") + "chs";
    string log = specn + "_" + ext + ".log";
    mEnv = new Env(spec, log);
    CPPUNIT_ASSERT_MESSAGE("Fail to create Env", mEnv);
    mEnv->ImpsMgr()->AddImportsPaths("../modules");
    VisProv* visprov = new VisProv("VisProv", mEnv);
    mEnv->addProvider(visprov);
    mEnv->constructSystem();
    MNode* root = mEnv->Root();
    MElem* eroot = root ? root->lIf(eroot) : nullptr;
    CPPUNIT_ASSERT_MESSAGE("Fail to get root", eroot);
    // Run
    bool res = mEnv->RunSystem(200, 20);
    CPPUNIT_ASSERT_MESSAGE("Failed running system", eroot);
    MNode* scenen = root->getNode("Test.Window.Scene");
    CPPUNIT_ASSERT_MESSAGE("Fail to get scene", scenen);

    // Switch to Model2
    MChromo* chr = mEnv->provider()->createChromo();
    chr->Init(ENt_Node);
    chr->Root().AddChild(TMut(ENt_Disconn, ENa_P, "DrpCp.Int.InpModelUri", ENa_Q, "MdlUri"));
    chr->Root().AddChild(TMut(ENt_Conn, ENa_P, "DrpCp.Int.InpModelUri", ENa_Q, "MdlUri2"));
    cout << endl << "Switching to Model2" << endl;
    mEnv->Logger()->Write(EInfo, nullptr, "=== Switching to Model2 ===");
    scenen->mutate(chr->Root(), false, MutCtx(), true);
    delete chr;

    res = mEnv->RunSystem(200, 20);
    CPPUNIT_ASSERT_MESSAGE("Failed switching to Model2", res);

    delete mEnv;
}


void Ut_avr::test_VrCtrl()
{
    printf("\n === VR Controller test 1\n");

    const string specn("ut_avr_vrc_1l");
    string ext = "chs";
    string spec = specn + string(".") + ext;
    string log = specn + "_" + ext + ".log";
    mEnv = new Env(spec, log);
    CPPUNIT_ASSERT_MESSAGE("Fail to create Env", mEnv != 0);
    //mEnv->ImpsMgr()->ResetImportsPaths();
    mEnv->ImpsMgr()->AddImportsPaths("../modules");
    VisProv* visprov = new VisProv("VisProv", mEnv);
    mEnv->addProvider(visprov);
    mEnv->constructSystem();
    MNode* root = mEnv->Root();
    MElem* eroot = root ? root->lIf(eroot) : nullptr;
    CPPUNIT_ASSERT_MESSAGE("Fail to get root", eroot);
    // Save root chromo
    eroot->Chromos().Save(specn + "_saved." + ext);
    // Dump vrcontroller chromo
    MNode* vrcu =  root->getNode("Modules/AvrMdl/VrController");
    MElem* vrce = vrcu ? vrcu->lIf(vrce) : nullptr;
    CPPUNIT_ASSERT_MESSAGE("Fail to get vrc", vrce);
    cout << endl << "VRC chromo dump:" << endl;
    vrce->Chromos().Root().Dump();

    // Run
    bool run = mEnv->RunSystem();
    CPPUNIT_ASSERT_MESSAGE("Fail to run system", run);

    delete mEnv;
}

void Ut_avr::test_SystDrp()
{
    printf("\n === System DRP test 2\n");
    MNode* root = constructSystem("ut_avr_syst_drp_1");
    // Run
    bool run = mEnv->RunSystem(200, 50);
    CPPUNIT_ASSERT_MESSAGE("Fail to run system", run);

    delete mEnv;
}

void Ut_avr::test_NodeCrp_2()
{
    printf("\n === Node CRP test 2\n");
    MNode* root = constructSystem("ut_avr_node_crp_2");
    // Run
    bool run = mEnv->RunSystem(200, 20);
    CPPUNIT_ASSERT_MESSAGE("Fail to run system", run);

    delete mEnv;
}


