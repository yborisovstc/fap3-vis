testroot : Elem {
    # "Unit test of DES controlled Hrz layout. LSC MSO approach."
    Modules : Node {
        + GVisComps
        + ContainerMod2
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
                HBox : ContainerMod2.DHLayout {
                    CreateWdg < Debug.LogLevel = "Dbg"
                    SdcInsert < Debug.LogLevel = "Dbg"
                    SdcConnWdg < Debug.LogLevel = "Dbg"
                    Controlled <  {
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
                        Slot_Btn1 : ContainerMod2.FHLayoutSlot (
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
                        Slot_Btn2 : ContainerMod2.FHLayoutSlot (
                            SCp ~ Btn2.Cp
                            Next ~ Slot_Btn1.Prev
                            Prev ~ End.Next
                        )
                    }
                }
            }
        }
        # " Adding new button"
        HBox_AddWdg : ContainerMod2.DcAddWdgSc (
            Enable ~ : SB_True
            Name ~ : State {
                = "SS Btn3"
            }
            Parent ~ : State {
                = "SS FvWidgets.FButton"
            }
            Pos ~ : State {
                = "SI 0"
            }
            Mut ~ : State {
                = "CHR2 '{ SText < = \\\"SS Button_3\\\";  BgColor < { R = \\\"0.0\\\"; G = \\\"0.0\\\"; B = \\\"1.0\\\"; } FgColor < { R = \\\"1.0\\\"; G = \\\"1.0\\\"; B = \\\"1.0\\\"; } }'"
            }
        )
        HBox_AddWdg ~ Wnd.Scene.HBox.IoAddWidg
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
        HBox_RmWdg : ContainerMod2.DcRmWdgSc (
            Enable ~ WdgAdded_Tg.Value
            Name ~ : State {
                = "SS Btn1"
            }
        )
        HBox_RmWdg ~ Wnd.Scene.HBox.IoRmWidg
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
