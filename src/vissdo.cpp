
#include "vissdo.h"
#include "mscel.h"

SdoCoordOwr::SdoCoordOwr(const string &aType, const string& aName, MEnv* aEnv):
    Sdog<Pair<Sdata<int>>>(aType, aName, aEnv),  mInpLevel(this, "Level"),
    mInpX(this, "InpX"), mInpY(this, "InpY")
{}

const DtBase* SdoCoordOwr::VDtGet(const string& aType)
{
    if (mCInv) {
	mRes.mValid = false;
        if (!mSue)  {
            LOGN(EErr, "Owner is not explorable");
        } else {
            MUnit* sueu = mSue->lIf(sueu);
            MSceneElem* scel = sueu ? sueu->getSif(scel) : nullptr;
            if (!scel) {
                LOGN(EErr, "Owner is not scene element");
            } else {
                Sdata<int> level;
                bool res = mInpLevel.getData(level);
                /*
                Sdata<int> x;
                res &= mInpX.getData(x);
                Sdata<int> y;
                res &= mInpY.getData(y);
                */
                if (!res) {
                    LOGN(EErr, "Failed getting input [" + mInpLevel.mName + "] data");
                } else {
                    scel->getCoordOwr(mRes.mData.first.mData, mRes.mData.second.mData, level.mData);
                    /*
                    mRes.mData.first.mData += x.mData;
                    mRes.mData.second.mData += y.mData;
                    */
                    mRes.mData.first.mValid = true;
                    mRes.mData.second.mValid = true;
                    mRes.mValid = true;
                    LOGN(EDbg, "Coord: " + mRes.ToString());
                }
            }
        }
        mCInv = false;
    }
    return &mRes;
}
