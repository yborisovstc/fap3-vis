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
    //CPPUNIT_TEST(testVlayout1);
    //CPPUNIT_TEST(testVlayoutCmb);
    //CPPUNIT_TEST(testVlayoutCmb2);
    //CPPUNIT_TEST(testHlayout1);
    //CPPUNIT_TEST(testHlayout2);
    //CPPUNIT_TEST(testHlayout_RmWidget1);
    //CPPUNIT_TEST(testDCntr1);
    CPPUNIT_TEST(testDCntr2);
    //CPPUNIT_TEST(testDCntr3);
    //CPPUNIT_TEST(testDHlayout1);
    CPPUNIT_TEST_SUITE_END();
    public:
    virtual void setUp();
    virtual void tearDown();
    private:
    MNode* constructSystem(const string& aFname);
    private:
    void testVlayout1();
    void testVlayoutCmb();
    void testVlayoutCmb2();
    void testHlayout1();
    void testHlayout2();
    void testHlayout_RmWidget1();
    void testDCntr1();
    void testDCntr2();
    void testDCntr3();
    void testDHlayout1();
private:
    Env* mEnv;
};

CPPUNIT_TEST_SUITE_REGISTRATION( Ut_cntr );
CPPUNIT_TEST_SUITE_NAMED_REGISTRATION(Ut_cntr, "Ut_cntr");

MNode* Ut_cntr::constructSystem(const string& aSpecn)
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

    bool run = mEnv->RunSystem(100, 10);
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
    bool run = mEnv->RunSystem(100, 20);
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
    bool run = mEnv->RunSystem(100, 20);
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
    bool run = mEnv->RunSystem(100, 20);
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
    bool run = mEnv->RunSystem(200, 20);
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

    bool run = mEnv->RunSystem(40, 20);
    CPPUNIT_ASSERT_MESSAGE("Fail to run system", run);

    // Checking the widget removed
    slot = root->getNode("Test.Window.Scene.HBox.Slot_2");
    CPPUNIT_ASSERT_MESSAGE("Fail to remove widget", slot == NULL);

    delete mEnv;
}

/** @brief DES controlled container, vert layout
 *
 * */
void Ut_cntr::testDCntr1()
{
    printf("\n === DES controlled container, base\n");
    MNode* root = constructSystem("ut_dcntr_1");

    bool run = mEnv->RunSystem(40, 20);
    CPPUNIT_ASSERT_MESSAGE("Fail to run system", run);

    delete mEnv;
}

/** @brief DES controlled container, hrz layout
 *
 * */
void Ut_cntr::testDCntr2()
{
    printf("\n === DES controlled container, hrz layout\n");
    MNode* root = constructSystem("ut_dcntr_2");

    bool run = mEnv->RunSystem(40, 40);
    CPPUNIT_ASSERT_MESSAGE("Fail to run system", run);

    delete mEnv;
}

/** @brief DES controlled container, hrz layout, padding incr
 *
 * */
void Ut_cntr::testDCntr3()
{
    printf("\n === DES controlled container, hrz layout, padding increased\n");
    MNode* root = constructSystem("ut_dcntr_3");

    bool run = mEnv->RunSystem(40, 2000);
    CPPUNIT_ASSERT_MESSAGE("Fail to run system", run);

    delete mEnv;
}

/** @brief DES controlled container, H-layout
 *
 * */
void Ut_cntr::testDHlayout1()
{
    printf("\n === DES controlled container, hrz layout\n");
    MNode* root = constructSystem("ut_dhlayout_1");

    bool run = mEnv->RunSystem(40, 40);
    CPPUNIT_ASSERT_MESSAGE("Fail to run system", run);

    delete mEnv;
}
