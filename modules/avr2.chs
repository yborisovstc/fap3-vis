AvrMdl2 : Elem
{
    # "Model visual representations. Ver.02. Based on SDC approach.";
    About : Content {  = "Agents visual representations."; }
    Modules : Node
    {
        + FvWidgets;
        + ContainerMod;
        + AdpComps;
    }
    FNodeCrp2 : FvWidgets.FWidgetBase
    {
        WdgAgent : ANodeCrp2;
        # "Main connpoints";
        CrpCpMagBase : CpStateMnodeInp;
        # " Node visual repesentation";
        BgColor < { R < = "0.0"; G < = "0.3"; B < = "0.0"; }
        FgColor < { R < = "1.0"; G < = "1.0"; B < = "1.0"; }
        # "Self adapter";
        SelfAdp : AdpComps.NodeAdp;
        SelfAdp.MagOwnerLink ~ _$;
        SelfAdp < AgentUri = "";
        # "Managed agent (node) adapter - MAG adapter";
        # "MagAdp : AdpComps.NodeAdp;";
        # "MagAdp.InpMagBase ~ CrpCpMagBase.Int; ";
        # "MagAdp.InpMagUri ~ SelfAdp.Name; ";
        CrpName_Dbg : State @ {
            _@ < Debug.LogLevel = "Dbg";
            Inp ~ SelfAdp.Name;
        }
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
    NodeDrp : ContainerMod.DHLayout
    {
        # " Node detail representation";
        # "Self Node Adapter";
        SelfAdp : AdpComps.NodeAdp;
        SelfAdp.MagOwnerLink ~ _$;
        SelfAdp < AgentUri = "";
        # "Misc";
        Padding < = "SI 10";
        RpCp : Extd
        {
            Int : NDrpCpp;
        }
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
        CmpCountDbg : State @ {
            _@ < {
                 Debug.LogLevel = "Dbg";
            }
            Inp ~ MagAdp.CompsCount;
        }
        # " Add wdg controlling Cp";
        CpAddCrp : ContainerMod.DcAddWdgSc;
        CpAddCrp ~ IoAddWidg;
        CompsIdx : State @ {
            # "Iterator of MAG component";
            _@ < {
                = "SI 0"; 
                Debug.LogLevel = "Dbg";
            }
            Inp ~ : TrSwitchBool @ {
                Debug.LogLevel = "Dbg";
                Sel ~ CidxAnd1 : TrAndVar @ {
                    Inp ~ Cmp_Gt : TrCmpVar @ {
                        Inp ~ : TrAddVar @ {
                            Inp ~ MagAdp.CompsCount;
                            InpN ~ : State { = "SI 1"; };
                        };
                        Inp2 ~ CompsIdx;
                        _@ < Debug.LogLevel = "Dbg";
                    };
                    # "Inp ~ CpAddCrp.Added;";
                    # "Second Inp connection after SdcConnCrpAdp";
                };
                Inp1 ~ CompsIdx;
                Inp2 ~ : TrAddVar @ {
                    Inp ~ CompsIdx;
                    Inp ~ : State { = "SI 1"; };
                };
            };
        }
        CompNameDbg : State {
            = "SS ";
            Debug.LogLevel = "Dbg";
        }
        CompNameDbg.Inp ~ CompName : TrAtVar @ {
            Inp ~ MagAdp.CompNames;
            Index ~ CompsIdx; 
        };

        # " CRP creation";
        CpAddCrp.Name ~ CompName;
        CpAddCrp.Parent ~  : State { = "SS FNodeCrp2"; };
        CpAddCrp.Enable ~ CmpCn_Ge : TrCmpVar @ {
            Inp ~ MagAdp.CompsCount;
            Inp2 ~ : State { = "SI 1"; };
        };
        CpAddCrp.Mut ~ : State { = "CHR2 { BgColor < { R = \"0.0\"; G = \"0.5\"; B = \"0.0\"; } FgColor < { R = \"1.0\"; G = \"1.0\"; B = \"1.0\"; } }"; };
        # " CRP providing MAG";
        SdcConnCrpMagBase : ASdcConn @ {
            Enable ~ CpAddCrp.Added;
            V1 ~ : TrApndVar @ {
                Inp1 ~ CompName;
                Inp2 ~ : State { = "SS .CrpCpMagBase"; };
            };
            V2 ~ : State { = "SS RpCp.Int.InpModelMntp"; };
        }
        CidxAnd1.Inp ~ SdcConnCrpMagBase.Outp;
    }
    SystDrp : ContainerMod.FHLayoutBase
    {
        # " Syst detail representation";
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
            MutAddWidget : ContainerMod.DcAddWdgSc;
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
            MutAddWidget : ContainerMod.DcAddWdgS;
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
            # "TODO FIXME Not setting EnvVar here casuses wrong navigation in modnav";
            EnvVar : Content { = "Model"; }
        }
        ModelMntLink : Link {
            ModelMntpOutp : CpStateMnodeOutp;
        }
        ModelMntLink ~ ModelMnt;
        ModelUdp.MagOwnerLink ~ ModelMnt;
        ModelUdp < AgentUri : Content { = "_$"; }
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
        # " DRP creation";
        CpAddDrp : ContainerMod.DcAddWdgSc;
        CpAddDrp ~ CtrlCp.NavCtrl.MutAddWidget;
        CpAddDrp.Name ~  : State { = "SS Drp"; };
        CpAddDrp.Parent ~  : State { = "SS AvrMdl2.NodeDrp"; };
        CpAddDrp.Enable ~ : TrNegVar  @ {
            Inp ~ CpAddDrp.Added;
        };
        ModelUri : State {
            Debug.LogLevel = "Dbg";
            = "SS nil";
        }
        # " VRP Dirty forming";
        VrpDirty.Inp ~ : TrAndVar @ {
            Inp ~ U_Neq : TrCmpVar @ {
                Inp ~ : TrUri @ {
                    Inp ~ ModelUri;
                };
                Inp2 ~ : TrUri @ {
                     Inp ~ Cursor;
                };
                _@ < Debug.LogLevel = "Dbg";
            };
            Inp ~ CpAddDrp.Added;
            Inp ~ C_Neq_2 : TrCmpVar @ {
                Inp ~ ModelUri;
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
        # " Model set to DRP: needs to connect DRPs input to controller";
        SDrpCreated_Dbg : State {
            Debug.LogLevel = "Dbg";
            = "SB false";
        }
        SDrpCreated_Dbg.Inp ~ CpAddDrp.Added;
        WindowEdp.InpMut ~ : TrSwitchBool @ {
            Sel ~ CpAddDrp.Added;
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
        CtrlCp.NavCtrl.DrpCp.InpModelUri ~  MdlUri : TrSwitchBool @ {
            Sel ~ CpAddDrp.Added;
            Inp1 ~ Const_SNil; 
            Inp2 ~ Cursor;
        };
        ModelUri.Inp ~ MdlUri;
    }
}
