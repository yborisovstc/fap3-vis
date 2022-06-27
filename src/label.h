
#ifndef __FAP3VIS_LABEL_H
#define __FAP3VIS_LABEL_H

#include "widget.h"

class FTPixmapFont;

/** @brief Label widget agent
 * */
class AVLabel : public AVWidget
{
    public:
	static const char* Type() { return "AVLabel";};
	AVLabel(const string& aType, const string& aName = string(), MEnv* aEnv = NULL);
	// From MSceneElem
	virtual void Render(bool aForce = false) override;
    protected:
	// Internal transitions
	virtual void updateRqsW();
};

#endif

