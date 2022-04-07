#ifndef __FAP3VIS_MWIDGET_H
#define __FAP3VIS_MWIDGET_H


#include <miface.h>

/** @brief Visual style provider
 * */
class MVStyleProvider: public MIface
{
    public:
	static const char* Type() { return "MVStyleProvider";};
	// From MIface
	virtual string Uid() const override { return MVStyleProvider_Uid();}
	virtual string MVStyleProvider_Uid() const = 0;
	// Local
	virtual bool getVStyleParam(const string& aId, string& aParam) = 0;
};

/** @brief Visual style consumer
 * */
class MVStyleConsumer: public MIface
{
    public:
	static const char* Type() { return "MVStyleConsumer";};
	// From MIface
	virtual string Uid() const override { return MVStyleConsumer_Uid();}
	virtual string MVStyleConsumer_Uid() const = 0;
};



/** @brief Container component
 * Represents container component in connection to container slot
 * */
// TODO isn't used, to remove ?
class MVCcomp: public MIface
{
    public:
	static const char* Type() { return "MVCcomp";};
	// From MIface
	virtual string Uid() const override { return MVCcomp_Uid();}
	virtual string MVCcomp_Uid() const = 0;
};

#endif

