
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
	// From ADes.MObserver
	virtual void onObsContentChanged(MObservable* aObl, const MContent* aCont) override;
    protected:
	// TODO to have to shared font in visual env
	FTPixmapFont* mFont;
	MNode* GetStatePressed();
	void updateRq();
    protected:
	static const int K_BFontSize; /**< Base metric: Base font (unit name) size. */
	static const int K_BPadding;  /**< Base metric: Base padding */
	static const int K_LineWidth; /**< Base metric: Line width */
};


#endif
