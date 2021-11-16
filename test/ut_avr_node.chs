testroot : Elem
{
    # "Unit test of agents visual representation, unit";
    Modules : Node
    {
        + GVisComps;
        + FvWidgets;
    }
    Comps : Elem;
    Test : DesLauncher
    {
        Env : GVisComps.VisEnv;
        # "Visualisation environment";
        Env.VisEnvAgt < Init = "Yes";
        Window : GVisComps.Window
        {
            Init = "Yes";
            Width < = "SI 1200";
            Height < = "SI 800";
            Scene : GVisComps.Scene
            {
                # "Visualisation scene";
                Wdg1 : FvWidgets.FNodeCrp
                {
		    BgColor < { R < = "1.0"; G < = "1.0"; B < = "1.0"; }
                    AlcW < = "SI 80";
                    AlcH < = "SI 100";
                }
                Wdg1Cp : FvWidgets.WidgetCpc;
                Wdg1Cp ~ Wdg1.Cp;
            }
        }
        EnvWidth : State;
        EnvHeight : State;
        Title : State;
        EnvWidth ~ Window.Inp_W;
        EnvHeight ~ Window.Inp_H;
        Title ~ Window.Inp_Title;
        EnvWidth < = "SI 640";
        EnvHeight < = "SI 480";
        Title < = "SS Title";
        # " Increasing size of widget";
        WdgWidth : State;
        WdgWidth < {
            Debug : Content { Update : Content { = "y"; } }
            = "SI 40";
        }
        WdgHeight : State;
        WdgHeight < {
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
        WdgWidth ~ Window.Scene.Wdg1Cp.InpAlcW;
        WdgHeight ~ Window.Scene.Wdg1Cp.InpAlcH;
    }
}
