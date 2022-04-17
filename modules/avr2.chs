AvrMdl2 : Elem
{
    # "Model visual representations. Ver.02. Based on SDC approach.";
    About : Content {  = "Agents visual representations."; }
    Modules : Node
    {
        + FvWidgets;
        + ContainerMod;
        + AdpComps;
        + DesUtils;
    }
    NodeCrp3 : ContainerMod.DVLayout
    {
        Observable = "y";
        # "CRP v.3 DES controlled,  container based";
        CntAgent < {
            Debug.LogLevel = "Dbg";
        }
        # "CRP context";
        CrpCtx : DesCtxCsm {
            ModelMntp : ExtdStateMnodeOutp;
            DrpMagUri : ExtdStateOutp;
        }
        SCrpCtx_Dbg_MagUri : State @ {
            _@ < { Debug.LogLevel = "Dbg"; = "SS "; }
            Inp ~ CrpCtx.DrpMagUri;
        }
        SModelUri : State { Debug.LogLevel = "Dbg"; = "SS "; }
        # "Visualization paremeters";
        VisPars : Des {
            Border : State { = "SB true"; }
        }
        BgColor < { R < = "0.0"; G < = "0.0"; B < = "0.7";  A < = "1.0"; }
	FgColor < { R < = "1.0"; G < = "1.0"; B < = "1.0"; }
        # "Managed agent (node) adapter - MAG adapter";
        MagAdp : DAdp @ {
            _@ < {
                Name : SdoName;
                Parent : SdoParent;
            }
            InpMagBase ~ CrpCtx.ModelMntp;
            # "InpMagUri ~ SModelUri;";
            InpMagUri ~ : TrTostrVar @ {
                Inp ~ : TrApndVar @ {
                    Inp1 ~ : TrUri @ { Inp ~ CrpCtx.DrpMagUri; };
                    Inp2 ~ : TrUri @ {
                        Inp ~ : SdoName;
                    };
                };
            };
        }
        Name_Dbg : State @ {
            _@ < { = "SS"; Debug.LogLevel = "Dbg"; }
            Inp ~ MagAdp.Name;
        }
        # "";
        End.Next !~ Start.Prev;
        YPadding < = "SI 1";
        Header : ContainerMod.DHLayout {
	    CntAgent < Debug.LogLevel = "Dbg"; 
            # "Visualization paremeters";
            VisPars : Des {
                Border : State { = "SB true"; }
            }
            FgColor < { R < = "1.0"; G < = "1.0"; B < = "1.0"; }
            End.Next !~ Start.Prev;
            Name : FvWidgets.FLabel {
	        WdgAgent < Debug.LogLevel = "Dbg"; 
                BgColor < { A < = "0.0"; }
                FgColor < { R < = "1.0"; G < = "1.0"; B < = "1.0"; }
            }
            Slot_Name : ContainerMod.FHLayoutSlot @ {
                Next ~ Start.Prev;
                SCp ~ Name.Cp;
            }
            Parent : FvWidgets.FLabel {
	        WdgAgent < Debug.LogLevel = "Dbg"; 
                BgColor < { A < = "0.0"; }
                FgColor < { R < = "1.0"; G < = "1.0"; B < = "1.0"; }
            }
            Slot_Parent : ContainerMod.FHLayoutSlot @ {
                Next ~ Slot_Name.Prev;
                Prev ~ End.Next;
                SCp ~ Parent.Cp;
            }
        }
        Header.Name.SText.Inp ~ MagAdp.Name;
        Header.Parent.SText.Inp ~ MagAdp.Parent;
        Slot_Header : ContainerMod.FVLayoutSlot @ {
            Next ~ Start.Prev;
            SCp ~ Header.Cp;
        }
        Body :  FvWidgets.FLabel {
	    WdgAgent < Debug.LogLevel = "Dbg"; 
            BgColor < { R < = "0.0"; G < = "0.0"; B < = "1.0"; }
            FgColor < { R < = "1.0"; G < = "1.0"; B < = "1.0"; }
            SText < = "SS ";
        }
        Slot_Body : ContainerMod.FVLayoutSlot @ {
            Next ~ Slot_Header.Prev;
            Prev ~ End.Next;
            SCp ~ Body.Cp;
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
        Controllable = "y";
        # "Self Node Adapter";
        SelfAdp : AdpComps.NodeAdp;
        SelfAdp.MagOwnerLink ~ _$;
        SelfAdp < AgentUri = "";
        # "Misc";
        XPadding < = "SI 10";
        YPadding < = "SI 5";
        RpCp : Extd
        {
            Int : NDrpCpp;
        }
        # "Needs to use auxiliary cp to IFR from socket";
        InpModelUri : CpStateInp;
        RpCp.Int.InpModelUri ~ InpModelUri;
        # "Managed agent (node) adapter - MAG adapter";
        MagAdp : AdpComps.NodeAdp;
        MagAdp.InpMagBase ~ RpCp.Int.InpModelMntp;
        MagAdp.InpMagUri ~ RpCp.Int.InpModelUri;
        RpCp.Int.OutModelUri ~ MagAdp.OutpMagUri;
        # "CRP context";
        CrpCtx : DesCtxSpl @ {
            _@ < {
                ModelMntp : ExtdStateMnodeOutp;
                DrpMagUri : ExtdStateOutp;
            }
            ModelMntp.Int ~ RpCp.Int.InpModelMntp;
            DrpMagUri.Int ~ MagAdp.OutpMagUri;
        }
        # "Comp names debugging";
        CmpNamesDbg : State @ {
            Inp ~ MagAdp.CompNames;
            _@ < Debug.LogLevel = "Dbg";
        }
        CmpCountDbg : State @ {
            _@ < {
                 = "SI -1";
                 Debug.LogLevel = "Dbg";
            }
            Inp ~ MagAdp.CompsCount;
        }
        # " Add wdg controlling Cp";
        CpAddCrp : ContainerMod.DcAddWdgSc;
        CpAddCrp ~ IoAddWidg;
        SCrpCreated_Dbg : State @ {
            _@ < { Debug.LogLevel = "Dbg"; = "SB false"; }
            Inp ~ CpAddCrp.Added;
        }
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
                    Inp ~ CpAddCrp.Added;
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
        CpAddCrp.Parent ~  : State { = "SS NodeCrp3"; };
        CpAddCrp.Enable ~ CmpCn_Ge : TrCmpVar @ {
            Inp ~ MagAdp.CompsCount;
            Inp2 ~ : State { = "SI 1"; };
        };
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
            MutRmWidget : ContainerMod.DcRmWdgSc;
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
            MutRmWidget : ContainerMod.DcRmWdgS;
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
	        Inp1 ~ : TrSvldVar @ {
                    Inp1 ~ CtrlCp.NavCtrl.NodeSelected;
                    Inp2 ~ Cursor;
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
        ModelUri : State {
            Debug.LogLevel = "Dbg";
            = "SS nil";
        }
        # " VRP Dirty forming";
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
            Inp ~ CpAddDrp.Added;
            Inp ~ C_Neq_2 : TrCmpVar @ {
                Inp ~ CtrlCp.NavCtrl.DrpCp.OutModelUri;
                Inp2 ~ Const_SNil;
                _@ < Debug.LogLevel = "Dbg";
            };
        };
        # "For debugging only";
        Dbg_OutModelUri : State @ {
            _@ < Debug.LogLevel = "Dbg";
            _@ < = "SS nil";
            Inp ~ CtrlCp.NavCtrl.DrpCp.OutModelUri;
        }
        VrvCompsCnt : State {
            Debug.LogLevel = "Dbg";
            = "SI 0";
        }
        # " DRP removal on VRP dirty";
        CpRmDrp : ContainerMod.DcRmWdgSc;
        CpRmDrp ~ CtrlCp.NavCtrl.MutRmWidget;
        CpRmDrp.Name ~  : State { = "SS Drp"; };
        CpRmDrp.Enable ~ VrpDirty;
        Dbg_DrpRemoved : State @ {
            _@ < Debug.LogLevel = "Dbg";
            _@ < = "SB true";
            Inp ~ CpRmDrp.Done;
        }
        # " Model set to DRP: needs to connect DRPs input to controller";
        SDrpCreated_Dbg : State {
            Debug.LogLevel = "Dbg";
            = "SB false";
        }
        SDrpCreated_Dbg.Inp ~ CpAddDrp.Added;
        # "Connect enable via state because socket IFR denies the deep loops. Consider using repeater.";
        CpAddDrp.Enable ~ CpRmDrp.Done;
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
        DrpAddedPulse : DesUtils.BChange @ {
            SInp ~ CpAddDrp.Added;
        }
        VrpDirtyPulse : DesUtils.BChange @ {
            SInp ~ VrpDirty;
        }
        CursorDelay : State @ {
            _@ < Debug.LogLevel = "Dbg";
            _@ < = "SS nil";
            Inp ~ Cursor;
        }
        CursorDelay2 : State @ {
            _@ < Debug.LogLevel = "Dbg";
            _@ < = "SS nil";
            Inp ~ CursorDelay;
        }
        # " Model URI is set only after DRP has been created";
        MdlUriSel : DesUtils.RSTg @ {
            InpS ~ DrpAddedPulse.Outp;
            InpR ~ VrpDirtyPulse.Outp;
        }
        CtrlCp.NavCtrl.DrpCp.InpModelUri ~  MdlUri : TrSwitchBool @ {
            # "Sel ~ DrpAddedPulse.Outp;";
            Sel ~ MdlUriSel.Outp;
            # "TODO avoid using this -nil- anywhere";
            Inp1 ~ Const_SNil; 
            Inp2 ~ CursorDelay2;
        };
        ModelUri.Inp ~ MdlUri;
    }
}
