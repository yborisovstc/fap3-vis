#ifndef __FAP3VIS_MSCEL_H
#define __FAP3VIS_MSCEL_H

#include "mvisenv.h"

/** @brief Scene element of Visial environment interface
 * */
class MSceneElem: public MIface
{
    public:
	static const char* Type() { return "MSceneElem";};
	virtual void Render() = 0;
	/** @brief Cursor position handler
	 * @param aX, aY  cursor pos in window coordinates
	 * */
	virtual void onSeCursorPosition(double aX, double aY) = 0;

	/** @brief Handles mouse button events
	 * @param[in] aButton - button Id
	 * @param[in] aAction - action: GLFW_PRESS or GLFW_RELEASE
	 * @param[in] aMods - modes
	 * @return  Sign of the event is processed and accepted
	 * */
	virtual bool onMouseButton(TFvButton aButton, TFvButtonAction aAction, int aMods) = 0;

	/** @brief Gets window coordinates of the given point
	 * @param[in] aInpX, aInpY given coordinate
	 * @param[out] aOutX, aOutY window coordinate
	 * */
	// TODO Currently input coords are of coord system of the requested scene elem
	// this mean the owned scene elem has to know its own location within owning scene elem
	// i.e. widget has to know the whole allocation including X, Y.
	// To consider more suitable approach when the owned scene elem doesn't know of its own
	// allocation but owning scene element knows
//	virtual void getWndCoord(int aInpX, int aInpY, int& aOutX, int& aOutY) = 0;
        /** @brief Gets topleft coordinate in owning scene element
         * @param aLevel - owning scene element level, 0 - direct owner
         * */
        // TODO This method actually overrides getWndCoord with aLevel > window level
        // getWndCoord is remained for compatibility purpose only. Consider get rid of it.
	//virtual void getCoordOwr(int& aOutX, int& aOutY, int aLevel = -1) = 0;

	// From MIface
	virtual string Uid() const override { return MSceneElem_Uid();}
	virtual string MSceneElem_Uid() const = 0;
};

/** @brief Scene element owner
 * */
class MSceneElemOwner: public MIface
{
    public:
	static const char* Type() { return "MSceneElemOwner";};
	/** @brief Gets window coordinates of the given point
	 * @param[in] aInpX, aInpY given coordinate
	 * @param[out] aOutX, aOutY window coordinate
	 * */
	// TODO Currently input coords are of coord system of the requested scene elem
	// this mean the owned scene elem has to know its own location within owning scene elem
	// i.e. widget has to know the whole allocation including X, Y.
	// To consider more suitable approach when the owned scene elem doesn't know of its own
	// allocation but owning scene element knows
	////virtual void getWndCoordSeo(int aInpX, int aInpY, int& aOutX, int& aOutY) = 0;
        /** @brief Gets topleft coordinate in owning scene element
         * @param aLevel - owning scene element level, 0 - direct owner
         * */
        // TODO This method actually overrides getWndCoord with aLevel > window level
        // getWndCoord is remained for compatibility purpose only. Consider get rid of it.
	virtual void getCoordOwrSeo(int& aOutX, int& aOutY, int aLevel = -1) = 0;

	// From MIface
	virtual string Uid() const override { return MSceneElemOwner_Uid();}
	virtual string MSceneElemOwner_Uid() const = 0;
};



#endif
