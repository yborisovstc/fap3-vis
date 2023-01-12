testroot : Elem {
    # "Models navigator. Ver.02. Based on DES controlled widgets"
    + GVisComps
    + FvWidgets
    + AvrMdl2
    Launcher : VDesLauncher {
        # "Visualisation environment"
        Env : GVisComps.VisEnv
        Env.VisEnvAgt < Init = "Yes"
        Window : GVisComps.Window {
            VrpViewAgent : AVrpView
            Init = "Yes"
            Width < = "SI 1200"
            Height < = "SI 800"
            VrvCp : AvrMdl2.VrViewCp
            # "DRP context"
            DrpCtx : DesCtxSpl @  {
                _@ <  {
                    ModelMntp : ExtdStateMnodeOutp
                    DrpMagUri : ExtdStateOutp
                }
                ModelMntp.Int ~ VrvCp.NavCtrl.DrpCp.InpModelMntp
                DrpMagUri.Int ~ VrvCp.NavCtrl.DrpCp.InpModelUri
            }
            Scene : GVisComps.Scene {
                # "Scene"
                VBox : ContainerMod.DVLayout {
                    About = "Application view main vertical layout"
                    End.Next !~ Start.Prev
                    Slot_1 : ContainerMod.FVLayoutSlot
                    Slot_1.Next ~ Start.Prev
                    Toolbar : ContainerMod.DHLayout {
                        About = "Application toolbar"
                        End.Next !~ Start.Prev
                        XPadding < = "SI 5"
                        YPadding < = "SI 4"
                        BtnUp : FvWidgets.FButton {
                            SText < = "SS Up"
                            BgColor <  {
                                R < = "0.0"
                                G < = "0.0"
                                B < = "1.0"
                                A < = "1.0"
                            }
                            FgColor <  {
                                R < = "1.0"
                                G < = "1.0"
                                B < = "1.0"
                            }
                        }
                        Slot_1 : ContainerMod.FHLayoutSlot @  {
                            Next ~ Start.Prev
                            SCp ~ BtnUp.Cp
                        }
                        Btn2 : FvWidgets.FButton {
                            SText < = "SS Button 2"
                            BgColor <  {
                                R < = "0.0"
                                G < = "0.0"
                                B < = "1.0"
                                A < = "1.0"
                            }
                            FgColor <  {
                                R < = "1.0"
                                G < = "1.0"
                                B < = "1.0"
                            }
                        }
                        Slot_2 : ContainerMod.FHLayoutSlot @  {
                            Next ~ Slot_1.Prev
                            SCp ~ Btn2.Cp
                        }
                        Btn3 : FvWidgets.FButton {
                            SText < = "SS Button 3"
                            BgColor <  {
                                R < = "0.0"
                                G < = "0.0"
                                B < = "1.0"
                                A < = "1.0"
                            }
                            FgColor <  {
                                R < = "1.0"
                                G < = "1.0"
                                B < = "1.0"
                            }
                        }
                        Slot_3 : ContainerMod.FHLayoutSlot @  {
                            Next ~ Slot_2.Prev
                            SCp ~ Btn3.Cp
                            Prev ~ End.Next
                        }
                    }
                    Slot_1.SCp ~ Toolbar.Cp
                    Slot_2 : ContainerMod.FVLayoutSlot
                    ModelView : ContainerMod.DAlignment
                    Slot_2.SCp ~ ModelView.Cp
                    Slot_2.Next ~ Slot_1.Prev
                    End.Next ~ Slot_2.Prev
                }
                Scp : ContainerMod.SlotCp
                Scp ~ VBox.Cp
                Scp.InpAlcW ~ Cp.Width
                Scp.InpAlcH ~ Cp.Height
            }
            Scene.Cp ~ ScCpc
            VrvCp.NavCtrl.CmdUp ~ Scene.VBox.Toolbar.BtnUp.Pressed
            Scene.VBox.ModelView.IoAddWidg ~ VrvCp.NavCtrl.MutAddWidget
            Scene.VBox.ModelView.IoRmWidg ~ VrvCp.NavCtrl.MutRmWidget
            # "Node selected new desing debug"
            VBoxCpc : FvWidgets.WidgetCpc
            VBoxCpc ~ Scene.VBox.Cp
            NodeSelected2 : State @  {
                _@ <  {
                    Debug.LogLevel = "Dbg"
                    = "URI _INV"
                }
                Inp ~ Nsl : TrTailVar @  {
                    Inp ~ : TrHeadVar @  {
                        Inp ~ VBoxCpc.LbpUri
                        Tail ~ : State {
                            = "URI Header.Name"
                        }
                    }
                    Head ~ : State {
                        = "URI VBox.ModelView.Drp"
                    }
                }
            }
            NodeSelected : State @  {
                _@ <  {
                    Debug.LogLevel = "Dbg"
                    = "URI _INV"
                }
            }
            VrvCp.NavCtrl.NodeSelected ~ NodeSelected2
        }
        EnvWidth : State
        EnvHeight : State
        Title : State
        EnvWidth ~ Window.Inp_W
        EnvHeight ~ Window.Inp_H
        Title ~ Window.Inp_Title
        # "Visual representation controller"
        Controller : AvrMdl2.VrController {
            ModelMnt < EnvVar = "Model"
        }
        # "Binding Controller and Window"
        Controller.CtrlCp ~ Window.VrvCp
    }
}
