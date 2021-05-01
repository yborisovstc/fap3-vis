#ifndef __FAP3VIS_MVISENV_H
#define __FAP3VIS_MVISENV_H

/** @brief Button
 * */
typedef enum {
    EFvBtnLeft,
    EFvBtnRight,
} TFvButton;

/** @brief Button action
 * */
typedef enum {
    EFvBtnActPress,
    EFvBtnActRelease,
} TFvButtonAction;


/** @brief Visial environment interface
 * */
class MVisEnv: public MIface
{
    public:
	static const char* Type() { return "MVisEnv";};
	// From MIface
	virtual string Uid() const override { return MVisEnv_Uid();}
	virtual string MVisEnv_Uid() const = 0;
    protected:
	void Construct();
};

#endif
