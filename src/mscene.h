#ifndef __FAP3VIS_MSCENE_H
#define __FAP3VIS_MSCENE_H

#include "mvisenv.h"

/** @brief Scene of Visial environment interface
 * */
class MScene: public MIface
{
    public:
	static const char* Type() { return "MScene";};
	// From MIface
	virtual string Uid() const override { return MScene_Uid();}
	virtual string MScene_Uid() const = 0;
	// Local
	virtual void RenderScene(void) = 0;
	/** @brief Cursor position handler
	 * @param aX, aY  cursor pos in window coordinates
	 * */
	virtual void onCursorPosition(double aX, double aY) = 0;
	virtual void onMouseButton(TFvButton aButton, TFvButtonAction aAction, int aMods) = 0;
};


#endif
