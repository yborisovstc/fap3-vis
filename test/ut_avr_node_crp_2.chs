testroot : Elem
{
    # "UT of Node CRP";
    Modules : Node
    {
        + GVisComps;
        + FvWidgets;
        + AvrMdl2;
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
                ModelMnt : Node {
                    Model : Unit {
                        Model_comp1 : Unit;
                        Model_comp2 : Unit;
                        Model_comp3 : Unit;
                        Model_comp4 : Unit;
                    }
                }
                ModelMntLink : Link {
                   ModelMntpOutp : CpStateMnodeOutp;
                }
                ModelMntLink ~ ModelMnt;

                Crp : AvrMdl2.NodeCrp3 {
                    # "CRP under test";
                }
                MdlUri : State {
                    = "SS Model";
                }
                CrpCp : AvrMdl2.CrpCpp @ {
                    ModelMntp ~ ModelMntLink.ModelMntpOutp;
                    ModelUri ~ MdlUri;
                }
                CrpCp ~ Crp.RpCp;
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
