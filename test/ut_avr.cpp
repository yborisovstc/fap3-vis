#include <stdlib.h>
//#include "../src/mwidget.h"
#include <sys/types.h>
#include <signal.h>
#include <iostream>
#include <fstream>
#include <env.h>
#include <elem.h>
#include <mdes.h>
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
//    CPPUNIT_TEST(test_Node);
    CPPUNIT_TEST(test_NodeDrp);
//    CPPUNIT_TEST(test_VrCtrl);
//    CPPUNIT_TEST(test_SystDrp);
    CPPUNIT_TEST_SUITE_END();
    public:
    virtual void setUp();
    virtual void tearDown();
private:
    void test_Node();
    void test_NodeDrp();
    void test_VrCtrl();
    void test_SystDrp();
private:
    Env* mEnv;
};

CPPUNIT_TEST_SUITE_REGISTRATION( Ut_avr );
CPPUNIT_TEST_SUITE_NAMED_REGISTRATION(Ut_avr, "Ut_avr");

static MDesSyncable* sSync;

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
    const string specn("ut_avr_node_drp");
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

    // Run
    bool run = mEnv->RunSystem(20);
    CPPUNIT_ASSERT_MESSAGE("Fail to run system", run);

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
    printf("\n === System DRP test 0\n");
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
    mEnv->setEVar("Model","./test_model_syst_1.chs");
    mEnv->constructSystem();
    MNode* root = mEnv->Root();
    CPPUNIT_ASSERT_MESSAGE("Fail to get root", root != 0);

    bool run = mEnv->RunSystem();
    CPPUNIT_ASSERT_MESSAGE("Fail to run system", run);

    delete mEnv;
}
