testroot : Elem {
    # "Unit test of VertDrp as the widget of hlayout"
    + GVisComps
    + ContainerMod
    + AvrMdl2
    Test : DesLauncher {
        # "Visualisation environment"
        VEnv : GVisComps.VisEnv
        VEnv.VisEnvAgt < Init = "Yes"
        # "Window"
        Wnd : GVisComps.Window {
            Init = "Yes"
            Width < = "SI 2000"
            Height < = "SI 800"
            Scene : GVisComps.Scene {
                # "Visualisation scene"
                # "- Model"
                ModelMntp : Node {
                    Model : Syst {
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
                    }
                }
                ModelMntLink : Link {
                    ModelMntpOutp : CpStateMnodeOutp
                }
                ModelMntLink ~ ModelMntp
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
                HBox : ContainerMod.DHLayout {
                    Start.Prev !~ End.Next
                    XPadding < = "SI 20"
                    AlcW < = "SI 420"
                    AlcH < = "SI 330"
                    # "DRP"
                    Drp1 : AvrMdl2.VertDrp {
                        XPadding < = "SI 20"
                        YPadding < = "SI 20"
                    }
                    Drp2 : AvrMdl2.VertDrp {
                        XPadding < = "SI 20"
                        YPadding < = "SI 20"
                    }
                    Slot_1 : ContainerMod.FHLayoutSlot (
                        SCp ~ Drp1.Cp
                        Next ~ Start.Prev
                    )
                    ColView2 : ColumnsView {
                        XPadding < = "SI 5"
                        YPadding < = "SI 5"
                    }
                    Slot_2 : ContainerMod.FHLayoutSlot (
                        SCp ~ Drp2.Cp
                        Next ~ Slot_1.Prev
                        Prev ~ End.Next
                    )
                }
            }
            # " Misc env"
            EnvWidth : State
            EnvHeight : State
            Title : State
            EnvWidth ~ Wnd.Inp_W
            EnvHeight ~ Wnd.Inp_H
            Title ~ Wnd.Inp_Title
            EnvWidth < = "SI 720"
            EnvHeight < = "SI 480"
            Title < = "SS Title"
        }
    }
}
