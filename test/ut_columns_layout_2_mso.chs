testroot : Elem {
    # "Unit test of DES controlled columns layout. Controlled creation."
    + GVisComps
    + ContainerMod2
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
                ColumnsView : ContainerMod2.ColumnsLayout {
                    Controlled <  {
                        Start.Prev !~ End.Next
                        XPadding < = "SI 20"
                        YPadding < = "SI 20"
                        AlcW < = "SI 220"
                        AlcH < = "SI 330"
                        Column1 : ContainerMod2.ColumnLayoutSlot {
                            Start.Prev !~ End.Next
                        }
                        Btn1 : FvWidgets.FButton {
                            AlcX < Debug.LogLevel = "Dbg"
                            AlcY < Debug.LogLevel = "Dbg"
                            AlcW < Debug.LogLevel = "Dbg"
                            SText < = "SS 'Column1 Button 1, Hello'"
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
                                A = "1.0"
                            }
                        }
                        Slot_Btn1 : ContainerMod2.ColumnItemSlot
                        Slot_Btn1.SCp ~ Btn1.Cp
                        Btn2 : FvWidgets.FButton {
                            AlcX < Debug.LogLevel = "Dbg"
                            AlcY < Debug.LogLevel = "Dbg"
                            SText < = "SS 'Column1 Button 2'"
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
                                A = "1.0"
                            }
                        }
                        Slot_Btn2 : ContainerMod2.ColumnItemSlot
                        Slot_Btn2.SCp ~ Btn2.Cp
                        Slot_Btn2.Next ~ Slot_Btn1.Prev
                        Slot_Btn1.Next ~ Column1.Start.Prev
                        Slot_Btn2.Prev ~ Column1.End.Next
                        Column1.Next ~ Start.Prev
                        Column2 : ContainerMod2.ColumnLayoutSlot {
                            Start.Prev !~ End.Next
                        }
                        Btn3 : FvWidgets.FButton {
                            AlcX < Debug.LogLevel = "Dbg"
                            AlcY < Debug.LogLevel = "Dbg"
                            SText < = "SS 'Column2 Button 1'"
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
                                A = "1.0"
                            }
                        }
                        Slot_Btn3 : ContainerMod2.ColumnItemSlot
                        Slot_Btn3.SCp ~ Btn3.Cp
                        Btn4 : FvWidgets.FButton {
                            AlcX < Debug.LogLevel = "Dbg"
                            AlcY < Debug.LogLevel = "Dbg"
                            SText < = "SS 'Column2 Button 2'"
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
                                A = "1.0"
                            }
                        }
                        Slot_Btn4 : ContainerMod2.ColumnItemSlot
                        Slot_Btn4.SCp ~ Btn4.Cp
                        Slot_Btn4.Next ~ Slot_Btn3.Prev
                        Slot_Btn3.Next ~ Column2.Start.Prev
                        Slot_Btn4.Prev ~ Column2.End.Next
                        Column2.Next ~ Column1.Prev
                        End.Next ~ Column2.Prev
                    }
                }
            }
        }
        # " Adding new button"
        _ <  {
            Wnd.Scene.ColumnsView.CreateWdg < Debug.LogLevel = "Dbg"
        }
        Clms_Sync : ContainerMod2.DcSyncSc
        Clms_Sync ~ Wnd.Scene.ColumnsView.IoSync
        Clms_Sync.Pause ~ : SB_True
        Clms_AddWdg : ContainerMod2.DcAddWdgSc (
            Enable ~ : State {
                = "SB true"
            }
            Name ~ WdgNameSel : TrSwitchBool (
                Inp1 ~ : State {
                    = "SS BtnNew"
                }
                Inp2 ~ : State {
                    = "SS BtnNew_2"
                }
            )
            Parent ~ : State {
                = "SS FvWidgets.FButton"
            }
            Pos ~ : State {
                = "SI 1"
            }
            Mut ~ : State {
                = "CHR2 '{ SText < = \\\"SS Button_New\\\";  BgColor < { R = \\\"0.0\\\"; G = \\\"0.0\\\"; B = \\\"1.0\\\";  A = \\\"1.0\\\"; } FgColor < { R = \\\"1.0\\\"; G = \\\"1.0\\\"; B = \\\"1.0\\\"; } }'"
            }
        )
        Clms_AddWdg ~ Wnd.Scene.ColumnsView.IoAddWidg
        AddedWdg_Dbg : State (
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "SB false"
            }
            Inp ~ Clms_AddWdg.Added
        )
        # " Adding new column"
        Clms_AddCol : ContainerMod2.ClAddColumnSm (
            Enable ~ Clms_AddWdg.Added
            Name ~ : State {
                = "SS New_column"
            }
        )
        AddedColumn : State (
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "SB false"
            }
            Inp ~ Clms_AddCol.Done
        )
        Clms_Sync.Resume ~ Clms_AddCol.Done
        WdgNameSel.Sel ~ Clms_AddCol.Done
        Clms_AddCol ~ Wnd.Scene.ColumnsView.IoAddColumn
        # "Adding button to new column"
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
