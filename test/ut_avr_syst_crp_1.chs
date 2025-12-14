testroot : Elem {
    # "UT of Syst CRP"
    + GVisComps
    + FvWidgets
    + AvrMdl2
    Comps : Elem
    Test : DesLauncher {
        _@ < Debug.LogLevel = "Dbg"
        # "Visualisation environment"
        Env : GVisComps.VisEnv
        Env.VisEnvAgt < Init = "Yes"
        Window : GVisComps.Window {
            Init = "Yes"
            Width < = "SI 1200"
            Height < = "SI 800"
            Scene : GVisComps.Scene {
                # "Visualisation scene"
                # "- Model"
                ModelMnt : Node {
                    Model : Syst {
                        Model_syst1 : Syst {
                            # "System 1"
                            SysInp1 : ExtdStateInp
                            _ <  {
                                SysInp2 : ExtdStateInp
                                SysInp3 : ExtdStateInp
                                SysOutp1 : ExtdStateOutp
                                SysOutp2 : ExtdStateOutp
                                SysOutp3 : ExtdStateOutp
                            }
                        }
                    }
                }
                ModelMntLink : Link {
                    ModelMntpOutp : CpStateMnodeOutp
                }
                ModelMntLink ~ ModelMnt
                View : ContainerMod.DAlignment {
                    End.Next !~ Start.Prev
                    Model_syst1 : AvrMdl2.SystCrp {
                        # "CRP under test"
                    }
                    Slot_Crp : ContainerMod.AlignmentSlot (
                        Next ~ Start.Prev
                        Prev ~ End.Next
                        SCp ~ Crp.Cp
                    )
                }
                CrpCtx : DesCtxSpl (
                    _@ <  {
                        ModelMntp : ExtdStateMnodeOutp
                        DrpMagUri : ExtdStateOutp
                    }
                    ModelMntp.Int ~ ModelMntLink.ModelMntpOutp
                    DrpMagUri.Int ~ : Const {
                        = "SS Model"
                    }
                )
            }
        }
        EnvWidth : State
        EnvHeight : State
        Title : State
        EnvWidth ~ Window.Inp_W
        EnvHeight ~ Window.Inp_H
        Title ~ Window.Inp_Title
        Title < = "SS Title"
    }
}
