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
                HBox : ContainerMod.DHLayout
                {
                    Start.Prev !~ End.Next;
                    XPadding < = "SI 20";
                    YPadding < = "SI 20";
                    BgColor < { R = "0.0"; G = "1.0"; B = "1.0"; A = "1.0"; }
                    AlcW < = "SI 400";
                    AlcH < = "SI 330";
                    Btn1 : FvWidgets.FButton
                    {
                        SText < = "SS Button 1";
                        BgColor < { R = "0.0"; G = "0.0"; B = "1.0"; }
                        FgColor < { R = "1.0"; G = "1.0"; B = "1.0"; }
                    }
                    Slot_Btn1 : ContainerMod.FHLayoutSlot;
                    Slot_Btn1.SCp ~ Btn1.Cp;
                    Btn2 : FvWidgets.FButton
                    {
                        SText < = "SS Button 2";
                        BgColor < { R = "0.0"; G = "0.0"; B = "1.0"; }
                        FgColor < { R = "1.0"; G = "1.0"; B = "1.0"; }
                    }
                    Slot_Btn2 : ContainerMod.FHLayoutSlot;
                    Slot_Btn2.SCp ~ Btn2.Cp;
                    Slot_Btn2.Next ~ Slot_Btn1.Prev;
                    # "Button 3";
                    Btn3 : FvWidgets.FButton
                    {
                        SText < = "SS Button 3";
                        BgColor < { R = "0.0"; G = "0.0"; B = "1.0"; }
                        FgColor < { R = "1.0"; G = "1.0"; B = "1.0"; }
                    }
                    Slot_Btn3 : ContainerMod.FHLayoutSlot;
                    Slot_Btn3.SCp ~ Btn3.Cp;
                    Slot_Btn3.Next ~ Slot_Btn2.Prev;
                    Slot_Btn1.Next ~ Start.Prev;
                    Slot_Btn3.Prev ~ End.Next;

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
   }
}
