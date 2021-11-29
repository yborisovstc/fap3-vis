
#include <mplugin.h>
#include "visprov.h"

string KProvName = "VisProv";

extern "C"
{
    MProvider* init(MEnv* aEnv)
    {
	return new VisProv(KProvName, aEnv);
    }
}
