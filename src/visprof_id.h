
#ifndef __FAP3VIS_PROF_IDS_H
#define __FAP3VIS_PROF_IDS_H

#include <prof_ids.h>

namespace PVisEvents {
    enum {
	//EDurStat_ASdcConfirm= 3006,
	EDurStat_Confirm = PEvents::EDurStat_MAX + 1,
	EDurStat_Render =  PEvents::EDurStat_MAX + 2,
	EDurStat_WdgCnf =  PEvents::EDurStat_MAX + 3,
    };
}

#endif



