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

#include <cppunit/extensions/HelperMacros.h>

/*
 * To run particular test suite: ./ut-fap3vis-lib [test_suite_name] for instance ./ut-fap3vis-lib Ut_wdg
 */

/** @brief Widgets UT
 * */
class Ut_wdg : public CPPUNIT_NS::TestFixture
{
    CPPUNIT_TEST_SUITE(Ut_wdg);
    CPPUNIT_TEST(test_Label);
    //CPPUNIT_TEST(test_Button);
    CPPUNIT_TEST_SUITE_END();
    public:
    virtual void setUp();
    virtual void tearDown();
    private:
    MNode* constructSystem(const string& aFname);
private:
    void test_Label();
    void test_Button();
private:
    MEnv* mEnv;
};

CPPUNIT_TEST_SUITE_REGISTRATION( Ut_wdg );
CPPUNIT_TEST_SUITE_NAMED_REGISTRATION(Ut_wdg, "Ut_wdg");

MNode* Ut_wdg::constructSystem(const string& aSpecn)
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


static MDesSyncable* sSync;

void Ut_wdg::setUp()
{
    sSync = NULL;
}

void Ut_wdg::tearDown()
{
    CPPUNIT_ASSERT_EQUAL_MESSAGE("tearDown", 0, 0);
}

void Ut_wdg::test_Label()
{
    printf("\n === Label test 1\n");
    MNode* root = constructSystem("ut_wdg_label");

    // Debug
    MNode* fwn = root->getNode("Modules.FvWidgets.FWidget");
    MElem* fwe = fwn ? fwn->lIf(fwe) : nullptr;

    // Run 
    bool res = mEnv->RunSystem(1000000, 100000);
    CPPUNIT_ASSERT_MESSAGE("Failed running system", res);

    delete mEnv;
}

void Ut_wdg::test_Button()
{
    printf("\n === Button test 1\n");
    MNode* root = constructSystem("ut_wdg_button");

    bool res = mEnv->RunSystem(100, 20);
    CPPUNIT_ASSERT_MESSAGE("Failed running system", res);

    delete mEnv;
}

