Testroot : Elem
{
    # "Unit test of Container base agent";
    Modules : Node
    {
        + GVisComps;
        + ContainerMod;
    }
    Test : VDesLauncher;
    {
        # "Visualisation environment";
        VisEnvAgt : AVisEnv;
        VisEnvAgt < Init = "Yes";
        Window : GVisComps.GWindow
        {
            AWnd < Init = "Yes";
            Width < = "SI 1200";
            Heigth < = "SI 800";
            Scene : GVisComps.Scene
            {
                VBox : ContainerMod.FVLayoutL
                {
                    Padding = "20";
                    AlcW < = "SI 220";
                    AlcH < = "SI 330";
                    Btn1 : FvWidgets.FButton
                    {
                        Text = "Button 1";
                        BgColor < { R < = "0.0"; G < = "0.0"; B < = "1.0"; }
                        FgColor < { R < = "1.0"; G < = "1.0"; B < = "1.0"; }
                    }
                    Slot_1 : ContainerMod.FVLayoutLSlot;
                    Slot_1.SCp ~ Btn1.Cp;
                    Btn2 : .FvWidgets.FButton
                    {
                        Text = "Button 2";
                        BgColor < { R < = "0.0"; G < = "0.0"; B < = "1.0"; }
                        FgColor < { R < = "1.0"; G < = "1.0"; B < = "1.0"; }
                    }
                    Slot_2 : ContainerMod.FVLayoutLSlot;
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
    }
}
