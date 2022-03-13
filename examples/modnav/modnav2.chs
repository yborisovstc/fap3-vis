testroot : Elem
{
    # "Models navigator. Ver.02. Based on DES controlled widgets";
    Modules : Node
    {
        + GVisComps;
        + FvWidgets;
        + AvrMdl2;
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
            VrvCp : AvrMdl2.VrViewCp;
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
                        Padding < = "SI 2";
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
                    ModelView : ContainerMod.DAlignment;
                    Slot_2.SCp ~ ModelView.Cp;
                    Slot_2.Next ~ Slot_1.Prev;
                    End ~ Slot_2.Prev;
                }
                Scp : ContainerMod.SlotCp;
                Scp ~ VBox.Cp;
                Scp.InpAlcW ~ Cp.Width;
                Scp.InpAlcH ~ Cp.Height;
            }
            Scene.Cp ~ ScCpc;
            VrvCp.NavCtrl.CmdUp ~ Scene.VBox.Toolbar.BtnUp.Pressed;
            Scene.VBox.ModelView.IoAddWidg ~ VrvCp.NavCtrl.MutAddWidget;
        }
        EnvWidth : State;
        EnvHeight : State;
        Title : State;
        EnvWidth ~ Window.Inp_W;
        EnvHeight ~ Window.Inp_H;
        Title ~ Window.Inp_Title;
        # "Visual representation controller";
        Controller : AvrMdl2.VrController
        {
	    ModelMnt < EnvVar = "Model";
            # " Just interim solution";
            Const_SMdlRoot < = "SS ";
        }
        # "ModelView adapter access to managed node";
        Controller.ModelViewUdp.MagOwnerLink ~ Window.Scene.VBox.ModelView;
        Controller.ModelViewUdp < AgentUri : Content { = "_$"; }
        Controller.WindowEdp.MagOwnerLink ~ Window;
        Controller.WindowEdp < AgentUri : Content  { = "_$"; }
        # "Binding Controller and Window";
        Controller.CtrlCp ~ Window.VrvCp;
    }
}
