#include <stdlib.h>
#include <sys/types.h>
#include <signal.h>
#include <iostream>
#include <fstream>
#include <env.h>
#include <elem.h>
#include <mdes.h>
#include "../src/visprov.h"
#include "../src/mvisenv.h"

#include <cppunit/extensions/HelperMacros.h>

#include <GLFW/glfw3.h>

/*
 * To run particular test suite: ./ut-fap2vis-lib [test_suite_name] for instance ./ut-fap2vis-lib Ut_ExecMagt
 */



/** @brief Test of container using approach of widget assosiation to slots via link
 * */
class Ut_cntr : public CPPUNIT_NS::TestFixture
{
    CPPUNIT_TEST_SUITE(Ut_cntr);
    ///CPPUNIT_TEST(testVlayout1);
    //CPPUNIT_TEST(testVlayoutCmb);
    //CPPUNIT_TEST(testVlayoutCmb2);
    CPPUNIT_TEST(testHlayout1);
    //CPPUNIT_TEST(testHlayout2);
    //CPPUNIT_TEST(testHlayout_RmWidget1);
    CPPUNIT_TEST_SUITE_END();
    public:
    virtual void setUp();
    virtual void tearDown();
private:
    void testVlayout1();
    void testVlayoutCmb();
    void testVlayoutCmb2();
    void testHlayout1();
    void testHlayout2();
    void testHlayout_RmWidget1();
private:
    Env* mEnv;
};

CPPUNIT_TEST_SUITE_REGISTRATION( Ut_cntr );
CPPUNIT_TEST_SUITE_NAMED_REGISTRATION(Ut_cntr, "Ut_cntr");


void Ut_cntr::setUp()
{
}

void Ut_cntr::tearDown()
{
    CPPUNIT_ASSERT_EQUAL_MESSAGE("tearDown", 0, 0);
}


void Ut_cntr::testVlayout1()
{
    printf("\n === Vertical layout test 1\n");
    const string specn("ut_vlayout_1");
    string ext = "chs";
    string spec = specn + string(".") + ext;
    string log = specn + "_" + ext + ".log";
    mEnv = new Env(spec, log);
    CPPUNIT_ASSERT_MESSAGE("Fail to create Env", mEnv != 0);
    mEnv->ImpsMgr()->AddImportsPaths("../modules");
    VisProv* visprov = new VisProv("VisProv", mEnv);
    mEnv->addProvider(visprov);
    mEnv->constructSystem();
    MNode* root = mEnv->Root();
    CPPUNIT_ASSERT_MESSAGE("Fail to get root", root != 0);

    bool run = mEnv->RunSystem(100);
    CPPUNIT_ASSERT_MESSAGE("Fail to run system", run);

    delete mEnv;
}


void Ut_cntr::testVlayoutCmb()
{
    printf("\n === Combined Vertical layout (SLW approach) test 1\n");
    const string specn("ut_vlayout_2");
    string ext = "chs";
    string spec = specn + string(".") + ext;
    string log = specn + "_" + ext + ".log";
    mEnv = new Env(spec, log);
    CPPUNIT_ASSERT_MESSAGE("Fail to create Env", mEnv != 0);
    mEnv->ImpsMgr()->AddImportsPaths("../modules");
    VisProv* visprov = new VisProv("VisProv", mEnv);
    mEnv->addProvider(visprov);
    mEnv->constructSystem();
    bool run = mEnv->RunSystem();
    CPPUNIT_ASSERT_MESSAGE("Fail to run system", run);

    delete mEnv;
}

void Ut_cntr::testVlayoutCmb2()
{
    printf("\n === Combined Vertical layout (SLW approach) test 1\n");
    const string specn("ut_vlayout_3");
    string ext = "chs";
    string spec = specn + string(".") + ext;
    string log = specn + "_" + ext + ".log";
    mEnv = new Env(spec, log);
    CPPUNIT_ASSERT_MESSAGE("Fail to create Env", mEnv != 0);
    mEnv->ImpsMgr()->AddImportsPaths("../modules");
    VisProv* visprov = new VisProv("VisProv", mEnv);
    mEnv->addProvider(visprov);
    mEnv->constructSystem();
    bool run = mEnv->RunSystem(200);
    CPPUNIT_ASSERT_MESSAGE("Fail to run system", run);

    delete mEnv;
}

void Ut_cntr::testHlayout1()
{
    printf("\n === Single horisontal layout (SLW approach) test 1\n");
    const string specn("ut_hlayout_1");
    string ext = "chs";
    string spec = specn + string(".") + ext;
    string log = specn + "_" + ext + ".log";
    mEnv = new Env(spec, log);
    CPPUNIT_ASSERT_MESSAGE("Fail to create Env", mEnv != 0);
    mEnv->ImpsMgr()->AddImportsPaths("../modules");
    VisProv* visprov = new VisProv("VisProv", mEnv);
    mEnv->addProvider(visprov);
    mEnv->constructSystem();
    bool run = mEnv->RunSystem(100);
    CPPUNIT_ASSERT_MESSAGE("Fail to run system", run);

    delete mEnv;
}

void Ut_cntr::testHlayout2()
{
    printf("\n === Combined horisontal layout (SLW approach) test 1\n");
    const string specn("ut_hlayout_2");
    string ext = "chs";
    string spec = specn + string(".") + ext;
    string log = specn + "_" + ext + ".log";
    mEnv = new Env(spec, log);
    CPPUNIT_ASSERT_MESSAGE("Fail to create Env", mEnv != 0);
    mEnv->ImpsMgr()->AddImportsPaths("../modules");
    VisProv* visprov = new VisProv("VisProv", mEnv);
    mEnv->addProvider(visprov);
    mEnv->constructSystem();
    bool run = mEnv->RunSystem(200);
    CPPUNIT_ASSERT_MESSAGE("Fail to run system", run);

    delete mEnv;
}


/** @brief HLayout, removing widget
 *
 * */
void Ut_cntr::testHlayout_RmWidget1()
{
    printf("\n === Combined horisontal layout, removing widget 1\n");
    const string specn("ut_hlayout_rmwidget_1");
    string ext = "chs";
    string spec = specn + string(".") + ext;
    string log = specn + "_" + ext + ".log";
    mEnv = new Env(spec, log);
    CPPUNIT_ASSERT_MESSAGE("Fail to create Env", mEnv != 0);
    mEnv->ImpsMgr()->AddImportsPaths("../modules");
    VisProv* visprov = new VisProv("VisProv", mEnv);
    mEnv->addProvider(visprov);
    mEnv->constructSystem();
    MNode* root = mEnv->Root();
    CPPUNIT_ASSERT_MESSAGE("Fail to get root", root != 0);
    // Checking the widget/slot exists
    MNode* slot = root->getNode("Test.Window.Scene.HBox.Slot_2");
    CPPUNIT_ASSERT_MESSAGE("Failed creating widget/slot", slot);

    bool run = mEnv->RunSystem(40);
    CPPUNIT_ASSERT_MESSAGE("Fail to run system", run);

    // Checking the widget removed
    slot = root->getNode("Test.Window.Scene.HBox.Slot_2");
    CPPUNIT_ASSERT_MESSAGE("Fail to remove widget", slot == NULL);

    delete mEnv;
}
