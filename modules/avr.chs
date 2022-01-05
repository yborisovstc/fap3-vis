AvrMdl : Elem
{
    About : Content {  = "Agents visual representations"; }
    Modules : Node
    {
        + FvWidgets;
        + ContainerMod;
        + AdpComps;
    }
    NDrpCp : Socket
    {
        # "Node DRP output socket";
        InpModelUri : CpStateInp;
        OutCompsCount : CpStateOutp;
        OutModelUri : CpStateOutp;
        InpModelMntp : CpStateMnodeInp;
    }
    NDrpCpp : Socket
    {
        # "Node DRP output socket";
        InpModelUri : CpStateOutp;
        OutCompsCount : CpStateInp;
        OutModelUri : CpStateInp;
        InpModelMntp : CpStateMnodeOutp;
    }
    NDrpCpe : Extd
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
        Padding < = "SI 10";
        RpCp : Extd
        {
            Int : NDrpCpp;
        }
        RpCp.Int.OutCompsCount ~ OutCompsCount;
        # "Needs to use auxiliary cp to IFR from socket";
        InpModelUri : CpStateInp;
        RpCp.Int.InpModelUri ~ InpModelUri;
        OutModelUri : CpStateOutp;
        RpCp.Int.OutModelUri ~ OutModelUri;
        # "Cp for access to the model mount point";
        ModelMntpInp : CpStateMnodeInp;
        RpCp.Int.InpModelMntp ~ ModelMntpInp;
        # "Managed agent (node) adapter - MAG adapter";
        MagAdp : AdpComps.NodeAdp;
        MagAdp.InpMagBase ~ RpCp.Int.InpModelMntp;
        MagAdp.InpMagUri ~ RpCp.Int.InpModelUri;
        # "Comp names debugging";
        CmpNamesDbg : State @ {
            Inp ~ MagAdp.CompNames;
            _@ < Debug.LogLevel = "Dbg";
        }
    }
    SystDrp : ContainerMod.FHLayoutBase
    {
        # " Syst detail representation";
        CntAgent : ASystDrp;
        CntAgent < {
            ModelSynced : State {
                = "SB false";
            }
        }
        Padding < = "SI 10";
        InpModelUri : CpStateInp;
    }
    VrViewCp : Socket
    {
        About : Content { = "Vis representation view CP"; }
        NavCtrl : Socket
        {
            About : Content { = "Navigation control"; }
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
        About : Content { = "Vis representation controller CP"; }
        NavCtrl : Socket
        {
            About : Content { = "Navigation control"; }
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
        # "CP binding to view";
        CtrlCp : VrControllerCp;
        # " Visual representation controller";
        # " Model adapter. Set AgentUri content to model URI.";
        CursorUdp : AdpComps.NodeAdp;
        # " Model view adapter. Set AgentView cnt to model view.";
        ModelViewUdp : AdpComps.NodeAdp;
        # " Window MElem adapter";
        WindowEdp : AdpComps.ElemAdp;
        # "Model adapter. TODO Do we need it";
        ModelUdp : AdpComps.NodeAdp;
        # "Model mounting point";
        ModelMnt : AMntp {
            EnvVar : Content { = "Model"; }
        }
        ModelMntLink : Link {
            ModelMntpOutp : CpStateMnodeOutp;
        }
        ModelMntLink ~ ModelMnt;
        ModelUdp.MagOwnerLink ~ ModelMnt;
        ModelUdp < AgentUri : Content { = ""; }
        CtrlCp.NavCtrl.DrpCp.InpModelMntp ~ ModelMntLink.ModelMntpOutp;
        # " Cursor";
        CursorUdp.MagOwnerLink ~ ModelMnt;
        CursorUdp.InpMagUri ~ Cursor : State {
            Debug.LogLevel = "Dbg";
            = "SS nil";
        };
        Const_SNil : State {
            = "SS nil";
        }
        # "For debugging only";
        DbgCursorOwner : State {
            Debug.LogLevel = "Dbg";
            = "SS nil";
        }
        DbgCursorOwner.Inp ~ CursorUdp.Owner;
        DbgCmdUp : State {
            Debug.LogLevel = "Dbg";
            = "SB false";
        }
        DbgCmdUp.Inp ~ CtrlCp.NavCtrl.CmdUp;
        Cursor.Inp ~ : TrSwitchBool @ {
            Sel ~ CtrlCp.NavCtrl.CmdUp;
            Inp1 ~  : TrSwitchBool @ {
                Sel ~ Cmp_Eq_2 : TrCmpVar @ {
	            Inp ~ Cursor;
                    Inp2 ~ Const_SNil;
                };
	        Inp1 ~ : TrSwitchBool @ {
                    Inp1 ~ CtrlCp.NavCtrl.NodeSelected;
                    Inp2 ~ Cursor;
                    Sel ~ Cmp_Eq_3 : TrCmpVar @ {
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
            Debug.LogLevel = "Dbg";
            = "SS nil";
        }
        DbgModelUri.Inp ~ CtrlCp.NavCtrl.DrpCp.OutModelUri;

        # " VRP dirty indication";
        VrpDirty : State
        {
            Debug.LogLevel = "Dbg";
            = "SB false";
        }
        VrpDirty.Inp ~ : TrAndVar @ {
            Inp ~ U_Neq : TrCmpVar @ {
                Inp ~ : TrUri @ {
                    Inp ~ CtrlCp.NavCtrl.DrpCp.OutModelUri;
                };
                Inp2 ~ : TrUri @ {
                     Inp ~ Cursor;
                };
                _@ < Debug.LogLevel = "Dbg";
            };
            Inp ~ Cmp_Eq : TrCmpVar @ {
                Inp ~ CtrlCp.NavCtrl.VrvCompsCount;
                Inp2 ~ Const_1 : State
                {
                    = "SI 1";
                };
                _@ < Debug.LogLevel = "Dbg";
            };
            Inp ~ C_Neq_2 : TrCmpVar @ {
                Inp ~ CtrlCp.NavCtrl.DrpCp.OutModelUri;
                Inp2 ~ Const_SNil;
                _@ < Debug.LogLevel = "Dbg";
            };
        };
        # "For debugging only";
        VrvCompsCnt : State {
            Debug.LogLevel = "Dbg";
            = "SI 0";
        }
        # " DRP removal on VRP dirty";
        CtrlCp.NavCtrl.MutRmWidget ~ RmWdg : TrSwitchBool @ {
            Sel ~ VrpDirty;
            Inp1 ~ : State { = "SI -1"; };
            Inp2 ~ : State { = "SI 0"; };
            _@ < Debug.LogLevel = "Dbg";
        };
        # " DRP creation";
        CtrlCp.NavCtrl.MutAddWidget ~ Sw1 : TrSwitchBool @ {
            Sel ~ DrpCreate_Eq : TrCmpVar @ {
                Inp ~ CtrlCp.NavCtrl.DrpCreated;
                Inp2 ~ Const_1;
                _@ < Debug.LogLevel = "Dbg";
            };
            # "TODO Wrong design, DRP pre-created of NodeDrp type. Needs to create DRP of model type";
            Inp1 ~ : State { = "TPL,SS:name,SS:type,SI:pos Drp .*.Modules.AvrMdl.NodeDrp 0"; };
            Inp2 ~ : State { = "TPL,SS:name,SS:type,SI:pos Drp nil 0"; };
            _@ < Debug.LogLevel = "Dbg";
        };
        # " Model set to DRP: needs to connect DRPs input to controller";
        SDrpCreated : State {
            Debug.LogLevel = "Dbg";
            = "SI 0";
        }
        SDrpCreated.Inp ~ CtrlCp.NavCtrl.DrpCreated;
        WindowEdp.InpMut ~ : TrSwitchBool @ {
            Sel ~ DrpCreate_Eq;
            Inp1 ~ : State { = "MUT none"; };
            Inp2 ~ TMutConn : TrMutConn @ {
                Cp1 ~ : State {
                    = "SS VrvCp.NavCtrl.DrpCp";
                };
                Cp2 ~ : State {
                    = "SS Scene.VBox.ModelView.Drp.RpCp";
                };
            };
        };
        # " Model URI is set only after DRP has been created";
        CtrlCp.NavCtrl.DrpCp.InpModelUri ~  : TrSwitchBool @ {
            Sel ~ DelayMdlUri : State @ {
                Inp ~ MdlUriSel : TrAndVar @ {
                    Inp ~ : TrNegVar @ {
                        Inp ~ Delay : State @ {
                            Inp ~ DrpCreate_Eq;
                            _@ < {
                                = "SB false";
                                Debug.LogLevel = "Dbg";
                            }
                        }; 
                    };
                    Inp ~ DrpCreate_Eq;
                    _@ < Debug.LogLevel = "Dbg";
                };
                _@ < {
                    = "SB false";
                    Debug.LogLevel = "Dbg";
                }
            };
            Inp1 ~ Const_SNil; 
            Inp2 ~ Cursor;
        };
    }
}
