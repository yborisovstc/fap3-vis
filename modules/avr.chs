AvrMdl : Elem
{
    About : Content {  = "Agents visual representations"; }
    Modules : Node
    {
        + FvWidgets;
        + ContainerMod;
    }
    NDrpCp : Socket
    {
        # "Node DRP output socket";
        InpModelUri : CpStateInp;
        OutCompsCount : CpStateOutp;
        OutModelUri : CpStateOutp;
    }
    NDrpCpp : Socket
    {
        # "Node DRP output socket";
        InpModelUri : CpStateOutp;
        OutCompsCount : CpStateInp;
        OutModelUri : CpStateInp;
    }
    NDrpCpe : AExtd
    {
        Int : NDrpCp;
    }
    NodeDrp : ContainerMod.FHLayoutBase
    {
        # " Node detail representation";
        CntAgent : ANodeDrp {
            ModelSynced : State {
                = "SB false";
            }
        }
        Padding = "10";
        RpCp : AExtd
        {
            Int : NDrpCpp;
        }
        RpCp.Int.OutCompsCount ~ OutCompsCount;
        # "Needs to use auxiliary cp to IFR from socket";
        InpModelUri : CpStateInp;
        RpCp.Int.InpModelUri ~ InpModelUri;
        OutModelUri : CpStateOutp;
        RpCp.Int.OutModelUri ~ OutModelUri;
    }
    SystDrp : ContainerMod.FHLayoutBase
    {
        # " Syst detail representation";
        CntAgent : ASystDrp;
        CntAgent < {
            ModelSynced : State;
            ModelSynced < Value = "SB false";
        }
        Padding = "10";
        InpModelUri : CpStateInp;
    }
    VrViewCp : Socket
    {
        About = "Vis representation view CP";
        NavCtrl : Socket
        {
            About = "Navigation control";
            CmdUp : CpStateInp;
            NodeSelected : CpStateInp;
            MutAddWidget : CpStateOutp;
            MutRmWidget : CpStateOutp;
            VrvCompsCount : CpStateInp;
            DrpCreated : CpStateInp;
            DrpCp : NDrpCpp;
        }
    }
    VrControllerCp : Socket
    {
        About = "Vis representation controller CP";
        NavCtrl : Socket
        {
            About = "Navigation control";
            CmdUp : CpStateOutp;
            NodeSelected : CpStateOutp;
            MutAddWidget : CpStateInp;
            MutRmWidget : CpStateInp;
            DrpCreated : CpStateOutp;
            VrvCompsCount : CpStateOutp;
            DrpCp : NDrpCp;
        }
    }
    VrController : Des
    {
        # " Visual representation controller";
        # " Model adapter. Set AgentUri content to model URI.";
        CursorUdp : AdpComps.UnitAdp;
        # " Model view adapter. Set AgentView cnt to model view.";
        ModelViewUdp : AdpComps.UnitAdp;
        # " Window MElem adapter";
        WindowEdp : AdpComps.MelemAdp;
        # "Model mounting";
        ModelMnt : AMntp;
        ModelMnt < EnvVar = "Model";
        # "Model adapter";
        ModelUdp : AdpComps.UnitAdp;
        ModelUdp.AdpAgent < AgentUri = "........ModelMnt";
        # "CP binding to view";
        CtrlCp : VrControllerCp;
        # " Cursor";
        CursorUdp.InpMagUri ~ Cursor : State {
            Debug : Content { Update : Content { = "y"; } }
            = "SS nil";
        };
        Const_SNil : State {
            Value = "SS nil";
        }
        # "For debugging only";
        DbgCursorOwner : State {
            Debug : Content { Update : Content { = "y"; } }
            Value = "SS nil";
        }
        DbgCursorOwner.Inp ~ CursorUdp.Owner;
        DbgCmdUp : State {
            Debug : Content { Update : Content { = "y"; } }
            = "SB false";
        }
        DbgCmdUp.Inp ~ CtrlCp.NavCtrl.CmdUp;
        Cursor.Inp ~ : ATrcSwitchBool @ {
            Sel ~ CtrlCp.NavCtrl.CmdUp;
            Inp1 ~  : ATrcSwitchBool @ {
                Sel ~ Cmp_Eq_2 : ATrcCmpVar @ {
	            Inp ~ Cursor;
                    Inp2 ~ Const_SNil;
                };
	        Inp1 ~ : ATrcSwitchBool @ {
                    Inp1 ~ CtrlCp.NavCtrl.NodeSelected;
                    Inp2 ~ Cursor;
                    Sel ~ Cmp_Eq_3 : ATrcCmpVar @ {
                        Inp ~ Const_SNil;
                        Inp2 ~ CtrlCp.NavCtrl.NodeSelected;
                    };
                };
                Inp2 ~ Const_SMdlRoot : State;
            };
            Inp2 ~ CursorUdp.Owner;
        };
        # "For debugging only";
        DbgModelUri : State {
            Debug : Content { Update : Content { = "y"; } }
            Value = "SS nil";
        }
        DbgModelUri.Inp ~ CtrlCp.NavCtrl.DrpCp.OutModelUri;

        # " VRP dirty indication";
        VrpDirty : State
        {
            Debug : Content { Update : Content { = "y"; } }
            Value = "SB false";
        }
        VrpDirty.Inp ~ : ATrcAndVar @ {
            Inp ~ U_Neq : ATrcCmpVar @ {
                Inp ~ : ATrcUri @ {
                    Inp ~ CtrlCp.NavCtrl.DrpCp.OutModelUri;
                };
                Inp2 ~ : ATrcUri @ {
                     Inp ~ Cursor;
                };
            };
            Inp ~ Cmp_Eq : ATrcCmpVar @ {
                Inp ~ CtrlCp.NavCtrl.VrvCompsCount;
                Inp2 ~ Const_1 : State
                {
                    = "SI 1";
                };
            };
            Inp ~ C_Neq_2 : ATrcCmpVar @ {
                Inp ~ CtrlCp.NavCtrl.DrpCp.OutModelUri;
                Inp2 ~ Const_SNil;
                C_Neq_2 < Debug.LogLevel = "20";
            };
        };
        # "For debugging only";
        VrvCompsCnt : State {
            Debug : Content { Update : Content { = "y"; } }
            Value = "SI 0";
        }
        # " DRP removal on VRP dirty";
        CtrlCp.NavCtrl.MutRmWidget ~ RmWdg : ATrcSwitchBool @ {
            Sel ~ VrpDirty;
            Inp1 ~ : State { Value = "SI -1"; };
            Inp2 ~ : State { Value = "SI 0"; };
            RmWdg < Debug.LogLevel = "20";
        };
        # " DRP creation";
        CtrlCp.NavCtrl.MutAddWidget ~ Sw1 : ATrcSwitchBool @ {
            Sel ~ DrpCreate_Eq : ATrcCmpVar @ {
                Inp ~ CtrlCp.NavCtrl.DrpCreated;
                Inp2 ~ Const_1;
            };
            Inp1 ~ : State { Value = "TPL,SS:name,SS:type,SI:pos Drp .*.Modules.AvrMdl.NodeDrp 0"; };
            Inp2 ~ : State { Value = "TPL,SS:name,SS:type,SI:pos Drp nil 0"; };
            DrpCreate_Eq < Debug.LogLevel = "20";
        };
        Sw1 < Debug.LogLevel = "20";
        # " Model set to DRP: needs to connect DRPs input to controller";
        SDrpCreated : State {
            Debug : Content { Update : Content { = "y"; } }
            Value = "SI 0";
        }
        SDrpCreated.Inp ~ CtrlCp.NavCtrl.DrpCreated;
        WindowEdp.InpMut ~ : ATrcSwitchBool @ {
            Sel ~ DrpCreate_Eq;
            Inp1 ~ : State { Value = "MUT none"; };
            Inp2 ~ TMutConn : ATrcMutConn @ {
                Cp1 ~ : State {
                    = "SS ..VrvCp.NavCtrl.DrpCp";
                };
                Cp2 ~ : State {
                    = "SS .testroot.Test.Window.Scene.VBox.ModelView.Drp.RpCp";
                };
            };
        };
        # " Model URI is set only after DRP has been created";
        CtrlCp.NavCtrl.DrpCp.InpModelUri ~  : ATrcSwitchBool @ {
            Sel ~ DelayMdlUri : State @ {
                Inp ~ MdlUriSel : ATrcAndVar @ {
                    Inp ~ : ATrcNegVar @ {
                        Inp ~ Delay : State @ {
                            Inp ~ DrpCreate_Eq;
                            Delay < = "SB false";
                            Delay < Debug : Content { Update : Content { = "y"; } }
                        }; 
                    };
                    Inp ~ DrpCreate_Eq;
                };
                DelayMdlUri < = "SB false";
                DelayMdlUri < Debug : Content { Update : Content { = "y"; } }
            };
            Inp1 ~ Const_SNil; 
            Inp2 ~ Cursor;
            MdlUriSel < Debug.LogLevel = "20";
        };
    }
}
