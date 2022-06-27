
#ifndef __FAP3VIS_UTILS_H
#define __FAP3VIS_UTILS_H

/** @brief Point
 * */
template <typename T>
class VPoint
{
    public:
	VPoint(T aX, T aY) : mX(aX), mY(aY) {}
	VPoint(const VPoint& aSrc) : mX(aSrc.mX), mY(aSrc.mY) {}
	VPoint& operator = (const VPoint& aSrc) { mX = aSrc.mX; mY = aSrc.mY; return *this; }
    public:
	T mX;
	T mY;
};

/** @brief Rectangle
 * Defined by bottom-left and top-right points
 * */
template <typename T>
class VRect
{
    using Tp = VPoint<T>;
    public:
	VRect(Tp aBl, Tp aTr) : mBl(aBl), mTr(aTr) {}
	VRect(T aBlx, T aBly, T aTrx, T aTry) : mBl(aBlx, aBly), mTr(aTrx, aTry) {}
	VRect(const VRect& aSrc) : mBl(aSrc.mBl), mTr(aSrc.mTr) {}
	VRect& operator = (const VRect& aSrc) { mBl = aSrc.mBl; mTr = aSrc.mTr; return *this; }
	Tp bR() const { return Tp(mTr.mX, mBl.mY); }
	Tp tL() const { return Tp(mBl.mX, mTr.mY); }
	bool isIn(const Tp& aPt) { return aPt.mX >= mBl.mX && aPt.mX <= mTr.mX && aPt.mY >= mBl.mY && aPt.mY <= mTr.mY; }
	bool intersects(const VRect& aB) { return isIn(aB.mBl) || isIn(aB.mTr) || isIn(aB.bR()) || isIn(aB.tL());}
    public:
	Tp mBl;
	Tp mTr;
};



#endif

