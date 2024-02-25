testroot : Elem {
    # "Unit test of DES controlled Hrz layout"
    Modules : Node {
        + GVisComps
        + ContainerMod
    }
    Test : DesLauncher {
        # "Visualisation environment"
        Debug.LogLevel = "Dbg"
        VEnv : GVisComps.VisEnv
        VEnv.VisEnvAgt < Init = "Yes"
        # "Window"
        Wnd : GVisComps.Window {
            Init = "Yes"
            Width < = "SI 1200"
            Height < = "SI 800"
            Scene : GVisComps.Scene {
                # "Visualisation scene"
                HBox : ContainerMod.DHLayout {
                    CreateWdg < Debug.LogLevel = "Dbg"
                    SdcInsert < Debug.LogLevel = "Dbg"
                    SdcConnWdg < Debug.LogLevel = "Dbg"
                    Start.Prev !~ End.Next
                    XPadding < = "SI 20"
                    AlcW < = "SI 220"
                    AlcH < = "SI 330"
                    Btn1 : FvWidgets.FButton {
                        SText < = "SS 'Button 1'"
                        BgColor <  {
                            R = "0.0"
                            G = "0.0"
                            B = "1.0"
                            A = "1.0"
                        }
                        FgColor <  {
                            R = "1.0"
                            G = "1.0"
                            B = "1.0"
                        }
                    }
                    Slot_Btn1 : ContainerMod.FHLayoutSlot (
                        SCp ~ Btn1.Cp
                        Next ~ Start.Prev
                    )
                    Btn2 : FvWidgets.FButton {
                        SText < = "SS 'Button 2'"
                        BgColor <  {
                            R = "0.0"
                            G = "0.0"
                            B = "1.0"
                            A = "1.0"
                        }
                        FgColor <  {
                            R = "1.0"
                            G = "1.0"
                            B = "1.0"
                        }
                    }
                    Slot_Btn2 : ContainerMod.FHLayoutSlot (
                        SCp ~ Btn2.Cp
                        Next ~ Slot_Btn1.Prev
                        Prev ~ End.Next
                    )
                }
            }
        }
        # " Adding new button"
        HBox_AddWdg : ContainerMod.DcAddWdgSc
        HBox_AddWdg ~ Wnd.Scene.HBox.IoAddWidg
        HBox_AddWdg.Enable ~ : State {
            = "SB true"
        }
        HBox_AddWdg.Name ~ : State {
            = "SS Btn3"
        }
        HBox_AddWdg.Parent ~ : State {
            = "SS FvWidgets.FButton"
        }
        HBox_AddWdg.Pos ~ : State {
            = "SI 0"
        }
        HBox_AddWdg.Mut ~ : State {
            = "CHR2 '{ SText < = \\\"SS Button_3\\\";  BgColor < { R = \\\"0.0\\\"; G = \\\"0.0\\\"; B = \\\"1.0\\\"; } FgColor < { R = \\\"1.0\\\"; G = \\\"1.0\\\"; B = \\\"1.0\\\"; } }'"
        }
        AddedWdg_Dbg : State (
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "SB false"
            }
            Inp ~ HBox_AddWdg.Added
        )
        # "We need to use trigger that keeps WdgAdded indication. This is because Add/Rm internal ops breaks the indication."
        WdgAdded_Tg : DesUtils.RSTg
        WdgAdded_Tg.InpS ~ HBox_AddWdg.Added
        # " Removing button 1"
        HBox_RmWdg : ContainerMod.DcRmWdgSc
        HBox_RmWdg ~ Wnd.Scene.HBox.IoRmWidg
        HBox_RmWdg.Enable ~ WdgAdded_Tg.Value
        HBox_RmWdg.Name ~ : State {
            = "SS Btn1"
        }
        RmWdg_Dbg : State (
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "SB false"
            }
            Inp ~ HBox_RmWdg.Done
        )
        WdgAdded_Tg.InpR ~ HBox_RmWdg.Done
        # " Misc env"
        EnvWidth : State
        EnvHeight : State
        Title : State
        EnvWidth ~ Wnd.Inp_W
        EnvHeight ~ Wnd.Inp_H
        Title ~ Wnd.Inp_Title
        EnvWidth < = "SI 640"
        EnvHeight < = "SI 480"
        Title < = "SS Title"
    }
}
