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
        SCrpCtx_Dbg_MagUri : State (
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "SS _INV"
            }
            Inp ~ CrpCtx.DrpMagUri
        )
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
        MagAdp : DAdp (
            _@ <  {
                Debug.LogLevel = "Dbg"
                Name : SdoName
                Parent : SdoParent
            }
            InpMagBase ~ CrpCtx.ModelMntp
            InpMagUri ~ : TrApndVar (
                Inp1 ~ : TrToUriVar (
                    Inp ~ CrpCtx.DrpMagUri
                )
                Inp2 ~ : TrToUriVar (
                    Inp ~ : SdoName
                )
            )
        )
        Name_Dbg : State (
            _@ <  {
                = "SS _INV"
                Debug.LogLevel = "Dbg"
            }
            Inp ~ MagAdp.Name
        )
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
            Slot_Name : ContainerMod.FHLayoutSlot (
                Next ~ Start.Prev
                SCp ~ Name.Cp
            )
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
            Slot_Parent : ContainerMod.FHLayoutSlot (
                Next ~ Slot_Name.Prev
                Prev ~ End.Next
                SCp ~ Parent.Cp
            )
        }
        Header.Name.SText.Inp ~ MagAdp.Name
        Header.Parent.SText.Inp ~ MagAdp.Parent
        Slot_Header : ContainerMod.FVLayoutSlot (
            Next ~ Start.Prev
            SCp ~ Header.Cp
        )
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
        Slot_Body : ContainerMod.FVLayoutSlot (
            Next ~ Slot_Header.Prev
            Prev ~ End.Next
            SCp ~ Body.Cp
        )
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
        # ">>> Node detail representation"
        Controllable = "y"
        # "DRP context"
        DrpCtx : DesCtxCsm {
            ModelMntp : ExtdStateMnodeOutp
            DrpMagUri : ExtdStateOutp
        }
        # "Misc"
        XPadding < = "SI 10"
        YPadding < = "SI 5"
        # "Managed agent (node) adapter - MAG adapter"
        MagAdp : DAdp (
            _@ < Debug.LogLevel = "Dbg"
            _@ <  {
                Name : SdoName
                CompsCount : SdoCompsCount
                CompNames : SdoCompsNames
            }
            InpMagBase ~ DrpCtx.ModelMntp
            InpMagUri ~ DrpCtx.DrpMagUri
        )
        # "CRP context"
        CrpCtx : DesCtxSpl (
            _@ <  {
                ModelMntp : ExtdStateMnodeOutp
                DrpMagUri : ExtdStateOutp
            }
            ModelMntp.Int ~ DrpCtx.ModelMntp
            DrpMagUri.Int ~ MagAdp.OutpMagUri
        )
        # "Comp names debugging"
        CmpNamesDbg : State (
            Inp ~ MagAdp.CompNames
            _@ < Debug.LogLevel = "Dbg"
        )
        CmpCountDbg : State (
            _@ <  {
                = "SI -1"
                Debug.LogLevel = "Dbg"
            }
            Inp ~ MagAdp.CompsCount
        )
        # " Add wdg controlling Cp"
        CpAddCrp : ContainerMod.DcAddWdgSc
        CpAddCrp ~ IoAddWidg
        SCrpCreated_Dbg : State (
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "SB false"
            }
            Inp ~ CpAddCrp.Added
        )
        CompsIdx : State (
            # "Iterator of MAG component"
            _@ <  {
                = "SI 0"
                Debug.LogLevel = "Dbg"
            }
            Inp ~ : TrSwitchBool (
                Debug.LogLevel = "Dbg"
                Sel ~ CidxAnd1 : TrAndVar (
                    Inp ~ Cmp_Gt : TrCmpVar (
                        Inp ~ : TrAddVar (
                            Inp ~ MagAdp.CompsCount
                            InpN ~ : State {
                                = "SI 1"
                            }
                        )
                        Inp2 ~ CompsIdx
                        _@ < Debug.LogLevel = "Dbg"
                    )
                    Inp ~ CpAddCrp.Added
                    # "Second Inp connection after SdcConnCrpAdp"
                )
                Inp1 ~ CompsIdx
                Inp2 ~ : TrAddVar (
                    Inp ~ CompsIdx
                    Inp ~ : State {
                        = "SI 1"
                    }
                )
            )
        )
        CompNameDbg : State {
            = "SS _INV"
            Debug.LogLevel = "Dbg"
        }
        CompNameDbg.Inp ~ CompName : TrAtVar (
            Inp ~ MagAdp.CompNames
            Index ~ CompsIdx
        )
        # " CRP creation"
        CpAddCrp.Name ~ CompName
        CpAddCrp.Parent ~ : State {
            = "SS NodeCrp3"
        }
        CpAddCrp.Enable ~ CmpCn_Ge : TrCmpVar (
            Inp ~ MagAdp.CompsCount
            Inp2 ~ : State {
                = "SI 1"
            }
        )
        # "<<< Node detail representation"
    }
    VtStartSlot : Syst {
        # "VertDRP vertical tunnel slot. Start Comp slot."
        Prev : ContainerMod.SlotLinPrevCp {
            ItemPos : CpStateInp
            ColumnPos : CpStateInp
        }
    }
    VtEndSlot : Syst {
        # "VertDRP vertical tunnel slot. End Comp slot."
        Next : ContainerMod.SlotLinNextCp {
            ItemPos : CpStateOutp
            ColumnPos : CpStateOutp
        }
    }
    VertDrpVtSlot : ContainerMod.FSlotLin {
        # "VertDRP vertical tunnel slot"
        Prev <  {
            Pos : CpStateInp
        }
        Next <  {
            Pos : CpStateOutp
        }
        Prev.Pos ~ Next.Pos
        Start : VtStartSlot
        End : VtEndSlot
        Start.Prev ~ End.Next
        Start.Prev.AlcX ~ AddAlcX : TrAddVar (
            Inp ~ Next.AlcX
            Inp ~ Next.CntRqsW
            Inp ~ Next.XPadding
        )
        Start.Prev.AlcY ~ Next.AlcY
        Start.Prev.XPadding ~ Next.XPadding
        Start.Prev.YPadding ~ Next.YPadding
        Start.Prev.ColumnPos ~ Next.Pos
        Start.Prev.ItemPos ~ : SI_0
        Prev.AlcX ~ End.Next.AlcX
        Prev.AlcY ~ End.Next.AlcY
        Prev.AlcW ~ End.Next.AlcW
        Prev.AlcH ~ End.Next.AlcH
    }
    VertDrpVt : ContainerMod.DHLayout {
        # "VertDRP vertical tunnel. NOT USED ATM."
    }
    VertCrpEdgeCp : Socket {
        # "VertCrp CP to Edge"
        ColumnPos : CpStateInp
        # "TODO unused?"
        PairColumnPos : CpStateOutp
        Pos : CpStateInp
        PairPos : CpStateOutp
        LeftCpAlloc : CpStateInp
        RightCpAlloc : CpStateInp
    }
    VertCrpEdgeCpm : Socket {
        # "VertCrp CP to Edge. Mate."
        ColumnPos : CpStateOutp
        PairColumnPos : CpStateInp
        Pos : CpStateOutp
        PairPos : CpStateInp
        LeftCpAlloc : CpStateOutp
        RightCpAlloc : CpStateOutp
    }
    VertCrp : NodeCrp3 {
        # ">>> Vertex compact representation"
        # "Extend widget CP to for positions io"
        Cp <  {
            ItemPos : CpStateOutp
            ColumnPos : CpStateOutp
        }
        # "Edge CRP connpoint"
        EdgeCrpCp : VertCrpEdgeCp (
            ColumnPos ~ Cp.ColumnPos
            Pos ~ Tpl1 : TrTuple (
                Inp ~ : State {
                    = "TPL,SI:col,SI:item -1 -1"
                }
                _@ <  {
                    col : CpStateInp
                    item : CpStateInp
                }
                col ~ Cp.ColumnPos
                item ~ Cp.ItemPos
            )
            # "LeftCpAlloc -> "
        )
        Tpl1_Dbg : State (
            _@ <  {
                = "TPL,SI:col,SI:item -1 -1"
                Debug.LogLevel = "Dbg"
            }
            Inp ~ Tpl1
        )
        # "Vert CRP context"
        VertCrpCtx : DesCtxCsm {
            # "CRP parameters: positioning etc"
            CrpPars : ExtdStateInp
        }
        ItemPos_Dbg : State (
            _@ <  {
                = "SI _INV"
                Debug.LogLevel = "Dbg"
            }
            Inp ~ Cp.ItemPos
        )
        ColumnPos_Dbg : State (
            _@ <  {
                = "SI _INV"
                Debug.LogLevel = "Dbg"
            }
            Inp ~ Cp.ColumnPos
        )
        # "Most right column of the pairs"
        # "   Inputs Iterator"
        PairPosIter : DesUtils.InpItr (
            InpM ~ EdgeCrpCp.PairPos
            InpDone ~ : SB_True
            PosChgDet : DesUtils.ChgDetector (
                Inp ~ EdgeCrpCp.PairPos
            )
            InpReset ~ PosChgDet.Outp
        )
        PairPosIterDone_Dbg : State (
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "SB _INV"
            }
            Inp ~ PairPosIter.OutpDone
        )
        # "   Selected input"
        PairPosSel : TrInpSel (
            Inp ~ EdgeCrpCp.PairPos
            Idx ~ PairPosIter.Outp
        )
        PairPosSel_Dbg : State (
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "TPL,SI:col,SI:item -1 -1"
            }
            Inp ~ PairPosSel
        )
        SameColPair : State (
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "TPL,SI:col,SI:item -1 -1"
            }
            Inp ~ : TrSwitchBool (
                Inp1 ~ : TrSwitchBool (
                    Inp1 ~ : State {
                        = "TPL,SI:col,SI:item -1 -1"
                    }
                    Inp2 ~ SameColPair
                    Sel ~ CmpCn_Ge : TrCmpVar (
                        Inp ~ PairPosIter.Outp
                        Inp2 ~ : SI_1
                    )
                )
                Inp2 ~ PairPosSel
                Sel ~ ColPos_Eq : TrCmpVar (
                    Inp ~ : TrTupleSel (
                        Inp ~ PairPosSel
                        Comp ~ : State {
                            = "SS col"
                        }
                    )
                    Inp2 ~ Cp.ColumnPos
                )
            )
        )
        # "<<< Most right column of the pairs"
        # " Connect parameters to context"
        VertCrpCtx.CrpPars ~ : TrTuple (
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
            pmrcolpos ~ : TrTupleSel (
                Inp ~ SameColPair
                Comp ~ : State {
                    = "SS col"
                }
            )
        )
        # "Left connpoint allocation"
        LeftCpAlc : TrPair (
            First ~ AlcX
            Second ~ : TrAddVar (
                Inp ~ AlcY
                Inp ~ : TrDivVar (
                    Inp ~ AlcH
                    Inp2 ~ : State {
                        = "SI 2"
                    }
                )
            )
        )
        EdgeCrpCp.LeftCpAlloc ~ LeftCpAlc
        # "Right connpoint allocation"
        RightCpAlc : TrPair (
            First ~ : TrAddVar (
                Inp ~ AlcX
                Inp ~ AlcW
            )
            Second ~ : TrAddVar (
                Inp ~ AlcY
                Inp ~ : TrDivVar (
                    Inp ~ AlcH
                    Inp2 ~ : State {
                        = "SI 2"
                    }
                )
            )
        )
        EdgeCrpCp.RightCpAlloc ~ RightCpAlc
        # "<<< Vertex compact representation"
    }
    _$ <  {
        # ">>> Edge CRP segments"
        EhsSlCp : Socket {
            # "Edges horizontal segment slot CP. Provides Y and requires X"
            X : CpStateOutp
            Y : CpStateInp
        }
        EhsSlCpNext : EhsSlCp {
            # "Edges horizontal segment slot Next Cp. Left (ColIdx) and right (ColRIdx) col idxs"
            Hash : CpStateOutp
            ColIdx : CpStateOutp
            ColRIdx : CpStateInp
        }
        EhsSlCpPrev : EhsSlCp {
            # "Edges horizontal segment slot Prev Cp."
            Hash : CpStateInp
            ColIdx : CpStateInp
            ColRIdx : CpStateOutp
        }
        EhtsSlCp : Socket {
            # "Edges horizontal terminal segment slot terminal CP. Requires X, Y"
            X : CpStateOutp
            Y : CpStateOutp
        }
        EhtsSlCpNext : EhtsSlCp {
            # "Edges horizontal terminal segment slot terminal Next CP."
            Hash : CpStateOutp
            ColIdx : CpStateOutp
            ColRIdx : CpStateInp
        }
        EhtsSlCpPrev : EhtsSlCp {
            # "Edges horizontal terminal segment slot terminal Prev CP."
            Hash : CpStateInp
            ColIdx : CpStateInp
            ColRIdx : CpStateOutp
        }
        EhsSlCpm : Socket {
            # "Edges horizontal segment slot CP mate. Provides X and requires Y"
            X : CpStateInp
            Y : CpStateOutp
        }
        EhsSlCpmNext : EhsSlCpm {
            # "Edges horizontal segment slot CP mate Next."
            Hash : CpStateOutp
            ColIdx : CpStateOutp
            ColRIdx : CpStateInp
        }
        EhsSlCpmPrev : EhsSlCpm {
            # "Edges horizontal segment slot CP mate Prev."
            Hash : CpStateInp
            ColIdx : CpStateInp
            ColRIdx : CpStateOutp
        }
        EhtsSlCpm : Socket {
            # "Edges horizontal terminal segment slot terminal CP mate. Provides X, Y"
            X : CpStateInp
            Y : CpStateInp
        }
        EhtsSlCpmNext : EhtsSlCpm {
            # "Edges horizontal terminal segment slot terminal CP mate Next."
            Hash : CpStateOutp
            ColIdx : CpStateOutp
            ColRIdx : CpStateInp
        }
        EhtsSlCpmPrev : EhtsSlCpm {
            # "Edges horizontal terminal segment slot terminal CP mate Prev."
            Hash : CpStateInp
            ColIdx : CpStateInp
            ColRIdx : CpStateOutp
        }
        EdgeSSlotCoordCp : Socket {
            # "Edge segments slot coords CP."
            LeftX : ExtdStateOutp
            LeftY : ExtdStateOutp
            RightX : ExtdStateOutp
            RightY : ExtdStateOutp
        }
        EdgeCrpHsSlot : ContainerMod.ColumnItemSlot {
            # ">>> Edge CRP Horizontal segment slot"
            Explorable = "y"
            Prev  (
                AlcX !~ SCp.OutAlcX
                AlcX ~ Next.AlcX
                AlcY !~ SCp.OutAlcY
                AlcY ~ Add1
                # "TODO Do we need to set AlcH ?"
            )
            EsPrev : EhsSlCpPrev
            EsNext : EhsSlCpNext
            EsPrev.Y ~ Add1
            _ <  {
                EsPrev.Hash ~ EsNext.Hash
                EsPrev.Hash ~ Next.AlcY
            }
            EsPrev.Hash ~ : TrHash (
                Inp ~ EsNext.Hash
                Inp ~ Next.AlcY
            )
            EsPrev.ColIdx ~ EsNext.ColIdx
            EsNext.Y ~ Add1
            EsNext.ColRIdx ~ : TrSub2Var (
                Inp ~ EsPrev.ColRIdx
                Inp2 ~ : SI_1
            )
            Coords : EdgeSSlotCoordCp
            Coords.LeftX.Int ~ EsNext.X
            Coords.LeftY.Int ~ Add1
            Coords.RightX.Int ~ EsPrev.X
            Coords.RightY.Int ~ Add1
            # "DES to include SDCs"
            DesAgent : ADes
            # "Uses EdgeCRP context to get controlling access to DRP"
            EdgeCrpCtx : DesCtxCsm {
                DrpMntp : ExtdStateMnodeOutp
            }
            DrpAdp : DAdp (
                InpMagBase ~ EdgeCrpCtx.DrpMntp
                InpMagUri ~ : State {
                    = "URI _$"
                }
            )
            TnlSlotName : TrApndVar (
                _@ < Debug.LogLevel = "Dbg"
                Inp1 ~ : Const {
                    = "SS Column_"
                }
                Inp2 ~ : TrTostrVar (
                    Inp ~ EsNext.ColIdx
                )
            )
            SelfUri : SdoUri
            DrpAdp <  {
                Explorable = "y"
                AdpTnlSlotName : ExtdStateInp
                CurColIdx : ExtdStateInp
                ReqColIdx : ExtdStateInp
                ColRIdx : ExtdStateInp
                AdpSlotUri : ExtdStateInp
                # "Constants"
                KS_Prev : Const {
                    = "SS Prev"
                }
                KS_Next : Const {
                    = "SS Next"
                }
                KS_Start : Const {
                    = "SS Start"
                }
                KS_End : Const {
                    = "SS End"
                }
                # "Slot URI relative to DRP"
                SlotUriRdrp : TrTailVar (
                    Inp ~ AdpSlotUri.Int
                    Head ~ : SdoUri
                )
                SlotUriRdrp_Dbg : State (
                    # "TODO Helps init SlotUriRdrp, to remove"
                    _@ <  {
                        Debug.LogLevel = "Dbg"
                        = "URI"
                    }
                    Inp ~ SlotUriRdrp
                )
                # "Re-insert slot to given column"
                SdcExtrHs : ASdcExtract (
                    _@ < Debug.LogLevel = "Dbg"
                    Enable ~ : TrAndVar (
                        Inp ~ Columns_Neq : TrCmpVar (
                            _@ < Debug.LogLevel = "Dbg"
                            Inp ~ CurColIdx.Int
                            Inp2 ~ ReqColIdx.Int
                        )
                        Inp ~ CurColIdxValid : TrIsValid (
                            Inp ~ CurColIdx.Int
                        )
                    )
                    Name ~ : TrTostrVar (
                        Inp ~ SlotUriRdrp
                    )
                    SdcExtrHs.Prev ~ KS_Prev
                    SdcExtrHs.Next ~ KS_Next
                )
                SdcInsertToCol : ASdcInsert2 (
                    _@ < Debug.LogLevel = "Dbg"
                    Enable ~ SdcExtrHs.Outp
                    Enable ~ : TrIsValid (
                        Inp ~ ReqColIdx.Int
                    )
                    Enable ~ : TrIsValid (
                        Inp ~ ColRIdx.Int
                    )
                    Name ~ : TrTostrVar (
                        Inp ~ SlotUriRdrp
                    )
                    Pname ~ : TrApndVar (
                        Inp1 ~ AdpTnlSlotName.Int
                        Inp2 ~ : Const {
                            = "SS .End"
                        }
                    )
                    SdcInsertToCol.Prev ~ KS_Prev
                    SdcInsertToCol.Next ~ KS_Next
                )
            }
            DrpAdp.AdpTnlSlotName ~ TnlSlotName
            DrpAdp.CurColIdx ~ Next.ColumnPos
            DrpAdp.ReqColIdx ~ EsNext.ColIdx
            DrpAdp.ColRIdx ~ EsPrev.ColRIdx
            DrpAdp.AdpSlotUri ~ SelfUri
            # "<<< Edge CRP Horizontal segment slot"
        }
        EdgeCrpVsSlot : ContainerMod.FSlotLin {
            # ">>> Edge CRP Vertical segment slot"
            Explorable = "y"
            # "Extend chain CPs for positions io"
            Prev <  {
                ItemPos : CpStateInp
                ColumnPos : CpStateInp
            }
            Next <  {
                ItemPos : CpStateOutp
                ColumnPos : CpStateOutp
            }
            Prev.ItemPos ~ : TrAddVar (
                Inp ~ Next.ItemPos
                Inp ~ : SI_1
            )
            Prev.ColumnPos ~ : ExtdStateOutpI (
                Int ~ Next.ColumnPos
            )
            # "DES to include SDCs"
            DesAgent : ADes
            # "Uses EdgeCRP context to get controlling access to DRP"
            EdgeCrpCtx : DesCtxCsm {
                DrpMntp : ExtdStateMnodeOutp
            }
            DrpAdp : DAdp (
                InpMagBase ~ EdgeCrpCtx.DrpMntp
                InpMagUri ~ : State {
                    = "URI _$"
                }
            )
            EsPrev : EhsSlCpmPrev
            EsNext : EhsSlCpmNext
            AddX : TrAddVar (
                Inp ~ Next.AlcX
                Inp ~ Next.AlcW
                Inp ~ Next.XPadding
            )
            Prev.AlcX ~ AddX
            Prev.AlcY ~ Next.AlcY
            Prev.AlcH ~ Next.AlcH
            # "TODO Do we need to set AlcW ?"
            EsPrev.X ~ AddX
            EsNext.X ~ AddX
            EsNext.ColRIdx ~ EsPrev.ColRIdx
            EsPrev.Hash ~ EsNext.Hash
            EsPrev.Hash ~ Next.AlcX
            EsPrev.ColIdx ~ : TrAddVar (
                Inp ~ EsNext.ColIdx
                Inp ~ : SI_1
            )
            Coords : EdgeSSlotCoordCp
            Coords.LeftX.Int ~ AddX
            Coords.LeftY.Int ~ EsNext.Y
            Coords.RightX.Int ~ AddX
            Coords.RightY.Int ~ EsPrev.Y
            TnlSlotName : TrApndVar (
                _@ < Debug.LogLevel = "Dbg"
                Inp1 ~ : TrApndVar (
                    Inp1 ~ : Const {
                        = "SS Column_"
                    }
                    Inp2 ~ : TrTostrVar (
                        Inp ~ EsNext.ColIdx
                    )
                )
                Inp2 ~ : Const {
                    = "SS _vt"
                }
            )
            SelfName : SdoName
            SelfUri : SdoUri
            DrpAdp <  {
                Explorable = "y"
                AdpTnlSlotName : ExtdStateInp
                CurColIdx : ExtdStateInp
                ReqColIdx : ExtdStateInp
                ColRIdx : ExtdStateInp
                AdpSlotName : ExtdStateInp
                AdpSlotUri : ExtdStateInp
                # "Constants"
                KS_Prev : Const {
                    = "SS Prev"
                }
                KS_Next : Const {
                    = "SS Next"
                }
                KS_Start : Const {
                    = "SS Start"
                }
                KS_End : Const {
                    = "SS End"
                }
                # "Slot URI relative to DRP"
                SlotUriRdrp : TrTailVar (
                    Inp ~ AdpSlotUri.Int
                    Head ~ : SdoUri
                )
                SlotUriRdrp_Dbg : State (
                    _@ <  {
                        Debug.LogLevel = "Dbg"
                        = "URI"
                    }
                    Inp ~ SlotUriRdrp
                )
                # "Re-insert slot to given vertical tunnel"
                SdcExtrVs : ASdcExtract (
                    _@ < Debug.LogLevel = "Dbg"
                    # "Enable extracting if req and cur column idxs arent met or req col idx is invalid"
                    Enable ~ : TrSwitchBool (
                        Inp1 ~ : SB_True
                        Inp2 ~ : TrAndVar (
                            Inp ~ Columns_Neq : TrCmpVar (
                                _@ < Debug.LogLevel = "Dbg"
                                Inp ~ CurColIdx.Int
                                Inp2 ~ ReqColIdx.Int
                            )
                            Inp ~ CurColIdxValid : TrIsValid (
                                Inp ~ CurColIdx.Int
                            )
                        )
                        Sel ~ : TrIsValid (
                            Inp ~ ReqColIdx.Int
                        )
                    )
                    _ <  {
                        # "!! To fix"
                        Name ~ SlotUriRdrp
                    }
                    Name ~ : TrTostrVar (
                        Inp ~ SlotUriRdrp
                    )
                    SdcExtrVs.Prev ~ KS_Prev
                    SdcExtrVs.Next ~ KS_Next
                )
                SdcInsertToVt : ASdcInsert2 (
                    _@ < Debug.LogLevel = "Dbg"
                    Enable ~ SdcExtrVs.Outp
                    Enable ~ : TrIsValid (
                        Inp ~ ReqColIdx.Int
                    )
                    Enable ~ : TrIsValid (
                        Inp ~ ColRIdx.Int
                    )
                    Name ~ : TrTostrVar (
                        Inp ~ SlotUriRdrp
                    )
                    Pname ~ : TrApndVar (
                        Inp1 ~ AdpTnlSlotName.Int
                        Inp2 ~ : Const {
                            = "SS .End"
                        }
                    )
                    SdcInsertToVt.Prev ~ KS_Prev
                    SdcInsertToVt.Next ~ KS_Next
                )
            }
            DrpAdp.AdpTnlSlotName ~ TnlSlotName
            DrpAdp.CurColIdx ~ : TrAdd2Var (
                # "Note that tunnel idx is (col_idx + 1) atm"
                Inp ~ Next.ColumnPos
                Inp2 ~ : State {
                    = "SI -1"
                }
            )
            DrpAdp.ReqColIdx ~ EsNext.ColIdx
            DrpAdp.ColRIdx ~ EsPrev.ColRIdx
            DrpAdp.AdpSlotName ~ SelfName
            DrpAdp.AdpSlotUri ~ SelfUri
            # "<<< Edge CRP Vertical segment slot"
        }
        EdgeCrpRsSlot : Syst {
            # "Edge CRP regular slot. The slot is combined from vertical and horisontal slots."
            # "DES to include SDCs"
            DesAgent : ADes
            EsNext : Extd {
                Int : EhsSlCpm {
                    Hash : CpStateInp
                    ColIdx : CpStateInp
                    ColRIdx : CpStateOutp
                }
            }
            EsPrev : Extd {
                Int : EhsSlCp {
                    Hash : CpStateOutp
                    ColIdx : CpStateOutp
                    ColRIdx : CpStateInp
                }
            }
            Hs : EdgeCrpHsSlot
            Vs : EdgeCrpVsSlot
            Hs.EsNext ~ EsNext.Int
            Vs.EsNext ~ Hs.EsPrev
            EsPrev.Int ~ Vs.EsPrev
        }
        EdgeCrpHssSlot : Syst {
            # "Edge CRP Horizontal start segment slot"
            EsPrev : EhsSlCpPrev
            EsNext : EhtsSlCpNext
            EsPrev.Y ~ EsNext.Y
            EsPrev.Hash ~ EsNext.X
            EsPrev.Hash ~ EsNext.Y
            EsPrev.ColIdx ~ EsNext.ColIdx
            EsNext.ColRIdx ~ : TrSub2Var (
                Inp ~ EsPrev.ColRIdx
                Inp2 ~ : SI_1
            )
            Coords : EdgeSSlotCoordCp
            Coords.LeftX.Int ~ EsNext.X
            Coords.LeftY.Int ~ EsNext.Y
            Coords.RightX.Int ~ EsPrev.X
            Coords.RightY.Int ~ EsNext.Y
        }
        EdgeCrpHesSlot : Syst {
            # "Edge CRP Horizontal end segment slot"
            EsPrev : EhtsSlCpPrev
            EsNext : EhsSlCpNext
            EsNext.Y ~ EsPrev.Y
            EsNext.ColRIdx ~ EsPrev.ColRIdx
            EsPrev.Hash ~ EsNext.Hash
            EsPrev.Hash ~ EsPrev.Y
            EsPrev.Hash ~ EsNext.X
            EsPrev.ColIdx ~ EsNext.ColIdx
            Coords : EdgeSSlotCoordCp
            Coords.LeftX.Int ~ EsNext.X
            Coords.LeftY.Int ~ EsPrev.Y
            Coords.RightX.Int ~ EsPrev.X
            Coords.RightY.Int ~ EsPrev.Y
        }
        # "<<< Edge CRP segments"
    }
    EdgeCrp : FvWidgets.FWidgetBase {
        # ">>> Edge compact repesentation"
        Controllable = "y"
        WdgAgent : AEdgeCrp
        WdgAgent < Debug.LogLevel = "Dbg"
        EdgeCrpCtx : DesCtxCsm {
            DrpMntp : ExtdStateMnodeOutp
        }
        DrpAdp : DAdp (
            InpMagBase ~ EdgeCrpCtx.DrpMntp
            InpMagUri ~ : State {
                = "URI _$"
            }
        )
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
        LeftCpAlc_Dbg : State (
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "PSI (SI _INV , SI _INV)"
            }
            Inp ~ VertCrpPCp.LeftCpAlloc
        )
        VertPOnLeft_Lt : TrCmpVar (
            Inp ~ VertCrpPCp.ColumnPos
            Inp2 ~ VertCrpQCp.ColumnPos
        )
        # "VertCrp P attachment point allocation"
        VertPApAlc : TrSwitchBool (
            Inp1 ~ VertCrpPCp.LeftCpAlloc
            Inp2 ~ VertCrpPCp.RightCpAlloc
            Sel ~ VertPOnLeft_Lt
        )
        # "VertCrp Q attachment point allocation"
        VertQApAlc : TrSwitchBool (
            Inp1 ~ VertCrpQCp.RightCpAlloc
            Inp2 ~ VertCrpQCp.LeftCpAlloc
            Sel ~ VertPOnLeft_Lt
        )
        LeftVertColPos : TrSwitchBool (
            _@ < Debug.LogLevel = "Dbg"
            Inp1 ~ VertCrpQCp.ColumnPos
            Inp2 ~ VertCrpPCp.ColumnPos
            Sel ~ VertPOnLeft_Lt
        )
        LeftVertColPos_Dbg : State (
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "SI"
            }
            Inp ~ LeftVertColPos
        )
        RightVertColPos : TrSwitchBool (
            Inp1 ~ VertCrpPCp.ColumnPos
            Inp2 ~ VertCrpQCp.ColumnPos
            Sel ~ VertPOnLeft_Lt
        )
        RightVertColPos_Dbg : State (
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "SI"
            }
            Inp ~ RightVertColPos
        )
        # "Left vert attachment point allocation"
        LeftVertApAlc : TrSwitchBool (
            Inp1 ~ VertQApAlc
            Inp2 ~ VertPApAlc
            Sel ~ VertPOnLeft_Lt
        )
        # "Left vert allocation CP - bridge to edge terminal segment"
        LeftVertAlcCp : EhtsSlCpmPrev (
            X ~ : TrAtgVar (
                Inp ~ LeftVertApAlc
                Index ~ : SI_0
            )
            Y ~ : TrAtgVar (
                Inp ~ LeftVertApAlc
                Index ~ : SI_1
            )
            ColIdx ~ LeftVertColPos
        )
        SegmentsColRIdxRes : State (
            _@ < = "SI"
            _@ < Debug.LogLevel = "Dbg"
            Inp ~ LeftVertAlcCp.ColRIdx
        )
        # "Right vert attachment point allocation"
        RightVertApAlc : TrSwitchBool (
            Inp1 ~ VertPApAlc
            Inp2 ~ VertQApAlc
            Sel ~ VertPOnLeft_Lt
        )
        # "Right vert allocation CP - bridge to edge terminal segment"
        RightVertAlcCp : EhtsSlCpmNext (
            X ~ : TrAtgVar (
                Inp ~ RightVertApAlc
                Index ~ : SI_0
            )
            Y ~ : TrAtgVar (
                Inp ~ RightVertApAlc
                Index ~ : SI_1
            )
            ColRIdx ~ RightVertColPos
        )
        SegmentsColIdxRes : State (
            _@ < = "SI"
            _@ < Debug.LogLevel = "Dbg"
            Inp ~ RightVertAlcCp.ColIdx
        )
        SegmentsHash : State (
            _@ < = "SI"
            _@ < Debug.LogLevel = "Dbg"
            Inp ~ : TrHash (
                Inp ~ RightVertAlcCp.Hash
            )
        )
        _$ <  {
            # ">>> Creation of edges segments"
            # "Detector of Connection to vertexes"
            VertsConnected : TrAndVar (
                _@ < Debug.LogLevel = "Dbg"
                Inp ~ Dtv_Gt : TrCmpVar (
                    Inp ~ : SdoPairsCount (
                        _@ < Debug.LogLevel = "Dbg"
                        Vp ~ : Const {
                            = "SS VertCrpPCp"
                        }
                    )
                    Inp2 ~ : SI_0
                )
                Inp ~ Dtv_Gt_2 : TrCmpVar (
                    Inp ~ : SdoPairsCount (
                        Vp ~ : Const {
                            = "SS VertCrpQCp"
                        }
                    )
                    Inp2 ~ : SI_0
                )
            )
            # "Column Positions Iterator"
            SelfName : SdoName
            DrpAdp <  {
                # ">>> Edge's VertDRP adapter"
                Explorable = "y"
                EdgeName : ExtdStateInp
                EdgeLeftVertColPos : ExtdStateInp
                EdgeRightVertColPos : ExtdStateInp
                EdgeSegmentsColIdxRes : ExtdStateInp
                EdgeVertsConnected : ExtdStateInp
                # "Constants"
                KS_Prev : Const {
                    = "SS Prev"
                }
                KS_Next : Const {
                    = "SS Next"
                }
                KS_Start : Const {
                    = "SS Start"
                }
                KS_End : Const {
                    = "SS End"
                }
                KS_Col_Pref : Const {
                    = "SS Column_"
                }
                KS_EsPrev : Const {
                    = "SS EsPrev"
                }
                KS_EsNext : Const {
                    = "SS EsNext"
                }
                # " "
                EdgeColIdxRsd : TrSub2Var (
                    # "Edge colum indexes residual"
                    _@ < Debug.LogLevel = "Dbg"
                    Inp ~ EdgeRightVertColPos.Int
                    Inp2 ~ EdgeSegmentsColIdxRes.Int
                )
                EdgeColIdxRsd_Dbg : State (
                    _@ <  {
                        Debug.LogLevel = "Dbg"
                        = "SI"
                    }
                    Inp ~ EdgeColIdxRsd
                )
                EdgeEtSegIdx : TrAddVar (
                    # "Edge end terminal segment index"
                    _@ < Debug.LogLevel = "Dbg"
                    Inp ~ EdgeSegmentsColIdxRes.Int
                    InpN ~ EdgeLeftVertColPos.Int
                )
                EdgeEtSegIdx_Dbg : State (
                    _@ <  {
                        Debug.LogLevel = "Dbg"
                        = "SI"
                    }
                    Inp ~ EdgeEtSegIdx
                )
                EdgeColRank : TrAddVar (
                    # "Edge colums rank: the number of colums between edges vertexes"
                    _@ < Debug.LogLevel = "Dbg"
                    Inp ~ EdgeRightVertColPos.Int
                    InpN ~ EdgeLeftVertColPos.Int
                )
                EdgeColRank_Dbg : State (
                    _@ <  {
                        Debug.LogLevel = "Dbg"
                        = "SI"
                    }
                    Inp ~ EdgeColRank
                )
                EdgeCR_Gt_0 : TrCmpVar (
                    _@ < Debug.LogLevel = "Dbg"
                    Inp ~ EdgeColRank
                    Inp2 ~ : SI_0
                )
                EdgeCR_Gt_1 : TrCmpVar (
                    _@ < Debug.LogLevel = "Dbg"
                    Inp ~ EdgeColRank
                    Inp2 ~ : SI_1
                )
                EdgeCidxRsd_Gt_0 : TrCmpVar (
                    _@ < Debug.LogLevel = "Dbg"
                    Inp ~ EdgeColIdxRsd
                    Inp2 ~ : SI_0
                )
                EdgeCidxRsd_Lt_0 : TrCmpVar (
                    _@ < Debug.LogLevel = "Dbg"
                    Inp ~ EdgeColIdxRsd
                    Inp2 ~ : SI_0
                )
                # "Creating and connecting start terminal segment"
                CreateStSeg : ASdcComp (
                    _@ < Debug.LogLevel = "Dbg"
                    Enable ~ EdgeCR_Gt_0
                    Name ~ LtSlotName : TrApndVar (
                        Inp1 ~ EdgeName.Int
                        Inp2 ~ : Const {
                            = "SS _LtSlot"
                        }
                    )
                    Parent ~ : Const {
                        = "SS EdgeCrpHssSlot"
                    }
                )
                SdcConnStSeg : ASdcConn (
                    Enable ~ CreateStSeg.Outp
                    V1 ~ : TrApndVar (
                        Inp1 ~ EdgeName.Int
                        Inp2 ~ : Const {
                            = "SS .LeftVertAlcCp"
                        }
                    )
                    V2 ~ : TrApndVar (
                        Inp1 ~ LtSlotName
                        Inp2 ~ : Const {
                            = "SS .EsNext"
                        }
                    )
                )
                # "Creating and connecting end terminal segment slot"
                CreateEtSeg : ASdcComp (
                    Enable ~ EdgeCR_Gt_0
                    _@ < Debug.LogLevel = "Dbg"
                    Name ~ RtSlotName : TrApndVar (
                        Inp1 ~ EdgeName.Int
                        Inp2 ~ : Const {
                            = "SS _RtSlot"
                        }
                    )
                    Parent ~ : Const {
                        = "SS EdgeCrpHesSlot"
                    }
                )
                SdcConnEtSeg : ASdcConn (
                    Enable ~ CreateStSeg.Outp
                    # "V1 --> "
                    V1 ~ : TrApndVar (
                        Inp1 ~ EdgeName.Int
                        Inp2 ~ : Const {
                            = "SS .RightVertAlcCp"
                        }
                    )
                    V2 ~ : TrApndVar (
                        Inp1 ~ RtSlotName
                        Inp2 ~ : Const {
                            = "SS .EsPrev"
                        }
                    )
                )
                # "Creating default vertical segment slot. Connecting to terminal slots"
                CreateVsSeg : ASdcComp (
                    _@ < Debug.LogLevel = "Dbg"
                    Enable ~ EdgeCR_Gt_0
                    Name ~ VsSlotName : TrApndVar (
                        Inp1 ~ EdgeName.Int
                        Inp2 ~ : Const {
                            = "SS _VsSlot"
                        }
                    )
                    Parent ~ : Const {
                        = "SS EdgeCrpVsSlot"
                    }
                )
                SdcConnVsSSeg : ASdcConn (
                    Enable ~ CreateVsSeg.Outp
                    V1 ~ : TrApndVar (
                        Inp1 ~ VsSlotName
                        Inp2 ~ : Const {
                            = "SS .EsNext"
                        }
                    )
                    V2 ~ : TrApndVar (
                        Inp1 ~ LtSlotName
                        Inp2 ~ : Const {
                            = "SS .EsPrev"
                        }
                    )
                )
                VsEsPrev : TrApndVar (
                    Inp1 ~ VsSlotName
                    Inp2 ~ : Const {
                        = "SS .EsPrev"
                    }
                )
                VsEsPrevNCntd_Eq : TrCmpVar (
                    _@ < Debug.LogLevel = "Dbg"
                    Inp ~ SdoPc : SdoPairsCount (
                        Vp ~ VsEsPrev
                    )
                    Inp2 ~ : SI_0
                )
                SdcConnVsESeg : ASdcConn (
                    _@ < Debug.LogLevel = "Dbg"
                    _ <  {
                        Enable ~ CreateVsSeg.Outp
                    }
                    Enable ~ : TrAndVar (
                        Inp ~ CreateVsSeg.Outp
                        Inp ~ VsEsPrevNCntd_Eq
                    )
                    V1 ~ VsEsPrev
                    V2 ~ : TrApndVar (
                        Inp1 ~ RtSlotName
                        Inp2 ~ : Const {
                            = "SS .EsNext"
                        }
                    )
                )
                LeftTnlSlotName : TrApndVar (
                    Inp1 ~ : TrApndVar (
                        Inp1 ~ : Const {
                            = "SS Column_"
                        }
                        Inp2 ~ : TrTostrVar (
                            Inp ~ EdgeLeftVertColPos.Int
                        )
                    )
                    Inp2 ~ : Const {
                        = "SS _vt"
                    }
                )
                RsNamePrefix : TrApndVar (
                    Inp1 ~ EdgeName.Int
                    Inp2 ~ : Const {
                        = "SS _Rs_"
                    }
                )
                # "Adding (creating and inserting to seg chain) regular segments"
                CreateRs : ASdcComp (
                    # "Creating regular slot"
                    _@ < Debug.LogLevel = "Dbg"
                    Enable ~ EdgeCidxRsd_Gt_0
                    Name ~ RsSlotName : TrApndVar (
                        Inp1 ~ RsNamePrefix
                        Inp2 ~ : TrTostrVar (
                            Inp ~ EdgeEtSegIdx
                        )
                    )
                    Parent ~ : Const {
                        = "SS EdgeCrpRsSlot"
                    }
                )
                EdgeRsColId : TrAddVar (
                    # "Edge regular slots column id"
                    Inp ~ EdgeLeftVertColPos.Int
                    Inp ~ EdgeEtSegIdx
                )
                EdgeRsColSlotName : TrApndVar (
                    # "Column slot name"
                    Inp1 ~ KS_Col_Pref
                    Inp2 ~ : TrTostrVar (
                        Inp ~ EdgeRsColId
                    )
                )
                EdgeRsTnlSlotName : TrApndVar (
                    # "Edge reg slot column vertical tunnel slot name"
                    Inp1 ~ EdgeRsColSlotName
                    Inp2 ~ : Const {
                        = "SS _vt"
                    }
                )
                SdcInsertRs : ASdcInsertN (
                    # "Insert regular slot to edge slot list"
                    _@ < Debug.LogLevel = "Dbg"
                    Enable ~ CreateRs.Outp
                    Enable ~ EdgeCidxRsd_Gt_0
                    Name ~ RsSlotName
                    Pname ~ VsSlotName
                    Prev ~ KS_EsPrev
                    Next ~ KS_EsNext
                )
                # "Extract excessive regular segments from seg chain"
                SdcExtrRs : ASdcExtract (
                    _@ < Debug.LogLevel = "Dbg"
                    Enable ~ EdgeCidxRsd_Lt_0
                    Name ~ ExtrRsSlotName : TrApndVar (
                        Inp1 ~ RsNamePrefix
                        Inp2 ~ : TrTostrVar (
                            Inp ~ ExtrRsIdx : TrSub2Var (
                                Inp ~ EdgeEtSegIdx
                                Inp2 ~ : SI_1
                            )
                        )
                    )
                    Prev ~ KS_EsPrev
                    Next ~ KS_EsNext
                )
                # "<<< Edge's VertDRP adapter"
            }
            DrpAdp.EdgeName ~ SelfName
            DrpAdp.EdgeLeftVertColPos ~ LeftVertColPos
            DrpAdp.EdgeRightVertColPos ~ RightVertColPos
            DrpAdp.EdgeSegmentsColIdxRes ~ SegmentsColIdxRes
            DrpAdp.EdgeVertsConnected ~ VertsConnected
            # "<<< Creation of edges segments"
        }
        # "<<< Edge compact repesentation"
    }
    VertCrpSlot : ContainerMod.ColumnItemSlot {
        # "Vertex DRP column item slot"
        # "Extend widget CP to for positions io"
        SCp <  {
            ItemPos : CpStateInp
            ColumnPos : CpStateInp
        }
        _ <  {
            SCp.ItemPos ~ Next.ItemPos
            SCp.ColumnPos ~ Next.ColumnPos
        }
        # "Break long IRM chain, ds_irm_wprc"
        SCp.ItemPos ~ : ExtdStateOutpI (
            Int ~ Next.ItemPos
        )
        # "Break long IRM chain, ds_irm_wprc"
        SCp.ColumnPos ~ : ExtdStateOutpI (
            Int ~ Next.ColumnPos
        )
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
        MagAdp : DAdp (
            _@ <  {
                Name : SdoName
                CompsCount : SdoCompsCount
                CompsNames : SdoCompsNames
                Edges : SdoEdges
            }
            InpMagBase ~ DrpCtx.ModelMntp
            InpMagUri ~ DrpCtx.DrpMagUri
        )
        # "CRP context"
        CrpCtx : DesCtxSpl (
            _@ <  {
                ModelMntp : ExtdStateMnodeOutp
                DrpMagUri : ExtdStateOutp
            }
            ModelMntp.Int ~ DrpCtx.ModelMntp
            DrpMagUri.Int ~ MagAdp.OutpMagUri
        )
        VDrpLink : Link {
            MntpOutp : CpStateMnodeOutp
        }
        VDrpLink ~ _$
        EdgeCrpCtx : DesCtxSpl (
            _@ <  {
                DrpMntp : ExtdStateMnodeOutp
            }
            DrpMntp.Int ~ VDrpLink.MntpOutp
        )
        # " Add wdg controlling Cp"
        CpAddCrp : ContainerMod.DcAddWdgSc
        CpAddCrp ~ IoAddWidg
        SCrpCreated_Dbg : State (
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "SB false"
            }
            Inp ~ CpAddCrp.Added
        )
        # "Model components Iterator"
        CompsIter : DesUtils.IdxItr (
            InpCnt ~ MagAdp.CompsCount
            InpDone ~ CpAddCrp.Added
            InpReset ~ : SB_False
        )
        CompNameDbg : State {
            = "SS _INV"
            Debug.LogLevel = "Dbg"
        }
        CompsIter_Done_Dbg : State (
            _@ <  {
                = "SB _INV"
                Debug.LogLevel = "Dbg"
            }
            Inp ~ CompsIter.OutpDone
        )
        EdgesDbg : State (
            _@ <  {
                = "VPDU _INV"
                Debug.LogLevel = "Dbg"
            }
            Inp ~ MagAdp.Edges
        )
        CompNameDbg.Inp ~ CompName : TrAtVar (
            Inp ~ MagAdp.CompsNames
            Index ~ CompsIter.Outp
        )
        # "Model edges Iterator"
        EdgesIter : DesUtils.IdxItr (
            InpCnt ~ : TrSizeVar (
                Inp ~ MagAdp.Edges
            )
            InpReset ~ : SB_False
        )
        # "CRP creation"
        CpAddCrp.Name ~ CompName
        CpAddCrp.Parent ~ : Const {
            = "SS VertCrp"
        }
        CpAddCrp.Enable ~ CmpCn_Ge : TrCmpVar (
            Inp ~ MagAdp.CompsCount
            Inp2 ~ : SI_1
        )
        CpAddCrp.Pos ~ : SI_1
        # ">>> Edge CRPs creator"
        # "Creates edges and connects them to proper VertCrps"
        EdgeData : TrAtgVar (
            Inp ~ MagAdp.Edges
            Index ~ EdgesIter.Outp
        )
        EdgeData_Dbg : State (
            _@ <  {
                = "PDU _INV"
                Debug.LogLevel = "Dbg"
            }
            Inp ~ EdgeData
        )
        EdgeCrpName : TrApndVar (
            Inp1 ~ : Const {
                = "SS Edge_"
            }
            Inp2 ~ : TrTostrVar (
                Inp ~ EdgesIter.Outp
            )
        )
        CreateEdge : ASdcComp (
            _@ < Debug.LogLevel = "Dbg"
            Enable ~ CompsIter.OutpDone
            Name ~ EdgeCrpName
            Parent ~ : Const {
                = "SS EdgeCrp"
            }
        )
        ConnectEdgeP : ASdcConn (
            _@ < Debug.LogLevel = "Dbg"
            Enable ~ CreateEdge.Outp
            V1 ~ : TrApndVar (
                Inp1 ~ : TrTostrVar (
                    Inp ~ : TrAtgVar (
                        Inp ~ EdgeData
                        Index ~ : SI_0
                    )
                )
                Inp2 ~ : Const {
                    = "SS .EdgeCrpCp"
                }
            )
            V2 ~ : TrApndVar (
                Inp1 ~ EdgeCrpName
                Inp2 ~ : Const {
                    = "SS .VertCrpPCp"
                }
            )
        )
        ConnectEdgeQ : ASdcConn (
            _@ < Debug.LogLevel = "Dbg"
            Enable ~ CreateEdge.Outp
            V1 ~ : TrApndVar (
                Inp1 ~ : TrTostrVar (
                    Inp ~ : TrAtgVar (
                        Inp ~ EdgeData
                        Index ~ : SI_1
                    )
                )
                Inp2 ~ : Const {
                    = "SS .EdgeCrpCp"
                }
            )
            V2 ~ : TrApndVar (
                Inp1 ~ EdgeCrpName
                Inp2 ~ : Const {
                    = "SS .VertCrpQCp"
                }
            )
        )
        EdgesIter.InpDone ~ : TrAndVar (
            Inp ~ ConnectEdgeP.Outp
            Inp ~ ConnectEdgeQ.Outp
        )
        # "<<< Edge CRPs creator"
        # "Vert CRP context"
        VertCrpCtx : DesCtxSpl {
            # "CRP parameters: positioning etc"
            CrpPars : ExtdStateInp
        }
        {
            # ">>> Controller of CRPs ordering"
            # "CrpPars Iterator"
            CrpParsIter : DesUtils.InpItr (
                InpM ~ VertCrpCtx.CrpPars.Int
                # "InpDone --> "
                ChgDet : DesUtils.ChgDetector (
                    Inp ~ VertCrpCtx.CrpPars.Int
                )
                InpReset ~ ChgDet.Outp
            )
            CrpParsIterDone_Dbg : State (
                _@ <  {
                    Debug.LogLevel = "Dbg"
                    = "SB _INV"
                }
                Inp ~ CrpParsIter.OutpDone
            )
            # "Selected CrpPars"
            SelectedCrpPars : TrInpSel (
                Inp ~ VertCrpCtx.CrpPars.Int
                Idx ~ CrpParsIter.Outp
            )
            SelectedCrpPars_Dbg : State (
                _@ <  {
                    Debug.LogLevel = "Dbg"
                    = "TPL,SS:name,SI:colpos,SI:pmrcolpos none -1 -1"
                }
                Inp ~ SelectedCrpPars
            )
            CrpColPos : TrTupleSel (
                Inp ~ SelectedCrpPars
                Comp ~ : Const {
                    = "SS colpos"
                }
            )
            CrpPmrColPos : TrTupleSel (
                Inp ~ SelectedCrpPars
                Comp ~ : Const {
                    = "SS pmrcolpos"
                }
            )
            CrpName : TrTupleSel (
                Inp ~ SelectedCrpPars
                Comp ~ : Const {
                    = "SS name"
                }
            )
            CrpName_Dbg : State (
                _@ <  {
                    Debug.LogLevel = "Dbg"
                    = "SS _INV"
                }
                Inp ~ CrpName
            )
            # "New column creation"
            ColumnSlotParent < = "SS ContainerMod.ColumnLayoutSlot"
            SColumnsCount : State (
                _@ <  {
                    Debug.LogLevel = "Dbg"
                    = "SI"
                }
                Inp ~ ColumnsCount
            )
            SameColAsPair_Eq : TrCmpVar (
                Inp ~ CrpColPos
                Inp2 ~ CrpPmrColPos
            )
            SameColAsPair_Dbg : State (
                _@ <  {
                    Debug.LogLevel = "Dbg"
                    = "SB _INV"
                }
                Inp ~ SameColAsPair_Eq
            )
            NewColNeeded_Ge : TrCmpVar (
                Inp ~ CrpColPos
                Inp2 ~ LastColPos : TrAddVar (
                    Inp ~ ColumnsCount
                    InpN ~ : SI_1
                )
            )
            NewColNeeded_Dbg : State (
                _@ <  {
                    Debug.LogLevel = "Dbg"
                    = "SB _INV"
                }
                Inp ~ NewColNeeded_Ge
            )
            CpAddColumn : ContainerMod.ClAddColumnSm (
                Enable ~ : TrAndVar (
                    Inp ~ SameColAsPair_Eq
                    Inp ~ NewColNeeded_Ge
                )
                Name ~ NewColName : TrApndVar (
                    Inp1 ~ : Const {
                        = "SS Column_"
                    }
                    Inp2 ~ : TrTostrVar (
                        # "Using delayed col count. TODO look at better solution"
                        Inp ~ SColumnsCount
                    )
                )
            )
            CpAddColumn ~ IoAddColumn
            NewColNameDelayed : State (
                # "TODO Workaround to form correct outp. Redesign"
                _@ <  {
                    Debug.LogLevel = "Dbg"
                    = "SS"
                }
                Inp ~ NewColName
            )
            SdcCreateVtSlot : ASdcComp (
                # "Creating vtunnel slot"
                _@ < Debug.LogLevel = "Dbg"
                Enable ~ CpAddColumn.Done
                Name ~ SVtnlSlotName : TrApndVar (
                    Inp1 ~ NewColNameDelayed
                    Inp2 ~ : Const {
                        = "SS _vt"
                    }
                )
                Parent ~ : Const {
                    = "SS VertDrpVtSlot"
                }
            )
            SdcInsertVtSlot : ASdcInsert2 (
                # "Insert vtunnel slot"
                _@ < Debug.LogLevel = "Dbg"
                Enable ~ SdcCreateVtSlot.Outp
                Name ~ SVtnlSlotName
                Pname ~ KSEnd
                Prev ~ KS_Prev
                Next ~ KS_Next
            )
            _ <  {
                # "Avoid using tunnel as separate widget. Using monolith approatch atm."
                SdcCreateVt : ASdcComp (
                    # "Creating vtunnel"
                    _@ < Debug.LogLevel = "Dbg"
                    Enable ~ CpAddColumn.Done
                    Name ~ SVtnlName : Const {
                        = "SS VTnl"
                    }
                    Parent ~ : Const {
                        = "SS VertDrpVt"
                    }
                )
                SdcConnVt : ASdcConn (
                    # "Connecting vtunnel to slot"
                    _@ < Debug.LogLevel = "Dbg"
                    Enable ~ SdcCreateVt.Outp
                    Enable ~ SdcInsertVtSlot.Outp
                    V1 ~ : TrApndVar (
                        Inp1 ~ SVtnlName
                        Inp2 ~ : Const {
                            = "SS .Cp"
                        }
                    )
                    V2 ~ : TrApndVar (
                        Inp1 ~ SVtnlSlotName
                        Inp2 ~ : Const {
                            = "SS .SCp"
                        }
                    )
                )
            }
            # "Reposition CRP"
            _ <  {
                SdcExtrSlot < Debug.LogLevel = "Dbg"
                CpRmCrp : ContainerMod.DcRmWdgSc (
                    Enable ~ SameColAsPair_Eq
                    Enable ~ : TrNegVar (
                        Inp ~ NewColNeeded_Ge
                    )
                    Name ~ CrpName
                )
                CpRmCrp ~ IoRmWidg
            }
            CpReposCrp : ContainerMod.ClReposWdgSm (
                Enable ~ SameColAsPair_Eq
                Enable ~ : TrNegVar (
                    Inp ~ NewColNeeded_Ge
                )
                Name ~ CrpName
                ColPos ~ ColumnsCount
            )
            CpReposCrp ~ IoReposWdg
            # "Completion of iteration"
            _ <  {
                CrpParsIter.InpDone ~ : TrOrVar {
                    Inp ~ : TrNegVar (
                        Inp ~ SameColAsPair_Eq
                    )
                    Inp ~ CpReposCrp.Done
                }
            }
            CrpParsIter.InpDone ~ : TrAndVar (
                Inp ~ : TrNegVar (
                    Inp ~ SameColAsPair_Eq
                )
                Inp ~ : TrIsValid (
                    Inp ~ CrpColPos
                )
            )
            CpReposCrpDone_Dbg : State (
                _@ <  {
                    Debug.LogLevel = "Dbg"
                    = "SB _INV"
                }
                Inp ~ CpReposCrp.Done
            )
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
        ModelMnt : AMntp {
            # "TODO FIXME Not setting EnvVar here casuses wrong navigation in modnav"
            EnvVar : Content {
                = "Model"
            }
        }
        ModelMntLink : Link {
            Outp : CpStateMnodeOutp
        }
        ModelMntLink ~ ModelMnt
        CtrlCp.NavCtrl.DrpCp.InpModelMntp ~ ModelMntLink.Outp
        # " Cursor"
        Cursor : State {
            Debug.LogLevel = "Dbg"
            = "URI"
        }
        DbgCmdUp : State (
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "SB false"
            }
            Inp ~ CtrlCp.NavCtrl.CmdUp
        )
        # "NodeSelected Pulse"
        Nsp : DesUtils.DPulse (
            InpD ~ CtrlCp.NavCtrl.NodeSelected
            InpE ~ : State {
                = "URI _INV"
            }
        )
        Nsp.Delay < = "URI"
        Nsp.Delay < Debug.LogLevel = "Dbg"
        NspDbg : State {
            Debug.LogLevel = "Dbg"
            = "URI _INV"
        }
        NspDbg.Inp ~ Nsp.Outp
        Cursor.Inp ~ : TrSwitchBool (
            _@ < Debug.LogLevel = "Dbg"
            Sel ~ CtrlCp.NavCtrl.CmdUp
            Inp1 ~ Tr1Dbg : TrSwitchBool (
                _@ < Debug.LogLevel = "Dbg"
                Sel ~ : TrIsValid (
                    Inp ~ Cursor
                )
                Inp1 ~ Const_SMdlRoot : State {
                    = "URI ''"
                }
                Inp2 ~ : TrSvldVar (
                    Inp1 ~ : TrApndVar (
                        Inp1 ~ Cursor
                        Inp2 ~ Nsp.Outp
                    )
                    Inp2 ~ Cursor
                )
            )
            Inp2 ~ CursorOwner : TrHeadtnVar (
                _@ < Debug.LogLevel = "Dbg"
                Inp ~ Cursor
                Tlen ~ : SI_1
            )
        )
        # "For debugging only"
        DbgCursorOwner : State (
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "URI"
            }
            Inp ~ CursorOwner
        )
        # " DRP creation"
        CpAddDrp : ContainerMod.DcAddWdgSc
        CpAddDrp ~ CtrlCp.NavCtrl.MutAddWidget
        CpAddDrp.Name ~ : Const {
            = "SS Drp"
        }
        CpAddDrp.Parent ~ : Const {
            = "SS AvrMdl2.NodeDrp"
        }
        DrpAddedPulse : DesUtils.BChange (
            SInp ~ CpAddDrp.Added
        )
        # " Model URI"
        CtrlCp.NavCtrl.DrpCp.InpModelUri ~ MdlUri : TrSwitchBool (
            _@ < Debug.LogLevel = "Dbg"
            # " Model URI is set only after DRP has been created"
            Sel ~ DrpAddedPulse.Outp
            Inp1 ~ : State {
                = "URI _INV"
            }
            Inp2 ~ Cursor
        )
        MdlUriDbg : State (
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "URI _INV"
            }
            Inp ~ MdlUri
        )
        SModelUri : State (
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "URI _INV"
            }
            Inp ~ ModelUri : TrSvldVar (
                Inp1 ~ MdlUri
                Inp2 ~ SModelUri
            )
        )
        # " VRP dirty indication"
        VrpDirty : State {
            Debug.LogLevel = "Dbg"
            = "SB false"
        }
        VrpDirty.Inp ~ : TrAndVar (
            Inp ~ U_Neq : TrCmpVar (
                Inp ~ ModelUri
                Inp2 ~ Cursor
            )
            Inp ~ CpAddDrp.Added
            Inp ~ : TrIsValid (
                Inp ~ ModelUri
            )
        )
        # " DRP removal on VRP dirty"
        CpRmDrp : ContainerMod.DcRmWdgSc
        CpRmDrp ~ CtrlCp.NavCtrl.MutRmWidget
        CpRmDrp.Name ~ : Const {
            = "SS Drp"
        }
        CpRmDrp.Enable ~ VrpDirty
        Dbg_DrpRemoved : State (
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "SB _INV"
            }
            Inp ~ CpRmDrp.Done
        )
        DrpRemovedPulse : DesUtils.BChange (
            SInp ~ CpRmDrp.Done
        )
        SDrpCreated_Dbg : State (
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "SB false"
            }
            Inp ~ CpAddDrp.Added
        )
        DrpAddedTg : DesUtils.RSTg (
            InpS ~ DrpAddedPulse.Outp
            InpR ~ DrpRemovedPulse.Outp
        )
        CpAddDrp.Enable ~ : TrNegVar (
            Inp ~ DrpAddedTg.Outp
        )
    }
}
