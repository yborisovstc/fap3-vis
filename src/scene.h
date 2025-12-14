#ifndef __FAP3VIS_SCENE_H
#define __FAP3VIS_SCENE_H

#include <des.h>
#include <mscene.h>


using namespace std;


/** @brier Scene of GLUT base visualization module
 *
 * It is also visual representation of model
 * */
class GtScene: public Des, public MScene
{
    public:
	inline static constexpr std::string_view idStr() { return "GtScene"sv;}
    public:
	GtScene(const string& aType, const string& aName, MEnv* aEnv);
	// From MScene
	virtual string MScene_Uid() const override {return getUid<MDesSyncable>();}
	// From Node.MIface
	virtual MIface* MNode_getLif(TIdHash aTid) override;
	// From MScene
	virtual void RenderScene(void) override;
	virtual void onCursorPosition(double aX, double aY) override;
	virtual void onMouseButton(TFvButton aButton, TFvButtonAction aAction, int aMods) override;
	// From Unit.MIfProvOwner
	virtual void resolveIfc(TIdHash aTid, MIfReq::TIfReqCp* aReq) override;
    public:
	// From MDesSyncable
	virtual void update() override;
    protected:
	void Construct();
    protected:
	bool mWndInit;
	MScene* mMScenePtr = nullptr;
};

#endif // __FAP2VIS_SCENE_H


