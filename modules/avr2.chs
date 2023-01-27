AvrMdl2 : Elem {
    # "Model visual representations. Ver.02. Based on SDC approach."
    About : Content {
        = "Agents visual representations."
    }
    + FvWidgets
    + ContainerMod
    + AdpComps
    + DesUtils
    NodeCrp3 : ContainerMod.DVLayout {
        Observable = "y"
        # "CRP v.3 DES controlled,  container based"
        CntAgent <  {
            Debug.LogLevel = "Err"
        }
        # "CRP context"
        CrpCtx : DesCtxCsm {
            ModelMntp : ExtdStateMnodeOutp
            DrpMagUri : ExtdStateOutp
        }
        SCrpCtx_Dbg_MagUri : State @  {
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "SS _INV"
            }
            Inp ~ CrpCtx.DrpMagUri
        }
        SModelUri : State {
            Debug.LogLevel = "Dbg"
            = "SS _INV"
        }
        # "Visualization paremeters"
        VisPars : Des {
            Border : State {
                = "SB true"
            }
        }
        BgColor <  {
            R < = "0.0"
            G < = "0.0"
            B < = "0.7"
            A < = "1.0"
        }
        FgColor <  {
            R < = "1.0"
            G < = "1.0"
            B < = "1.0"
        }
        # "Managed agent (node) adapter - MAG adapter"
        MagAdp : DAdp @  {
            _@ <  {
                Name : SdoName
                Parent : SdoParent
            }
            InpMagBase ~ CrpCtx.ModelMntp
            # "InpMagUri ~ SModelUri;"
            InpMagUri ~ : TrTostrVar @  {
                Inp ~ : TrApndVar @  {
                    Inp1 ~ : TrToUriVar @  {
                        Inp ~ CrpCtx.DrpMagUri
                    }
                    Inp2 ~ : TrToUriVar @  {
                        Inp ~ : SdoName
                    }
                }
            }
        }
        Name_Dbg : State @  {
            _@ <  {
                = "SS _INV"
                Debug.LogLevel = "Dbg"
            }
            Inp ~ MagAdp.Name
        }
        # ""
        End.Next !~ Start.Prev
        YPadding < = "SI 1"
        Header : ContainerMod.DHLayout {
            CntAgent < Debug.LogLevel = "Err"
            # "Visualization paremeters"
            VisPars : Des {
                Border : State {
                    = "SB true"
                }
            }
            FgColor <  {
                R < = "1.0"
                G < = "1.0"
                B < = "1.0"
            }
            End.Next !~ Start.Prev
            Name : FvWidgets.FLabel {
                WdgAgent < Debug.LogLevel = "Err"
                BgColor <  {
                    A < = "0.0"
                }
                FgColor <  {
                    R < = "1.0"
                    G < = "1.0"
                    B < = "1.0"
                }
            }
            Slot_Name : ContainerMod.FHLayoutSlot @  {
                Next ~ Start.Prev
                SCp ~ Name.Cp
            }
            Parent : FvWidgets.FLabel {
                WdgAgent < Debug.LogLevel = "Err"
                BgColor <  {
                    A < = "0.0"
                }
                FgColor <  {
                    R < = "1.0"
                    G < = "1.0"
                    B < = "1.0"
                }
            }
            Slot_Parent : ContainerMod.FHLayoutSlot @  {
                Next ~ Slot_Name.Prev
                Prev ~ End.Next
                SCp ~ Parent.Cp
            }
        }
        Header.Name.SText.Inp ~ MagAdp.Name
        Header.Parent.SText.Inp ~ MagAdp.Parent
        Slot_Header : ContainerMod.FVLayoutSlot @  {
            Next ~ Start.Prev
            SCp ~ Header.Cp
        }
        Body : FvWidgets.FLabel {
            WdgAgent < Debug.LogLevel = "Err"
            BgColor <  {
                R < = "0.0"
                G < = "0.0"
                B < = "1.0"
            }
            FgColor <  {
                R < = "1.0"
                G < = "1.0"
                B < = "1.0"
            }
            SText < = "SS _INV"
        }
        Slot_Body : ContainerMod.FVLayoutSlot @  {
            Next ~ Slot_Header.Prev
            Prev ~ End.Next
            SCp ~ Body.Cp
        }
    }
    NDrpCp : Socket {
        # "Node DRP output socket"
        InpModelUri : CpStateInp
        InpModelMntp : CpStateMnodeInp
    }
    NDrpCpp : Socket {
        # "Node DRP output socket"
        InpModelUri : CpStateOutp
        InpModelMntp : CpStateMnodeOutp
    }
    NDrpCpe : Extd {
        Int : NDrpCp
    }
    NodeDrp : ContainerMod.DHLayout {
        # " Node detail representation"
        Controllable = "y"
        # "DRP context"
        DrpCtx : DesCtxCsm {
            ModelMntp : ExtdStateMnodeOutp
            DrpMagUri : ExtdStateOutp
        }
        # "Self Node Adapter"
        SelfAdp : AdpComps.NodeAdp
        SelfAdp.MagOwnerLink ~ _$
        SelfAdp < AgentUri = ""
        # "Misc"
        XPadding < = "SI 10"
        YPadding < = "SI 5"
        # "Managed agent (node) adapter - MAG adapter"
        MagAdp : AdpComps.NodeAdp
        MagAdp.InpMagBase ~ DrpCtx.ModelMntp
        MagAdp.InpMagUri ~ DrpCtx.DrpMagUri
        # "CRP context"
        CrpCtx : DesCtxSpl @  {
            _@ <  {
                ModelMntp : ExtdStateMnodeOutp
                DrpMagUri : ExtdStateOutp
            }
            ModelMntp.Int ~ DrpCtx.ModelMntp
            DrpMagUri.Int ~ MagAdp.OutpMagUri
        }
        # "Comp names debugging"
        CmpNamesDbg : State @  {
            Inp ~ MagAdp.CompNames
            _@ < Debug.LogLevel = "Dbg"
        }
        CmpCountDbg : State @  {
            _@ <  {
                = "SI -1"
                Debug.LogLevel = "Dbg"
            }
            Inp ~ MagAdp.CompsCount
        }
        # " Add wdg controlling Cp"
        CpAddCrp : ContainerMod.DcAddWdgSc
        CpAddCrp ~ IoAddWidg
        SCrpCreated_Dbg : State @  {
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "SB false"
            }
            Inp ~ CpAddCrp.Added
        }
        CompsIdx : State @  {
            # "Iterator of MAG component"
            _@ <  {
                = "SI 0"
                Debug.LogLevel = "Dbg"
            }
            Inp ~ : TrSwitchBool @  {
                Debug.LogLevel = "Dbg"
                Sel ~ CidxAnd1 : TrAndVar @  {
                    Inp ~ Cmp_Gt : TrCmpVar @  {
                        Inp ~ : TrAddVar @  {
                            Inp ~ MagAdp.CompsCount
                            InpN ~ : State {
                                = "SI 1"
                            }
                        }
                        Inp2 ~ CompsIdx
                        _@ < Debug.LogLevel = "Dbg"
                    }
                    Inp ~ CpAddCrp.Added
                    # "Second Inp connection after SdcConnCrpAdp"
                }
                Inp1 ~ CompsIdx
                Inp2 ~ : TrAddVar @  {
                    Inp ~ CompsIdx
                    Inp ~ : State {
                        = "SI 1"
                    }
                }
            }
        }
        CompNameDbg : State {
            = "SS _INV"
            Debug.LogLevel = "Dbg"
        }
        CompNameDbg.Inp ~ CompName : TrAtVar @  {
            Inp ~ MagAdp.CompNames
            Index ~ CompsIdx
        }
        # " CRP creation"
        CpAddCrp.Name ~ CompName
        CpAddCrp.Parent ~ : State {
            = "SS NodeCrp3"
        }
        CpAddCrp.Enable ~ CmpCn_Ge : TrCmpVar @  {
            Inp ~ MagAdp.CompsCount
            Inp2 ~ : State {
                = "SI 1"
            }
        }
    }
    VertCrpEdgeCp : Socket {
        # "VertCrp CP to Edge"
        ColumnPos : CpStateInp
        # "TODO unused?"
        PairColumnPos : CpStateOutp
        Pos : CpStateInp
        PairPos : CpStateOutp
    }
    VertCrpEdgeCpm : Socket {
        # "VertCrp CP to Edge. Mate."
        ColumnPos : CpStateOutp
        PairColumnPos : CpStateInp
        Pos : CpStateOutp
        PairPos : CpStateInp
    }
    VertCrp : NodeCrp3 {
        # " Vertex compact representation"
        # "Extend widget CP to for positions io"
        Cp <  {
            ItemPos : CpStateOutp
            ColumnPos : CpStateOutp
        }
        EdgeCrpCp : VertCrpEdgeCp @  {
            ColumnPos ~ Cp.ColumnPos
            Pos ~ Tpl1 : TrTuple @  {
                Inp ~ : State {
                    = "TPL,SI:col,SI:item -1 -1"
                }
                _@ <  {
                    col : CpStateInp
                    item : CpStateInp
                }
                col ~ Cp.ColumnPos
                item ~ Cp.ItemPos
            }
        }
        Tpl1_Dbg : State @  {
            _@ <  {
                = "TPL,SI:col,SI:item -1 -1"
                Debug.LogLevel = "Dbg"
            }
            Inp ~ Tpl1
        }
        # "Vert CRP context"
        VertCrpCtx : DesCtxCsm {
            # "CRP parameters: positioning etc"
            CrpPars : ExtdStateInp
        }
        ItemPos_Dbg : State @  {
            _@ <  {
                = "SI _INV"
                Debug.LogLevel = "Dbg"
            }
            Inp ~ Cp.ItemPos
        }
        ColumnPos_Dbg : State @  {
            _@ <  {
                = "SI _INV"
                Debug.LogLevel = "Dbg"
            }
            Inp ~ Cp.ColumnPos
        }
        # "Most right column of the pairs"
        # "   Inputs Iterator"
        PairPosIter : DesUtils.InpItr @  {
            InpM ~ EdgeCrpCp.PairPos
            InpDone ~ : State {
                = "SB true"
            }
            InpReset ~ Ss1 : State {
                = "SB false"
            }
        }
        PairPosIterDone_Dbg : State @  {
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "SB _INV"
            }
            Inp ~ PairPosIter.OutpDone
        }
        # "   Selected input"
        PairPosSel : TrInpSel @  {
            Inp ~ EdgeCrpCp.PairPos
            Idx ~ PairPosIter.Outp
        }
        PairPosSel_Dbg : State @  {
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "TPL,SI:col,SI:item -1 -1"
            }
            Inp ~ PairPosSel
        }
        MostRightColPair : State @  {
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "TPL,SI:col,SI:item -1 -1"
            }
            Inp ~ : TrSwitchBool @  {
                Inp1 ~ MostRightColPair
                Inp2 ~ PairPosSel
                Sel ~ ColPos_Gt : TrCmpVar @  {
                    Inp ~ : TrTupleSel @  {
                        Inp ~ PairPosSel
                        Comp ~ : State {
                            = "SS col"
                        }
                    }
                    Inp2 ~ : TrTupleSel @  {
                        Inp ~ MostRightColPair
                        Comp ~ : State {
                            = "SS col"
                        }
                    }
                }
            }
        }
        # "<<< Most right column of the pairs"
        # " Connect parameters to context"
        VertCrpCtx.CrpPars ~ : TrTuple @  {
            _@ <  {
                name : CpStateInp
                colpos : CpStateInp
                pmrcolpos : CpStateInp
            }
            Inp ~ : State {
                = "TPL,SS:name,SI:colpos,SI:pmrcolpos _INV -2 -1"
            }
            name ~ MagAdp.Name
            colpos ~ Cp.ColumnPos
            pmrcolpos ~ : TrTupleSel @  {
                Inp ~ MostRightColPair
                Comp ~ : State {
                    = "SS col"
                }
            }
        }
        # "<<< VertCrp"
    }
    EdgeCrp : FvWidgets.FWidgetBase {
        # " Edge compact repesentation"
        WdgAgent : AEdgeCrp
        BgColor <  {
            R < = "0.0"
            G < = "0.3"
            B < = "0.0"
        }
        FgColor <  {
            R < = "1.0"
            G < = "1.0"
            B < = "1.0"
        }
        VertCrpPCp : VertCrpEdgeCpm
        VertCrpQCp : VertCrpEdgeCpm
        VertCrpPCp.PairColumnPos ~ VertCrpQCp.ColumnPos
        VertCrpQCp.PairColumnPos ~ VertCrpPCp.ColumnPos
        VertCrpPCp.PairPos ~ VertCrpQCp.Pos
        VertCrpQCp.PairPos ~ VertCrpPCp.Pos
    }
    VertCrpSlot : ContainerMod.ColumnItemSlot {
        # "Vertex DRP column item slot"
        # "Extend widget CP to for positions io"
        SCp <  {
            ItemPos : CpStateInp
            ColumnPos : CpStateInp
        }
        SCp.ItemPos ~ Next.ItemPos
        SCp.ColumnPos ~ Next.ColumnPos
    }
    VertDrp : ContainerMod.ColumnsLayout {
        # " Vertex detail representation"
        # "TODO We need to redefine SlotParent to be valid in the current context. Analyze how to avoid."
        SlotParent < = "SS VertCrpSlot"
        # "DRP context"
        DrpCtx : DesCtxCsm {
            ModelMntp : ExtdStateMnodeOutp
            DrpMagUri : ExtdStateOutp
        }
        # "Managed agent (MAG) adapter"
        MagAdp : DAdp @  {
            _@ <  {
                Name : SdoName
                CompsCount : SdoCompsCount
                CompsNames : SdoCompsNames
                Edges : SdoEdges
            }
            InpMagBase ~ DrpCtx.ModelMntp
            InpMagUri ~ DrpCtx.DrpMagUri
        }
        # "CRP context"
        CrpCtx : DesCtxSpl @  {
            _@ <  {
                ModelMntp : ExtdStateMnodeOutp
                DrpMagUri : ExtdStateOutp
            }
            ModelMntp.Int ~ DrpCtx.ModelMntp
            DrpMagUri.Int ~ MagAdp.OutpMagUri
        }
        # " Add wdg controlling Cp"
        CpAddCrp : ContainerMod.DcAddWdgSc
        CpAddCrp ~ IoAddWidg
        SCrpCreated_Dbg : State @  {
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "SB false"
            }
            Inp ~ CpAddCrp.Added
        }
        # "Model components Iterator"
        CompsIter : DesUtils.IdxItr @  {
            InpCnt ~ MagAdp.CompsCount
            InpDone ~ CpAddCrp.Added
            InpReset ~ : State {
                = "SB false"
            }
        }
        CompNameDbg : State {
            = "SS _INV"
            Debug.LogLevel = "Dbg"
        }
        CompsIter_Done_Dbg : State @  {
            _@ <  {
                = "SB _INV"
                Debug.LogLevel = "Dbg"
            }
            Inp ~ CompsIter.OutpDone
        }
        EdgesDbg : State @  {
            _@ <  {
                = "VPDU _INV"
                Debug.LogLevel = "Dbg"
            }
            Inp ~ MagAdp.Edges
        }
        CompNameDbg.Inp ~ CompName : TrAtVar @  {
            Inp ~ MagAdp.CompsNames
            Index ~ CompsIter.Outp
        }
        # "Model edges Iterator"
        EdgesIter : DesUtils.IdxItr @  {
            InpCnt ~ : TrSizeVar @  {
                Inp ~ MagAdp.Edges
            }
            InpReset ~ : State {
                = "SB false"
            }
        }
        # "CRP creation"
        CpAddCrp.Name ~ CompName
        CpAddCrp.Parent ~ : State {
            = "SS VertCrp"
        }
        CpAddCrp.Enable ~ CmpCn_Ge : TrCmpVar @  {
            Inp ~ MagAdp.CompsCount
            Inp2 ~ : State {
                = "SI 1"
            }
        }
        CpAddCrp.Pos ~ : State {
            = "SI 1"
        }
        # ">>> Edge CRPs creator"
        # "Creates edges and connects them to proper VertCrps"
        EdgeData : TrAtgVar @  {
            Inp ~ MagAdp.Edges
            Index ~ EdgesIter.Outp
        }
        EdgeData_Dbg : State @  {
            _@ <  {
                = "PDU _INV"
                Debug.LogLevel = "Dbg"
            }
            Inp ~ EdgeData
        }
        EdgeCrpName : TrApndVar @  {
            Inp1 ~ : State {
                = "SS Edge_"
            }
            Inp2 ~ : TrTostrVar @  {
                Inp ~ EdgesIter.Outp
            }
        }
        CreateEdge : ASdcComp @  {
            _@ < Debug.LogLevel = "Dbg"
            Enable ~ CompsIter.OutpDone
            Name ~ EdgeCrpName
            Parent ~ : State {
                = "SS EdgeCrp"
            }
        }
        ConnectEdgeP : ASdcConn @  {
            _@ < Debug.LogLevel = "Dbg"
            Enable ~ CreateEdge.Outp
            V1 ~ : TrApndVar @  {
                Inp1 ~ : TrTostrVar @  {
                    Inp ~ : TrAtgVar @  {
                        Inp ~ EdgeData
                        Index ~ : State {
                            = "SI 0"
                        }
                    }
                }
                Inp2 ~ : State {
                    = "SS .EdgeCrpCp"
                }
            }
            V2 ~ : TrApndVar @  {
                Inp1 ~ EdgeCrpName
                Inp2 ~ : State {
                    = "SS .VertCrpPCp"
                }
            }
        }
        ConnectEdgeQ : ASdcConn @  {
            _@ < Debug.LogLevel = "Dbg"
            Enable ~ CreateEdge.Outp
            V1 ~ : TrApndVar @  {
                Inp1 ~ : TrTostrVar @  {
                    Inp ~ : TrAtgVar @  {
                        Inp ~ EdgeData
                        Index ~ : State {
                            = "SI 1"
                        }
                    }
                }
                Inp2 ~ : State {
                    = "SS .EdgeCrpCp"
                }
            }
            V2 ~ : TrApndVar @  {
                Inp1 ~ EdgeCrpName
                Inp2 ~ : State {
                    = "SS .VertCrpQCp"
                }
            }
        }
        EdgesIter.InpDone ~ : TrAndVar @  {
            Inp ~ ConnectEdgeP.Outp
            Inp ~ ConnectEdgeQ.Outp
        }
        # "<<< Edge CRPs creator"
        # "Vert CRP context"
        VertCrpCtx : DesCtxSpl {
            # "CRP parameters: positioning etc"
            CrpPars : ExtdStateInp
        }
        {
            # ">>> Controller of CRPs ordering"
            # "CrpPars Iterator"
            CrpParsIter : DesUtils.InpItr @  {
                InpM ~ VertCrpCtx.CrpPars.Int
                # "InpDone --> "
                ChgDet : DesUtils.ChgDetector @  {
                    Inp ~ VertCrpCtx.CrpPars.Int
                }
                InpReset ~ ChgDet.Outp
            }
            CrpParsIterDone_Dbg : State @  {
                _@ <  {
                    Debug.LogLevel = "Dbg"
                    = "SB _INV"
                }
                Inp ~ CrpParsIter.OutpDone
            }
            # "Selected CrpPars"
            SelectedCrpPars : TrInpSel @  {
                Inp ~ VertCrpCtx.CrpPars.Int
                Idx ~ CrpParsIter.Outp
            }
            SelectedCrpPars_Dbg : State @  {
                _@ <  {
                    Debug.LogLevel = "Dbg"
                    = "TPL,SS:name,SI:colpos,SI:pmrcolpos none -1 -1"
                }
                Inp ~ SelectedCrpPars
            }
            CrpColPos : TrTupleSel @  {
                Inp ~ SelectedCrpPars
                Comp ~ : State {
                    = "SS colpos"
                }
            }
            CrpPmrColPos : TrTupleSel @  {
                Inp ~ SelectedCrpPars
                Comp ~ : State {
                    = "SS pmrcolpos"
                }
            }
            CrpName : TrTupleSel @  {
                Inp ~ SelectedCrpPars
                Comp ~ : State {
                    = "SS name"
                }
            }
            CrpName_Dbg : State @  {
                _@ <  {
                    Debug.LogLevel = "Dbg"
                    = "SS _INV"
                }
                Inp ~ CrpName
            }
            # "New column creation"
            ColumnSlotParent < = "SS ContainerMod.ColumnLayoutSlot"
            ColCount_Dbg : State @  {
                _@ <  {
                    Debug.LogLevel = "Dbg"
                    = "SI _INV"
                }
                Inp ~ ColumnsCount
            }
            SameColAsPair_Eq : TrCmpVar @  {
                Inp ~ CrpColPos
                Inp2 ~ CrpPmrColPos
            }
            SameColAsPair_Dbg : State @  {
                _@ <  {
                    Debug.LogLevel = "Dbg"
                    = "SB _INV"
                }
                Inp ~ SameColAsPair_Eq
            }
            NewColNeeded_Ge : TrCmpVar @  {
                Inp ~ CrpColPos
                Inp2 ~ LastColPos : TrAddVar @  {
                    Inp ~ ColumnsCount
                    InpN ~ : State {
                        = "SI 1"
                    }
                }
            }
            NewColNeeded_Dbg : State @  {
                _@ <  {
                    Debug.LogLevel = "Dbg"
                    = "SB _INV"
                }
                Inp ~ NewColNeeded_Ge
            }
            CpAddColumn : ContainerMod.ClAddColumnSm @  {
                Enable ~ : TrAndVar @  {
                    Inp ~ SameColAsPair_Eq
                    Inp ~ NewColNeeded_Ge
                }
                Name ~ : TrApndVar @  {
                    Inp1 ~ : State {
                        = "SS Column_"
                    }
                    Inp2 ~ : TrTostrVar @  {
                        Inp ~ ColumnsCount
                    }
                }
            }
            CpAddColumn ~ IoAddColumn
            # "Reposition CRP"
            _ <  {
                SdcExtrSlot < Debug.LogLevel = "Dbg"
                CpRmCrp : ContainerMod.DcRmWdgSc @  {
                    Enable ~ SameColAsPair_Eq
                    Enable ~ : TrNegVar @  {
                        Inp ~ NewColNeeded_Ge
                    }
                    Name ~ CrpName
                }
                CpRmCrp ~ IoRmWidg
            }
            CpReposCrp : ContainerMod.ClReposWdgdgSm @  {
                Enable ~ SameColAsPair_Eq
                Enable ~ : TrNegVar @  {
                    Inp ~ NewColNeeded_Ge
                }
                Name ~ CrpName
                ColPos ~ ColumnsCount
            }
            CpReposCrp ~ IoReposWdg
            # "Completion of iteration"
            _ <  {
                CrpParsIter.InpDone ~ : TrOrVar {
                    Inp ~ : TrNegVar @  {
                        Inp ~ SameColAsPair_Eq
                    }
                    Inp ~ CpReposCrp.Done
                }
            }
            CrpParsIter.InpDone ~ : TrAndVar @  {
                Inp ~ : TrNegVar @  {
                    Inp ~ SameColAsPair_Eq
                }
                Inp ~ : TrIsValid @  {
                    Inp ~ CrpColPos
                }
            }
            CpReposCrpDone_Dbg : State @  {
                _@ <  {
                    Debug.LogLevel = "Dbg"
                    = "SB _INV"
                }
                Inp ~ CpReposCrp.Done
            }
            # "<<< Controller of CRPs ordering"
        }
        # "<<< VertDrp"
    }
    VrViewCp : Socket {
        About : Content {
            = "Vis representation view CP"
        }
        NavCtrl : Socket {
            About : Content {
                = "Navigation control"
            }
            CmdUp : CpStateInp
            NodeSelected : CpStateInp
            MutAddWidget : ContainerMod.DcAddWdgSc
            MutRmWidget : ContainerMod.DcRmWdgSc
            DrpCreated : CpStateInp
            DrpCp : NDrpCpp
        }
    }
    VrControllerCp : Socket {
        About : Content {
            = "Vis representation controller CP"
        }
        NavCtrl : Socket {
            About : Content {
                = "Navigation control"
            }
            CmdUp : CpStateOutp
            NodeSelected : CpStateOutp
            MutAddWidget : ContainerMod.DcAddWdgS
            MutRmWidget : ContainerMod.DcRmWdgS
            DrpCreated : CpStateOutp
            DrpCp : NDrpCp
        }
    }
    VrController : Des {
        # " Visual representation controller"
        # "CP binding to view"
        CtrlCp : VrControllerCp
        # " Model adapter. Set AgentUri content to model URI."
        CursorUdp : AdpComps.NodeAdp
        # "Model adapter. TODO Do we need it"
        ModelUdp : AdpComps.NodeAdp
        # "Model mounting point"
        ModelMnt : AMntp {
            # "TODO FIXME Not setting EnvVar here casuses wrong navigation in modnav"
            EnvVar : Content {
                = "Model"
            }
        }
        ModelMntLink : Link {
            ModelMntpOutp : CpStateMnodeOutp
        }
        ModelMntLink ~ ModelMnt
        ModelUdp.MagOwnerLink ~ ModelMnt
        ModelUdp < AgentUri : Content {
            = "_$"
        }
        CtrlCp.NavCtrl.DrpCp.InpModelMntp ~ ModelMntLink.ModelMntpOutp
        # " Cursor"
        CursorUdp.MagOwnerLink ~ ModelMnt
        CursorUdp.InpMagUri ~ Cursor : State {
            Debug.LogLevel = "Dbg"
            = "URI _INV"
        }
        # "For debugging only"
        DbgCursorOwner : State @  {
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "SS nil"
            }
            Inp ~ CursorUdp.Owner
        }
        DbgCmdUp : State @  {
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "SB false"
            }
            Inp ~ CtrlCp.NavCtrl.CmdUp
        }
        # "NodeSelected Pulse"
        Nsp : DesUtils.DPulse @  {
            InpD ~ CtrlCp.NavCtrl.NodeSelected
            InpE ~ : State {
                = "URI _INV"
            }
        }
        Nsp.Delay < = "URI"
        Nsp.Delay < Debug.LogLevel = "Dbg"
        NspDbg : State {
            Debug.LogLevel = "Dbg"
            = "URI _INV"
        }
        NspDbg.Inp ~ Nsp.Outp
        Cursor.Inp ~ : TrSwitchBool @  {
            Sel ~ CtrlCp.NavCtrl.CmdUp
            Inp1 ~ Tr1Dbg : TrSwitchBool @  {
                Sel ~ : TrIsValid @  {
                    Inp ~ Cursor
                }
                Inp1 ~ Const_SMdlRoot : State {
                    = "URI"
                }
                Inp2 ~ : TrSvldVar @  {
                    Inp1 ~ : TrApndVar @  {
                        Inp1 ~ Cursor
                        Inp2 ~ Nsp.Outp
                    }
                    Inp2 ~ Cursor
                }
            }
            Inp2 ~ : TrToUriVar @  {
                Inp ~ CursorUdp.Owner
            }
        }
        # " DRP creation"
        CpAddDrp : ContainerMod.DcAddWdgSc
        CpAddDrp ~ CtrlCp.NavCtrl.MutAddWidget
        CpAddDrp.Name ~ : State {
            = "SS Drp"
        }
        CpAddDrp.Parent ~ : State {
            = "SS AvrMdl2.NodeDrp"
        }
        DrpAddedPulse : DesUtils.BChange @  {
            SInp ~ CpAddDrp.Added
        }
        # " Model URI"
        CtrlCp.NavCtrl.DrpCp.InpModelUri ~ MdlUri : TrSwitchBool @  {
            # " Model URI is set only after DRP has been created"
            Sel ~ DrpAddedPulse.Outp
            Inp1 ~ : State {
                = "URI _INV"
            }
            Inp2 ~ Cursor
        }
        MdlUriDbg : State @  {
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "URI _INV"
            }
            Inp ~ MdlUri
        }
        SModelUri : State @  {
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "URI _INV"
            }
            Inp ~ ModelUri : TrSvldVar @  {
                Inp1 ~ MdlUri
                Inp2 ~ SModelUri
            }
        }
        # " VRP dirty indication"
        VrpDirty : State {
            Debug.LogLevel = "Dbg"
            = "SB false"
        }
        VrpDirty.Inp ~ : TrAndVar @  {
            Inp ~ U_Neq : TrCmpVar @  {
                Inp ~ ModelUri
                Inp2 ~ Cursor
            }
            Inp ~ CpAddDrp.Added
            Inp ~ : TrIsValid @  {
                Inp ~ ModelUri
            }
        }
        # " DRP removal on VRP dirty"
        CpRmDrp : ContainerMod.DcRmWdgSc
        CpRmDrp ~ CtrlCp.NavCtrl.MutRmWidget
        CpRmDrp.Name ~ : State {
            = "SS Drp"
        }
        CpRmDrp.Enable ~ VrpDirty
        Dbg_DrpRemoved : State @  {
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "SB _INV"
            }
            Inp ~ CpRmDrp.Done
        }
        DrpRemovedPulse : DesUtils.BChange @  {
            SInp ~ CpRmDrp.Done
        }
        SDrpCreated_Dbg : State @  {
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "SB false"
            }
            Inp ~ CpAddDrp.Added
        }
        DrpAddedTg : DesUtils.RSTg @  {
            InpS ~ DrpAddedPulse.Outp
            InpR ~ DrpRemovedPulse.Outp
        }
        CpAddDrp.Enable ~ : TrNegVar @  {
            Inp ~ DrpAddedTg.Outp
        }
    }
}
