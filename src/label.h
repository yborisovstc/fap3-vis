
#ifndef __FAP3VIS_LABEL_H
#define __FAP3VIS_LABEL_H

#include "widget.h"


/** @brief Label widget agent
 * */
class AVLabel : public AVWidget
{
    public:
	static const char* Type() { return "AVLabel";};
	AVLabel(const string& aName = string(), MEnv* aEnv = NULL);
	virtual ~AVLabel();
	// From ADes.MAgent
	virtual void onHostContentChanged(const MContent* aCont) override;
	// From MSceneElem
	virtual void Render() override;
    protected:
	// From Node
	virtual void onOwnerAttached() override;
    protected:
	string mFontPath;
};

#endif

