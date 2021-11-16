testroot : Elem
{
    # "Unit test of Container removing widget";
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
        Window : GVisComps.Window
        {
            Init = "Yes";
            Width < = "SI 1200";
            Height < = "SI 800";
            Scene : GVisComps.Scene
            {
                HBox : ContainerMod.FHLayout
                {
                    Padding < = "SI 20";
                    AlcW < = "SI 220";
                    AlcH < = "SI 330";
                    Btn1 : FvWidgets.FButton
                    {
                        Text = "Button 1";
                        BgColor < { R < = "0.0"; G < = "0.0"; B < = "1.0"; }
                        FgColor < { R < = "1.0"; G < = "1.0"; B < = "1.0"; }
                    }
                    Slot_1 : ContainerMod.FHLayoutSlot;
                    Slot_1.SCp ~ Btn1.Cp;
                    Btn2 : FvWidgets.FButton
                    {
                        Text = "Button 2";
                        BgColor < { R < = "0.0"; G < = "0.0"; B < = "1.0"; }
                        FgColor < { R < = "1.0"; G < = "1.0"; B < = "1.0"; }
                    }
                    Slot_2 : ContainerMod.FHLayoutSlot;
                    Slot_2.SCp ~ Btn2.Cp;
                    Slot_2.Next ~ Slot_1.Prev;
                    Slot_1.Next ~ Start;
                    Slot_2.Prev ~ End;
                }
            }
        }
        EnvWidth : State;
        EnvHeight : State;
        Title : State;
        EnvWidth ~ Window.Inp_W;
        EnvHeight ~ Window.Inp_H;
        Title ~ Window.Inp_Title;
        # "Mutation to remove Bnt2";
        Timeout : State {
            Debug : Content { Update : Content { = "y"; } }
            = "SI 0";
        }
        Timeout.Inp ~ : TrAddVar @ {
            Inp ~ Timeout;
            Inp ~ : TrSwitchBool @ {
                Sel ~ Cmp_Eq_2 : TrCmpVar @ {
                    Inp ~ Timeout;
                    Inp2 ~ : State { = "SI 22"; };
                };
                Inp1 ~ : State { = "SI 1"; };
                Inp2 ~ : State { = "SI 0"; };
            };
        };
        Window.Scene.HBox.InpMutRmWidget ~ : TrSwitchBool @ {
            Sel ~ Cmp_Eq : TrCmpVar @ {
                Inp ~ Timeout;
                Inp2 ~ : State {
                    = "SI 20";
                };
            };
            Inp1 ~ : State {
                = "SI -1";
            };
            Inp2 ~ : State {
                = "SI 1";
            };
        };
    }
}
