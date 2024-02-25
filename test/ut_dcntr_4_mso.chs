testroot : Elem {
    # "DES controlled Vert layout. Massive insertion"
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
                Box : ContainerMod2.DVLayout {
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
        # "Items Iterator"
        ItemsIter : DesUtils.IdxItr (
            InpCnt ~ : Const {
                = "SI 40"
            }
            InpReset ~ : SB_False
        )
        # " Pause sync"
        Clms_Sync : ContainerMod2.DcSyncSc
        Clms_Sync ~ Wnd.Scene.Box.IoSync
        Clms_Sync.Pause ~ : SB_True
        # " Adding new button"
        HBox_AddWdg : ContainerMod2.DcAddWdgSc (
            Enable ~ : SB_True
            Name ~ ItemName : TrApndVar (
                Inp1 ~ : Const {
                    = "SS Bnt_"
                }
                Inp2 ~ : TrTostrVar (
                    Inp ~ ItemsIter.Outp
                )
            )
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
        HBox_AddWdg ~ Wnd.Scene.Box.IoAddWidg
        ItemsIter.InpDone ~ HBox_AddWdg.Added
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
            _ <  {
                Enable ~ WdgAdded_Tg.Value
            }
            Enable ~ ItemsIter.OutpDone
            HBox_RmWdg.Name ~ : State {
                = "SS Btn1"
            }
        )
        HBox_RmWdg ~ Wnd.Scene.Box.IoRmWidg
        RmWdg_Dbg : State (
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "SB false"
            }
            Inp ~ HBox_RmWdg.Done
        )
        WdgAdded_Tg.InpR ~ HBox_RmWdg.Done
        Clms_Sync.Resume ~ HBox_RmWdg.Done
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
