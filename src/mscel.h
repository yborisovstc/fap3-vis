#ifndef __FAP3VIS_MSCEL_H
#define __FAP3VIS_MSCEL_H

#include "mvisenv.h"

/** @brief Scene element of Visial environment interface
 * */
class MSceneElem: public MIface
{
    public:
	inline static constexpr std::string_view idStr() { return "MSceneElem"sv;}
	inline static constexpr TIdHash idHash() { return 0x1166858ad08fbd05;}
    public:
	// From MIface
	TIdHash id() const override { return idHash();}
	virtual string Uid() const override { return MSceneElem_Uid();}
	virtual string MSceneElem_Uid() const = 0;
        // Local
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

};

/** @brief Scene element owner
 * */
class MSceneElemOwner: public MIface
{
    public:
	inline static constexpr std::string_view idStr() { return "MSceneElemOwner"sv;}
	inline static constexpr TIdHash idHash() { return 0x81f81a9179a6d3d8;}
    public:
	// From MIface
	TIdHash id() const override { return idHash();}
	virtual string Uid() const override { return MSceneElemOwner_Uid();}
	virtual string MSceneElemOwner_Uid() const = 0;
        /** @brief Gets topleft coordinate in owning scene element
         * @param aLevel - owning scene element level, 0 - direct owner
         * */
	virtual void getCoordOwrSeo(int& aOutX, int& aOutY, int aLevel = -1) = 0;
};


#endif
