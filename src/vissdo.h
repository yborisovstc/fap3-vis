#ifndef __FAP3VIS_VISSDO_H
#define __FAP3VIS_VISSDO_H

#include "dessdo.h"

/** @brief SDO "Coords in owner's coord system."
 * */
class SdoCoordOwr : public Sdog<Pair<Sdata<int>>>
{
    public:
	static const char* Type() { return "SdoCoordOwr";};
	SdoCoordOwr(const string &aType, const string& aName = string(), MEnv* aEnv = NULL);
	virtual const DtBase* VDtGet(const string& aType) override;
    protected:
	Inpg<Sdata<int>> mInpLevel;  //<! Level of owner 
	Inpg<Sdata<int>> mInpX;  //<! X coord, for update notification only
	Inpg<Sdata<int>> mInpY;  //<! Y coord, for update notification only
};



#endif

