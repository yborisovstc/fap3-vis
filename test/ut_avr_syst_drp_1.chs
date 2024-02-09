testroot : Elem {
    # "UT of System DRP. Edges"
    + GVisComps
    + FvWidgets
    + AvrMdl2
    Comps : Elem
    Test : DesLauncher {
        Debug.LogLevel = "Dbg"
        _ <  {
            Debug.OwdLogLevel = "Err"
        }
        # "Visualisation environment"
        Env : GVisComps.VisEnv
        Env.VisEnvAgt < Init = "Yes"
        Window : GVisComps.Window {
            Init = "Yes"
            Width < = "SI 2400"
            Height < = "SI 800"
            Scene : GVisComps.Scene {
                # "Visualisation scene"
                # "- Model"
                ModelMnt : Node {
                    Model : Syst {
                        Model_syst1 : Syst {
                            # "System 1"
                            SysInp1 : ExtdStateInp
                            SysInp2 : ExtdStateInp
                            SysInp3 : ExtdStateInp
                            SysOutp1 : ExtdStateOutp
                            SysOutp2 : ExtdStateOutp
                            SysOutp3 : ExtdStateOutp
                        }
                        Model_syst2 : Syst {
                            # "System 2"
                            SysInp1 : ExtdStateInp
                            SysInp2 : ExtdStateInp
                            SysInp3 : ExtdStateInp
                            SysOutp1 : ExtdStateOutp
                            SysOutp2 : ExtdStateOutp
                        }
                        Model_syst3 : Syst {
                            # "System 3"
                            SysInp1 : ExtdStateInp
                            SysInp2 : ExtdStateInp
                            SysOutp1 : ExtdStateOutp
                        }

                        Model_syst1.SysOutp1 ~ Model_syst2.SysInp1
                        Model_syst2.SysOutp2 ~ Model_syst3.SysInp1
                        Model_syst3.SysInp2 ~ Model_syst1.SysOutp2
                        Model_syst3.SysOutp1 ~ Model_syst1.SysInp2
                    }
                }
                ModelMntLink : Link {
                    ModelMntpOutp : CpStateMnodeOutp
                }
                ModelMntLink ~ ModelMnt
                MdlUri : State {
                    = "URI Model"
                }
                # "DRP context"
                DrpCtx : DesCtxSpl (
                    _@ <  {
                        ModelMntp : ExtdStateMnodeOutp
                        DrpMagUri : ExtdStateOutp
                    }
                    ModelMntp.Int ~ ModelMntLink.ModelMntpOutp
                    DrpMagUri.Int ~ MdlUri
                )
                # "DRP"
                Drp : AvrMdl2.SystDrp {
                    XPadding < = "SI 20"
                    YPadding < = "SI 20"
                    AlcW < = "SI 220"
                    AlcH < = "SI 330"
                }
            }
        }
        EnvWidth : State
        EnvHeight : State
        Title : State
        EnvWidth ~ Window.Inp_W
        EnvHeight ~ Window.Inp_H
        Title ~ Window.Inp_Title
        EnvWidth < = "SI 640"
        EnvHeight < = "SI 480"
        Title < = "SS Title"
    }
}
