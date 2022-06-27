testroot : Elem
{
    # "Unit test of DES controlled Vert layout";
    Modules : Node
    {
        + GVisComps;
        + ContainerMod;
    }
    Test : DesLauncher
    {
        # "Visualisation environment";
        VEnv : GVisComps.VisEnv;
        VEnv.VisEnvAgt < Init = "Yes"; 
        # "Window";
        Wnd : GVisComps.Window
        {
            Init = "Yes";
            Width <  = "SI 1200";
            Height < = "SI 800";
            Scene : GVisComps.Scene
            {
                # "Visualisation scene";
                VBox : ContainerMod.DVLayout
                {
                    Start.Prev !~ End.Next;
                    YPadding < = "SI 20";
                    AlcW < = "SI 220";
                    AlcH < = "SI 330";
                    BgColor < { R = "0.0"; G = "1.0"; B = "1.0"; A = "1.0"; }
                    Btn1 : FvWidgets.FButton
                    {
                        SText < = "SS Button 1";
                        BgColor < { R = "0.0"; G = "0.0"; B = "1.0"; }
                        FgColor < { R = "1.0"; G = "1.0"; B = "1.0"; }
                    }
                    Slot_Btn1 : ContainerMod.FVLayoutSlot;
                    Slot_Btn1.SCp ~ Btn1.Cp;
                    Btn2 : FvWidgets.FButton
                    {
                        SText < = "SS Button 2";
                        BgColor < { R = "0.0"; G = "0.0"; B = "1.0"; }
                        FgColor < { R = "1.0"; G = "1.0"; B = "1.0"; }
                    }
                    Slot_Btn2 : ContainerMod.FVLayoutSlot;
                    Slot_Btn2.SCp ~ Btn2.Cp;
                    Slot_Btn2.Next ~ Slot_Btn1.Prev;
                    Slot_Btn1.Next ~ Start.Prev;
                    Slot_Btn2.Prev ~ End.Next;
                }
            }
        }
        # " Adding new button";
	VBox_AddWdg : ContainerMod.DcAddWdgSc;
        VBox_AddWdg ~ Wnd.Scene.VBox.IoAddWidg;
	VBox_AddWdg.Enable ~ : State { = "SB true"; };
	VBox_AddWdg.Name ~ : State { = "SS Btn3"; };
	VBox_AddWdg.Parent ~ : State { = "SS FvWidgets.FButton"; };
	VBox_AddWdg.Pos ~ : State { = "SI 0"; };
        VBox_AddWdg.Mut ~ : State { = "CHR2 { SText < = \"SS Button 3\";  BgColor < { R = \"0.0\"; G = \"0.0\"; B = \"1.0\"; } FgColor < { R = \"1.0\"; G = \"1.0\"; B = \"1.0\"; } }"; };
        AddedWdg_Dbg : State @ {
            _@ < {
                Debug.LogLevel = "Dbg";
                = "SB false";
            }
            Inp ~ VBox_AddWdg.Added;
        }
        # "We need to use trigger that keeps WdgAdded indication. This is because Add/Rm internal ops breaks the indication.";
        WdgAdded_Tg : DesUtils.RSTg;
        WdgAdded_Tg.InpS ~ VBox_AddWdg.Added;
        # " Removing button 1";
	VBox_RmWdg : ContainerMod.DcRmWdgSc;
        VBox_RmWdg ~ Wnd.Scene.VBox.IoRmWidg;
	VBox_RmWdg.Enable ~ WdgAdded_Tg.Value;
	VBox_RmWdg.Name ~ : State { = "SS Btn1"; };
        RmWdg_Dbg : State @ {
            _@ < {
                Debug.LogLevel = "Dbg";
                = "SB false";
            }
            Inp ~ VBox_RmWdg.Done;
        }
        WdgAdded_Tg.InpR ~ VBox_RmWdg.Done;
        # " Misc env";
        EnvWidth : State;
        EnvHeight : State;
        Title : State;
        EnvWidth ~ Wnd.Inp_W;
        EnvHeight ~ Wnd.Inp_H;
        Title ~ Wnd.Inp_Title;
        EnvWidth < = "SI 640";
        EnvHeight < = "SI 480";
        Title < = "SS Title";
   }
}
