#ifndef __FAP3VIS_MWIDGET_H
#define __FAP3VIS_MWIDGET_H


#include <miface.h>

/** @brief Container component
 * Represents container component in connection to container slot
 *
 * */
class MVCcomp: public MIface
{
    public:
	static const char* Type() { return "MVCcomp";};
	// From MIface
	virtual string Uid() const override { return MVCcomp_Uid();}
	virtual string MVCcomp_Uid() const = 0;
};

#endif

