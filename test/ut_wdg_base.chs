testroot : Elem
{
    # "Unit test of Widget base agent";
    Modules : Node
    {
        + GVisComps;
        + FvWidgets;
    }
    Launcher :  DesLauncher
    {
        Env : GVisComps.VisEnv
        {
            # "Visualisation environment";
            VisEnvAgt < Init = "Yes"; 
            Wnd : GVisComps.Window
            {
                Init = "Yes";
                Width <  = "SI 1200";
                Height < = "SI 800";
                Scene : GVisComps.Scene
                {
                    # "Visualisation scene";
                    Wdg1 : FvWidgets.FWidget
                    {
                        BgColor < { R < = "0.0"; G < = "1.0"; B < = "0.0"; }
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
        }
        Env.EnvWidth < = "SI 640";
        Env.EnvHeight < = "SI 480";
        Env.Title < = "SS Title";
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
        IncrData < = "SI 1";
        IncrData ~ IncrW.Inp;
        IncrW ~ WdgWidth.Inp;
        WdgWidth ~ IncrW.Inp;
        IncrData ~ IncrH.Inp;
        IncrH ~ WdgHeight.Inp;
        WdgHeight ~ IncrH.Inp;
        WdgWidth ~ Env.Wnd.Scene.Wdg1Cp.InpAlcW;
        WdgHeight ~ Env.Wnd.Scene.Wdg1Cp.InpAlcH;
    }
}
