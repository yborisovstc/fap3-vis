testroot : Elem {
    # "DES controlled Vert/Hrz combined layout. LSC MSO approach."
    + GVisComps
    + ContainerMod2
    VBox : ContainerMod2.DVLayout {
        CreateWdg < Debug.LogLevel = "Dbg"
        SdcInsert < Debug.LogLevel = "Dbg"
        SdcConnWdg < Debug.LogLevel = "Dbg"
        Controlled <  {
            Start.Prev !~ End.Next
            YPadding < = "SI 20"
            AlcW < = "SI 220"
            AlcH < = "SI 330"
            BgColor <  {
                R = "0.0"
                G = "1.0"
                B = "1.0"
                A = "1.0"
            }
            Btn1 : FvWidgets.FButton {
                SText < = "SS 'Button v1'"
                BgColor <  {
                    R = "0.0"
                    G = "0.0"
                    B = "1.0"
                }
                FgColor <  {
                    R = "1.0"
                    G = "1.0"
                    B = "1.0"
                }
            }
            Slot_Btn1 : ContainerMod2.FVLayoutSlot
            Slot_Btn1.SCp ~ Btn1.Cp
            Btn2 : FvWidgets.FButton {
                Explorable = "y"
                Debug.LogLevel = "Dbg"
                AlcY < Debug.LogLevel = "Dbg"
                SText < = "SS 'Button v2'"
                BgColor <  {
                    R = "0.0"
                    G = "0.0"
                    B = "1.0"
                }
                FgColor <  {
                    R = "1.0"
                    G = "0.0"
                    B = "1.0"
                }
                Sdo : SdoCoordOwr (
                    # "SDO coordinates in owner coord system"
                    Level ~ : SI_1
                    InpX ~ AlcX
                    InpY ~ AlcY
                )
                Sdo_Dbg : State (
                    _@ <  {
                        Debug.LogLevel = "Dbg"
                        = "PSI"
                    }
                    Inp ~ Sdo
                )
            }
            Slot_Btn2 : ContainerMod2.FVLayoutSlot
            Slot_Btn2.SCp ~ Btn2.Cp
            Slot_Btn2.Next ~ Slot_Btn1.Prev
            Slot_Btn1.Next ~ Start.Prev
            Slot_Btn2.Prev ~ End.Next
        }
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
                        VBox1 : VBox
                        Slot_VBox1 : ContainerMod2.FHLayoutSlot (
                            SCp ~ VBox1.Cp
                            Next ~ Slot_Btn1.Prev
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
                            Next ~ Slot_VBox1.Prev
                            Prev ~ End.Next
                        )
                    }
                }
            }
        }
        # " Adding new button"
        HBox_AddWdg : ContainerMod2.DcAddWdgSc (
            Enable ~ SB_True
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
