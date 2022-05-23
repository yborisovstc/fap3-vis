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
            Debug.LogLevel = "Info";
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
	FgColor < { R < = "1.0"; G < = "1.0"; B < = "1.0";  A < = "1.0"; }
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
                    Inp1 ~ : TrToUriVar @ { Inp ~ CrpCtx.DrpMagUri; };
                    Inp2 ~ : TrToUriVar @ {
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
	    CntAgent < Debug.LogLevel = "Err"; 
            # "Visualization paremeters";
            VisPars : Des {
                Border : State { = "SB true"; }
            }
            FgColor < { R < = "1.0"; G < = "1.0"; B < = "1.0";  A < = "1.0"; }
            End.Next !~ Start.Prev;
            Name : FvWidgets.FLabel {
	        WdgAgent < Debug.LogLevel = "Err"; 
                BgColor < { A < = "0.0"; }
                FgColor < { R < = "1.0"; G < = "1.0"; B < = "1.0"; A < = "1.0"; }
            }
            Slot_Name : ContainerMod.FHLayoutSlot @ {
                Next ~ Start.Prev;
                SCp ~ Name.Cp;
            }
            Parent : FvWidgets.FLabel {
	        WdgAgent < Debug.LogLevel = "Err"; 
                BgColor < { A < = "0.0"; }
                FgColor < { R < = "1.0"; G < = "1.0"; B < = "1.0";  A < = "1.0"; }
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
	    WdgAgent < Debug.LogLevel = "Err"; 
            BgColor < { R < = "0.0"; G < = "0.0"; B < = "1.0";  A < = "1.0"; }
            FgColor < { R < = "1.0"; G < = "1.0"; B < = "1.0";  A < = "1.0"; }
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
        InpModelMntp : CpStateMnodeInp;
    }
    NDrpCpp : Socket
    {
        # "Node DRP output socket";
        InpModelUri : CpStateOutp;
        InpModelMntp : CpStateMnodeOutp;
    }
    NDrpCpe : Extd
    {
        Int : NDrpCp;
    }
    NodeDrp : ContainerMod.DHLayout
    {
	BgColor < { R < = "0.4"; G < = "0.4"; B < = "0.0"; A < = "1.0"; }
        # " Node detail representation";
        Controllable = "y";
        # "DRP context";
        DrpCtx : DesCtxCsm {
            ModelMntp : ExtdStateMnodeOutp;
            DrpMagUri : ExtdStateOutp;
        }
        # "Self Node Adapter";
        SelfAdp : AdpComps.NodeAdp;
        SelfAdp.MagOwnerLink ~ _$;
        SelfAdp < AgentUri = "";
        # "Misc";
        XPadding < = "SI 10";
        YPadding < = "SI 5";
        # "Managed agent (node) adapter - MAG adapter";
        MagAdp : AdpComps.NodeAdp;
        MagAdp.InpMagBase ~ DrpCtx.ModelMntp;
        MagAdp.InpMagUri ~ DrpCtx.DrpMagUri;
        # "CRP context";
        CrpCtx : DesCtxSpl @ {
            _@ < {
                ModelMntp : ExtdStateMnodeOutp;
                DrpMagUri : ExtdStateOutp;
            }
            ModelMntp.Int ~ DrpCtx.ModelMntp;
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
            _@ < { = "SI 0"; Debug.LogLevel = "Dbg"; }
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
        CompNameDbg : State { = "SS "; Debug.LogLevel = "Dbg"; }
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
            DrpCp : NDrpCp;
        }
    }
    VrController : Des
    {
        # " Visual representation controller";
        # "CP binding to view";
        CtrlCp : VrControllerCp;
        # " Model adapter. Set AgentUri content to model URI.";
        CursorUdp : AdpComps.NodeAdp;
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
            = "URI _INV";
        };
        # "For debugging only";
        DbgCursorOwner : State @ { _@ < { Debug.LogLevel = "Dbg"; = "SS nil"; } Inp ~ CursorUdp.Owner; }
        DbgCmdUp : State @ { _@ < { Debug.LogLevel = "Dbg"; = "SB false"; } Inp ~ CtrlCp.NavCtrl.CmdUp; }
        # "NodeSelected Pulse";
        Nsp : DesUtils.DPulse @ {
            InpD ~ CtrlCp.NavCtrl.NodeSelected;
            InpE ~ : State { = "URI _INV"; };
        }
        Nsp.Delay < = "URI";
        Nsp.Delay < Debug.LogLevel = "Dbg";
        NspDbg : State { Debug.LogLevel = "Dbg"; = "URI _INV"; }
        NspDbg.Inp ~ Nsp.Outp;

        Cursor.Inp ~ : TrSwitchBool @ {
            Sel ~ CtrlCp.NavCtrl.CmdUp;
            Inp1 ~  Tr1Dbg : TrSwitchBool @ {
                Sel ~ : TrIsValid @ { Inp ~ Cursor; };
                Inp1 ~ Const_SMdlRoot : State { = "URI"; };
	        Inp2 ~ : TrSvldVar @ {
                    Inp1 ~ : TrApndVar @ {
                        Inp1 ~ Cursor;
                        Inp2 ~ Nsp.Outp;
                    };
                    Inp2 ~ Cursor;
                };
            };
            Inp2 ~ : TrToUriVar @ { Inp ~ CursorUdp.Owner; };
        };
        # " DRP creation";
        CpAddDrp : ContainerMod.DcAddWdgSc;
        CpAddDrp ~ CtrlCp.NavCtrl.MutAddWidget;
        CpAddDrp.Name ~  : State { = "SS Drp"; };
        CpAddDrp.Parent ~  : State { = "SS AvrMdl2.NodeDrp"; };
        DrpAddedPulse : DesUtils.BChange @ {
            SInp ~ CpAddDrp.Added;
        }
        # " Model URI";
        CtrlCp.NavCtrl.DrpCp.InpModelUri ~ MdlUri : TrSwitchBool @ {
            # " Model URI is set only after DRP has been created";
            Sel ~ DrpAddedPulse.Outp;
            Inp1 ~ : State { = "URI _INV"; };
            Inp2 ~ Cursor;
        };
        MdlUriDbg : State @ { _@ < { Debug.LogLevel = "Dbg"; = "URI _INV"; } Inp ~ MdlUri; }
        SModelUri : State @ {
            _@ < { Debug.LogLevel = "Dbg"; = "URI _INV"; }
            Inp ~ ModelUri : TrSvldVar @ {
                Inp1 ~ MdlUri;
                Inp2 ~ SModelUri;
            };
        }
        # " VRP dirty indication";
        VrpDirty : State { Debug.LogLevel = "Dbg"; = "SB false"; }
        VrpDirty.Inp ~ : TrAndVar @ {
            Inp ~ U_Neq : TrCmpVar @ {
                Inp ~ ModelUri;
                Inp2 ~ Cursor;
            };
            Inp ~ CpAddDrp.Added;
            Inp ~ : TrIsValid @ { Inp ~ ModelUri; };
        };
        # " DRP removal on VRP dirty";
        CpRmDrp : ContainerMod.DcRmWdgSc;
        CpRmDrp ~ CtrlCp.NavCtrl.MutRmWidget;
        CpRmDrp.Name ~  : State { = "SS Drp"; };
        CpRmDrp.Enable ~ VrpDirty;
        Dbg_DrpRemoved : State @ { _@ < { Debug.LogLevel = "Dbg";  = "SB _INV"; } Inp ~ CpRmDrp.Done; }
        DrpRemovedPulse : DesUtils.BChange @ { SInp ~ CpRmDrp.Done; }
        SDrpCreated_Dbg : State @ { _@ < { Debug.LogLevel = "Dbg"; = "SB false"; } Inp ~ CpAddDrp.Added; }
        DrpAddedTg : DesUtils.RSTg @ {
            InpS ~ DrpAddedPulse.Outp;
            InpR ~ DrpRemovedPulse.Outp;
        }
        CpAddDrp.Enable ~ : TrNegVar @ { Inp ~ DrpAddedTg.Outp; };
    }
}
