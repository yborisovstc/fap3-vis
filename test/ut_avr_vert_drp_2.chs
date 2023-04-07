testroot : Elem {
    # "UT of Vertex DRP. Edges"
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
                        _ <  {
                            Model_vert1 : Vert
                            Model_vert2 : Vert
                            Model_vert1 ~ Model_vert2
                        }
                        _ <  {
                            # "3 cycle. OK"
                            Model_vert1 : Vert
                            Model_vert2 : Vert
                            Model_vert3 : Vert
                            Model_vert1 ~ Model_vert2
                            Model_vert1 ~ Model_vert3
                            Model_vert2 ~ Model_vert3
                        }
                        _ <  {
                            # "4 cycle. OK"
                            Model_vert1 : Vert
                            Model_vert2 : Vert
                            Model_vert3 : Vert
                            Model_vert4 : Vert
                            Model_vert1 ~ Model_vert2
                            Model_vert2 ~ Model_vert3
                            Model_vert3 ~ Model_vert4
                            Model_vert4 ~ Model_vert1
                        }
                        # "4 all. OK"
                        _ <  {
                            Model_vert1 : Vert
                            Model_vert2 : Vert
                            Model_vert3 : Vert
                            Model_vert4 : Vert
                            Model_vert1 ~ Model_vert2
                            Model_vert2 ~ Model_vert3
                            Model_vert3 ~ Model_vert4
                            Model_vert4 ~ Model_vert1
                            Model_vert1 ~ Model_vert3
                            Model_vert2 ~ Model_vert4
                        }
                        # "5 cycle. OK"
                        Model_vert1 : Vert
                        Model_vert2 : Vert
                        Model_vert3 : Vert
                        Model_vert4 : Vert
                        Model_vert5 : Vert
                        Model_vert1 ~ Model_vert2
                        Model_vert2 ~ Model_vert3
                        Model_vert3 ~ Model_vert4
                        Model_vert4 ~ Model_vert5
                        Model_vert5 ~ Model_vert1
                        _ <  {
                            # "5 cycle all. "
                            Model_vert1 : Vert
                            Model_vert2 : Vert
                            Model_vert3 : Vert
                            Model_vert4 : Vert
                            Model_vert5 : Vert
                            Model_vert1 ~ Model_vert2
                            Model_vert2 ~ Model_vert3
                            Model_vert3 ~ Model_vert4
                            Model_vert4 ~ Model_vert5
                            Model_vert5 ~ Model_vert1
                            Model_vert1 ~ Model_vert3
                            Model_vert1 ~ Model_vert4
                            Model_vert2 ~ Model_vert4
                            Model_vert2 ~ Model_vert5
                            Model_vert3 ~ Model_vert5
                        }
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
                DrpCtx : DesCtxSpl @  {
                    _@ <  {
                        ModelMntp : ExtdStateMnodeOutp
                        DrpMagUri : ExtdStateOutp
                    }
                    ModelMntp.Int ~ ModelMntLink.ModelMntpOutp
                    DrpMagUri.Int ~ MdlUri
                }
                # "DRP"
                Drp : AvrMdl2.VertDrp {
                    # "Initial column"
                    Start.Prev !~ End.Next
                    XPadding < = "SI 20"
                    YPadding < = "SI 20"
                    AlcW < = "SI 220"
                    AlcH < = "SI 330"
                    # "First column"
                    Column_0 : ContainerMod.ColumnLayoutSlot
                    Column_0.Next ~ Start.Prev
                    # "First v-tunnel"
                    Column_0_vt : AvrMdl2.VertDrpVtSlot
                    Column_0_vt.Next ~ Column_0.Prev
                    End.Next ~ Column_0_vt.Prev
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
