testroot : Elem
{
    # "Unit test of Button agent";
    Modules : Node
    {
        + GVisComps;
        + FvWidgets;
    }
    Launcher :  DesLauncher
    {
        Test : Des
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
                    Wdg1 : FvWidgets.FButton
                    {
                        Text = "Button 1";
                        BgColor < { R < = "1.0"; G < = "1.0"; B < = "0.0"; }
                        AlcX < = "SI 200";
                        AlcY < = "SI 100";
                        AlcW < = "SI 200";
                        AlcH < = "SI 20";
                    }
                    Wdg1Cp : FvWidgets.Modules.WidgetCpc;
                    Wdg1Cp ~ Wdg1.Cp;
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
            # " Increasing size of widget";
            WdgWidth : State
            {
                Debug : Content { Update : Content { = "y"; } }
                = "SI 40";
            }
            WdgHeight : State
            {
                Debug : Content { Update : Content { = "y"; } }
                = "SI 60";
            }
            IncrW : TrAddVar;
            IncrH : TrAddVar;
            IncrData : State;
            IncrData < = "SI 0";
            IncrData ~ IncrW.Inp;
            IncrW ~ WdgWidth.Inp;
            WdgWidth ~ IncrW.Inp;
            IncrData ~ IncrH.Inp;
            IncrH ~ WdgHeight.Inp;
            WdgHeight ~ IncrH.Inp;
            WdgWidth ~ Wnd.Scene.Wdg1Cp.InpAlcW;
            WdgHeight ~ Wnd.Scene.Wdg1Cp.InpAlcH;
        }
    }
}