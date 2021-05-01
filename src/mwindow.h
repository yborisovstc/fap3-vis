#ifndef __FAP3VIS_MWINDOW_H
#define __FAP3VIS_MWINDOW_H

#include <miface.h>

/** @brief Window interface
 * */
class MWindow: public MIface
{
    public:
	static const char* Type() { return "MWindow";};
	/** @brief Gets cursor position */
	virtual void GetCursorPos(double& aX, double& aY) = 0;
	/** @brief Gets size of window in pixels (actually framebuffer size) */
	virtual void GetFbSize(int* aW, int* aH) const = 0;
	// From MIface
	virtual string Uid() const override { return MWindow_Uid();}
	virtual string MWindow_Uid() const = 0;
};

#endif
