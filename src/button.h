
#ifndef __FAP3VIS_BUTTON_H
#define __FAP3VIS_BUTTON_H

#include "widget.h"

class FTPixmapFont;

/** @brief Button widget agent
 * */
class AButton : public AVWidget
{
    public:
	static const char* Type() { return "AButton";};
	AButton(const string& aType, const string& aName = string(), MEnv* aEnv = NULL);
	// From MSceneElem
	virtual void Render() override;
	virtual bool onMouseButton(TFvButton aButton, TFvButtonAction aAction, int aMods) override;
    protected:
	// From AVWidget
	virtual void Init() override;
	// Internal transitions
	virtual void updateRqsW();
    protected:
	// TODO to have to shared font in visual env
	MNode* GetStatePressed();
};


#endif
