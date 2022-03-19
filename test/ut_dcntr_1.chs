testroot : Elem
{
    # "Unit test of Button agent";
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
                    Start !~ End;
                    Padding < = "SI 20";
                    AlcW < = "SI 220";
                    AlcH < = "SI 330";
                    Btn1 : FvWidgets.FButton
                    {
                        Text = "Button 1";
                        BgColor < { R = "0.0"; G = "0.0"; B = "1.0"; }
                        FgColor < { R = "1.0"; G = "1.0"; B = "1.0"; }
                    }
                    Slot_1 : ContainerMod.FVLayoutSlot;
                    Slot_1.SCp ~ Btn1.Cp;
                    Btn2 : FvWidgets.FButton
                    {
                        Text = "Button 2";
                        BgColor < { R = "0.0"; G = "0.0"; B = "1.0"; }
                        FgColor < { R = "1.0"; G = "1.0"; B = "1.0"; }
                    }
                    Slot_2 : ContainerMod.FVLayoutSlot;
                    Slot_2.SCp ~ Btn2.Cp;
                    Slot_2.Next ~ Slot_1.Prev;
                    Slot_1.Next ~ Start;
                    Slot_2.Prev ~ End;
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
        VBox_AddWdg.Mut ~ : State { = "CHR2 { Text = \"Button 3\";  BgColor < { R = \"0.0\"; G = \"0.0\"; B = \"1.0\"; } FgColor < { R = \"1.0\"; G = \"1.0\"; B = \"1.0\"; } }"; };
        AddedWdg_Dbg : State @ {
            _@ < {
                Debug.LogLevel = "Dbg";
                = "SB false";
            }
            Inp ~ VBox_AddWdg.Added;
        }
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