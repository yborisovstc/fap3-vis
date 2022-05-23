testroot : Elem
{
    # "Unit test of DES controlled Hrz layout";
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
            Debug.LogLevel = "Dbg";
            Init = "Yes";
            Width <  = "SI 1200";
            Height < = "SI 800";
            Scene : GVisComps.Scene
            {
                # "Visualisation scene";
                Alg : ContainerMod.DAlignment
                {
                    Start.Prev !~ End.Next;
                    BgColor < { R = "1.0"; G = "0.0"; B = "0.0"; A = "1.0"; }
                HBox : ContainerMod.DHLayout
                {
                    Start.Prev !~ End.Next;
                    BgColor < { R = "0.0"; G = "1.0"; B = "0.0"; A = "1.0"; }
                    Btn1 : FvWidgets.FButton
                    {
                        SText < = "SS Button 1";
                        BgColor < { R = "0.0"; G = "0.0"; B = "1.0"; A = "1.0"; }
                        FgColor < { R = "1.0"; G = "1.0"; B = "1.0"; A = "1.0"; }
                    }
                    Slot_Btn1 : ContainerMod.FHLayoutSlot @ {
                        SCp ~ Btn1.Cp;
                        Next ~ Start.Prev;
                        Prev ~ End.Next;
                    }
                }
                    Slot_HBox : ContainerMod.AlignmentSlot @ {
                        SCp ~ HBox.Cp;
                        Next ~ Start.Prev;
                        Prev ~ End.Next;
                    }
                }
            }
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
        # "Counter";
        Cntr : State @ {
            _@ < {
                 = "SI 0";
                 Debug.LogLevel = "Dbg";
            }
            Inp ~ : TrAddVar @ {
                Inp ~ Cntr;
                Inp ~ : State { = "SI 10"; };
            };
        }
        Wnd.Scene.Alg.AlcW.Inp ~ Wnd.Width;
        Wnd.Scene.Alg.AlcH.Inp ~ Wnd.Height;
        Wnd.Scene.Alg.HBox.XPadding.Inp ~ Cntr;
     }
}
