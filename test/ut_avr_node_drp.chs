testroot : Elem
{
    # "UT of Unit DRP";
    Modules : Node
    {
        + GVisComps;
        + FvWidgets;
        + AvrMdl;
    }
    Comps : Elem;
    Test : DesLauncher
    {
        # "Visualisation environment";
        Env : GVisComps.VisEnv;
        Env.VisEnvAgt < Init = "Yes";
        Window : GVisComps.Window
        {
            Init = "Yes";
            Width < = "SI 1200";
            Height < = "SI 800";
            Scene : GVisComps.Scene
            {
                # "Visualisation scene";
                # "- Model";
                Drp : AvrMdl.NodeDrp {
                    Model : Unit {
                        Model_comp1 : Unit;
                        Model_comp2 : Unit;
                    }
                }
                MdlUri : State;
                MdlUri < = "SS Model";
                Drp.InpModelUri ~ MdlUri;
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
    }
}
