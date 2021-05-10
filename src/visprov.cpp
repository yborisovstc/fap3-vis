
#include <chromo2.h>

#include "visprov.h"

#include "visenv.h"
#include "scene.h"
#include "widget.h"
#include "label.h"
#include "button.h"
#include "container.h"
#include "vlayout.h"
#include "hlayout.h"
#include "alignment.h"

// TODO [YB] To import from build variable
const string KModulesPath = "/usr/share/fap3-vis/modules/";

/** @brief Chromo arguments */
const string KChromRarg_Chs = "chs";

/** Native agents factory registry */
const VisProv::TFReg VisProv::mReg ( {
	Item<AVisEnv>(), Item<GWindow>(), Item<GtScene>(), Item<AVWidget>(), Item<AVLabel>(), Item<AButton>(),
	Item<VSlot>(), Item<AVLayout>(), Item<AHLayout>(), Item<AAlignment>()
	});



VisProv::VisProv(const string& aName, MEnv* aEnv): ProvBase(aName, aEnv)
{
}

VisProv::~VisProv()
{
}

void VisProv::getNodesInfo(vector<string>& aInfo)
{
    for (auto elem : mReg) {
	aInfo.push_back(elem.first);
    }
}

const string& VisProv::modulesPath() const
{
    return KModulesPath;
}

MChromo* VisProv::createChromo(const string& aRargs)
{
    MChromo* res = NULL;
    if (aRargs == KChromRarg_Chs) {
	res = new Chromo2();
    } else if (aRargs.empty()) {
	// Default chromo type
	res = new Chromo2();
    }
    return res;
}
