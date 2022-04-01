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
                HBox : ContainerMod.FHLayout
                {
                    Padding < Value = "SI 40";
                    AlcW < Value = "SI 220";
                    AlcH < Value = "SI 330";
                    # " ==== Slot 1 ====";
                    VBox2 : ContainerMod.FVLayout
                    {
                        Padding < Value = "SI 10";
                        AlcW < Value = "SI 220";
                        AlcH < Value = "SI 330";
                        Btn2_1 : FvWidgets.FButton
                        {
                            Text = "Button 2_1";
                            BgColor < { R < = "0.0"; G < = "0.0"; B < = "1.0"; }
                            FgColor < { R < = "1.0"; G < = "1.0"; B < = "1.0"; }
                        }
                        Slot_1 : ContainerMod.FVLayoutSlot;
                        Slot_1.SCp ~ Btn2_1.Cp;
                        Slot_1.Next ~ Start.Prev;
                        Btn2_2 : FvWidgets.FButton
                        {
                            Text = "Button 2_2";
                            BgColor < { R < = "0.0"; G < = "0.0"; B < = "1.0"; }
                            FgColor < { R < = "1.0"; G < = "1.0"; B < = "1.0"; }
                        }
                        Slot_2 : ContainerMod.FVLayoutSlot;
                        Slot_2.SCp ~ Btn2_2.Cp;
                        Slot_2.Next ~ Slot_1.Prev;
                        End.Next ~ Slot_2.Prev;
                    }
                    Slot_1 : ContainerMod.FHLayoutSlot;
                    Slot_1.SCp ~ VBox2.Cp;
                    Slot_1.Next ~ Start.Prev;
                    # " ==== Slot 2 ====";
                    Btn3 : FvWidgets.FButton
                    {
                        Text = "Button_3";
                        BgColor < { R < = "0.0"; G < = "0.0"; B < = "1.0"; }
                        FgColor < { R < = "1.0"; G < = "1.0"; B < = "1.0"; }
                    }
                    Slot_2 : ContainerMod.FHLayoutSlot;
                    Slot_2.SCp ~ Btn3.Cp;
                    Slot_2.Next ~ Slot_1.Prev;
                    Slot_2.Prev ~ End.Next;
                }
            }
        }
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
