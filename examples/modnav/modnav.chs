testroot : Elem
{
    # "Models navigator";
    Modules : Node
    {
        + GVisComps;
        + FvWidgets;
        + AvrMdl;
    }
    Launcher : VDesLauncher
    {
        # "Visualisation environment";
        Env : GVisComps.VisEnv;
        Env.VisEnvAgt < Init = "Yes";
        Window : GVisComps.Window
        {
            VrpViewAgent : AVrpView;
            Init = "Yes";
            Width < = "SI 1200";
            Height < = "SI 800";
            VrvCp : AvrMdl.VrViewCp;
            # "Agent VrpViewAgent sets value to NodeSelected state";
            VrvCp.NavCtrl.NodeSelected ~ NodeSelected : State
            {
                Debug : Content { Update : Content { = "y"; } }
                = "SS nil";
            };
            # "Node selected reset fragment !!";
            NodeSelected.Inp ~ : State { = "SS nil"; };
            Scene : GVisComps.Scene
            {
                VBox : ContainerMod.FVLayout
                {
                    About : Content { = "Application view main vertical layout"; }
                    Slot_1 : ContainerMod.FVLayoutSlot;
                    Slot_1.Next ~ Start;
                    Toolbar : ContainerMod.FHLayout
                    {
                        About : Content { = "Application toolbar"; }
                        Padding = "SI 2";
                        Slot_1 : ContainerMod.FHLayoutSlot;
                        Slot_1.Next ~ Start;
                        BtnUp : FvWidgets.FButton
                        {
                            Text = "Up";
                            BgColor < { R < = "0.0"; G < = "0.0"; B < = "1.0"; }
                            FgColor < { R < = "1.0"; G < = "1.0"; B < = "1.0"; }
                        }
                        Slot_1.SCp ~ BtnUp.Cp;
                        Slot_2 : ContainerMod.FHLayoutSlot;
                        Slot_2.Next ~ Slot_1.Prev;
                        Btn2 : FvWidgets.FButton
                        {
                            Text = "Button 2";
                            BgColor < { R < = "0.0"; G < = "0.0"; B < = "1.0"; }
                            FgColor < { R < = "1.0"; G < = "1.0"; B < = "1.0"; }
                        }
                        Slot_2.SCp ~ Btn2.Cp;
                        Slot_3 : ContainerMod.FHLayoutSlot;
                        Slot_3.Next ~ Slot_2.Prev;
                        End ~ Slot_3.Prev;
                        Btn3 : FvWidgets.FButton
                        {
                            Text = "Button 3";
                            BgColor < { R < = "0.0"; G < = "0.0"; B < = "1.0"; }
                            FgColor < { R < = "1.0"; G < = "1.0"; B < = "1.0"; }
                        }
                        Slot_3.SCp ~ Btn3.Cp;
                    }
                    Slot_1.SCp ~ Toolbar.Cp;
                    Slot_2 : ContainerMod.FVLayoutSlot;
                    ModelView : ContainerMod.Alignment;
                    Slot_2.SCp ~ ModelView.Cp;
                    Slot_2.Next ~ Slot_1.Prev;
                    End ~ Slot_2.Prev;
                    TestMvCompsCount : State {
                        Debug : Content { Update : Content { = "y"; } }
                        = "SI 0";
                    }
                    TestMvCompsCount.Inp ~ ModelView.OutCompsCount;
                }
                Scp : ContainerMod.SlotCp;
                Scp ~ VBox.Cp;
                Scp.InpAlcW ~ Cp.Width;
                Scp.InpAlcH ~ Cp.Height;
            }
            Scene.Cp ~ ScCpc;
            VrvCp.NavCtrl.CmdUp ~ Scene.VBox.Toolbar.BtnUp.Pressed;
            Scene.VBox.ModelView.InpMutAddWidget ~ VrvCp.NavCtrl.MutAddWidget;
            Scene.VBox.ModelView.InpMutRmWidget ~ VrvCp.NavCtrl.MutRmWidget;
            Scene.VBox.ModelView.OutCompsCount ~ VrvCp.NavCtrl.DrpCreated;
            Scene.VBox.ModelView.OutCompsCount ~ VrvCp.NavCtrl.VrvCompsCount;
        }
        EnvWidth : State;
        EnvHeight : State;
        Title : State;
        EnvWidth ~ Window.Inp_W;
        EnvHeight ~ Window.Inp_H;
        Title ~ Window.Inp_Title;
        # "Visual representation controller";
        Controller : AvrMdl.VrController
        {
            # "DrpMp = .testroot.Test.Window.Scene.VBox.ModelView;";
            ModelViewUdp < AgentUri : Content { = "SS .testroot.Test.Window.Scene.VBox.ModelView"; }
            WindowEdp < AgentUri : Content  { = "SS .testroot.Test.Window"; }
            # " Just interim solution";
            Const_SMdlRoot < = "SS .testroot.Test.Controller.ModelMnt.*";
        }
        Controller.CtrlCp ~ Window.VrvCp;
    }
}
