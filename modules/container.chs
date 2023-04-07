ContainerMod : Elem {
    # "TODO To have Start and End as specific slots with CPs"
    About : Content {
        = "FAP3 widget visualization system"
    }
    + FvWidgets
    + DesUtils
    SlotCp : Socket {
        InpAlcX : CpStateInp
        InpAlcY : CpStateInp
        InpAlcW : CpStateInp
        InpAlcH : CpStateInp
        OutAlcX : CpStateOutp
        OutAlcY : CpStateOutp
        OutAlcW : CpStateOutp
        OutAlcH : CpStateOutp
        RqsW : CpStateOutp
        RqsH : CpStateOutp
        LbpUri : CpStateOutp
    }
    SlotLinNextCp : Socket {
        AlcX : CpStateOutp
        AlcY : CpStateOutp
        AlcW : CpStateOutp
        AlcH : CpStateOutp
        CntRqsW : CpStateOutp
        CntRqsH : CpStateOutp
        XPadding : CpStateOutp
        YPadding : CpStateOutp
        LbpComp : CpStateOutp
    }
    SlotLinPrevCp : Socket {
        AlcX : CpStateInp
        AlcY : CpStateInp
        AlcW : CpStateInp
        AlcH : CpStateInp
        CntRqsW : CpStateInp
        CntRqsH : CpStateInp
        XPadding : CpStateInp
        YPadding : CpStateInp
        LbpComp : CpStateInp
    }
    FSlot : Syst {
        SCp : SlotCp
    }
    LinStart : Syst {
        # "Lin layout slots list start"
        Prev : SlotLinPrevCp
    }
    LinEnd : Syst {
        # "Lin layout slots list end"
        Next : SlotLinNextCp
    }
    # " Linear layout slot"
    FSlotLin : FSlot {
        Prev : SlotLinPrevCp
        Next : SlotLinNextCp
        Prev.XPadding ~ Next.XPadding
        Prev.YPadding ~ Next.YPadding
        Prev.LbpComp ~ : TrSvldVar @  {
            Inp1 ~ Next.LbpComp
            Inp2 ~ SCp.LbpUri
        }
    }
    FVLayoutSlot : FSlotLin {
        # " Vertical layout slot"
        Add1 : TrAddVar @  {
            Inp ~ Next.AlcY
            Inp ~ Next.YPadding
            Inp ~ Next.AlcH
        }
        Max1 : TrMaxVar @  {
            Inp ~ Next.CntRqsW
            Inp ~ SCp.RqsW
        }
        Prev @  {
            AlcX ~ SCp.OutAlcX
            AlcY ~ SCp.OutAlcY
            AlcW ~ SCp.OutAlcW
            AlcH ~ SCp.OutAlcH
            CntRqsW ~ Max1
        }
        SCp @  {
            InpAlcW ~ SCp.RqsW
            InpAlcH ~ SCp.RqsH
            InpAlcX ~ Next.AlcX
            InpAlcY ~ Add1
        }
    }
    FHLayoutSlot : FSlotLin {
        # " Horisontal layout slot"
        Prev.AlcX ~ SCp.OutAlcX
        Prev.AlcY ~ SCp.OutAlcY
        Prev.AlcW ~ SCp.OutAlcW
        Prev.AlcH ~ SCp.OutAlcH
        SCp.InpAlcW ~ SCp.RqsW
        SCp.InpAlcH ~ SCp.RqsH
        SCp.InpAlcY ~ Next.AlcY
        Add1 : TrAddVar
        SCp.InpAlcX ~ Add1
        Add1.Inp ~ Next.AlcX
        Add1.Inp ~ Next.XPadding
        Add1.Inp ~ Next.AlcW
        Max1 : TrMaxVar
        Prev.CntRqsH ~ Max1
        Max1.Inp ~ Next.CntRqsH
        Max1.Inp ~ SCp.RqsH
    }
    AlignmentSlot : FSlotLin {
        # " Horisontal layout slot"
        Prev.AlcX ~ SCp.OutAlcX
        Prev.AlcY ~ SCp.OutAlcY
        Prev.AlcW ~ SCp.OutAlcW
        Prev.AlcH ~ SCp.OutAlcH
        SCp.InpAlcW ~ SCp.RqsW
        SCp.InpAlcH ~ SCp.RqsH
        AddX : TrAddVar
        SCp.InpAlcX ~ AddX
        AddX.Inp ~ Next.AlcX
        AddX.Inp ~ Next.XPadding
        AddY : TrAddVar
        SCp.InpAlcY ~ AddY
        AddY.Inp ~ Next.AlcY
        AddY.Inp ~ Next.YPadding
        AddCW : TrAddVar
        Prev.CntRqsW ~ AddCW
        AddCW.Inp ~ SCp.RqsW
        AddCW.Inp ~ Next.XPadding
        AddCH : TrAddVar
        Prev.CntRqsH ~ AddCH
        AddCH.Inp ~ SCp.RqsH
        AddCH.Inp ~ Next.YPadding
    }
    # " DES controlled container"
    DcAddWdgS : Socket {
        Enable : CpStateOutp
        Name : CpStateOutp
        Parent : CpStateOutp
        Mut : CpStateOutp
        Pos : CpStateOutp
        Added : CpStateInp
        # "TODO not used, remove"
        AddedName : CpStateInp
    }
    DcAddWdgSc : Socket {
        Enable : CpStateInp
        Name : CpStateInp
        Parent : CpStateInp
        Mut : CpStateInp
        Pos : CpStateInp
        Added : CpStateOutp
        AddedName : CpStateOutp
    }
    DcRmWdgS : Socket {
        Enable : CpStateOutp
        Name : CpStateOutp
        Done : CpStateInp
    }
    DcRmWdgSc : Socket {
        Enable : CpStateInp
        Name : CpStateInp
        Done : CpStateOutp
    }
    DContainer : FvWidgets.FWidgetBase {
        Controllable = "y"
        CntAgent : AVDContainer
        # " Internal connections"
        CntAgent.InpFont ~ Font
        CntAgent.InpText ~ SText
        # " Padding value"
        XPadding : State {
            = "SI 1"
        }
        YPadding : State {
            = "SI 1"
        }
        IoAddWidg : DcAddWdgS
        IoRmWidg : DcRmWdgS
        # " Adding widget"
        CreateWdg : ASdcComp @  {
            _@ < Debug.LogLevel = "Err"
            Enable ~ IoAddWidg.Enable
            Name ~ IoAddWidg.Name
            Parent ~ IoAddWidg.Parent
        }
        CreateWdg_Dbg : State @  {
            _@ <  {
                = "SB false"
                Debug.LogLevel = "Dbg"
            }
            Inp ~ CreateWdg.Outp
        }
        : ASdcMut @  {
            Enable ~ CreateWdg.Outp
            Target ~ IoAddWidg.Name
            Mut ~ IoAddWidg.Mut
        }
        AddSlot : ASdcComp @  {
            _@ < Debug.LogLevel = "Err"
            Enable ~ IoAddWidg.Enable
            Name ~ AdSlotName : TrApndVar @  {
                Inp1 ~ SlotNamePref : Const {
                    = "SS Slot_"
                }
                Inp2 ~ IoAddWidg.Name
            }
            Parent ~ SlotParent : State
        }
        AddSlot_Dbg : State @  {
            _@ <  {
                = "SB false"
                Debug.LogLevel = "Dbg"
            }
            Inp ~ AddSlot.Outp
        }
        SdcConnWdg : ASdcConn @  {
            _@ < Debug.LogLevel = "Err"
            Enable ~ IoAddWidg.Enable
            Enable ~ CreateWdg.Outp
            Enable ~ AddSlot.Outp
            V1 ~ : TrApndVar @  {
                Inp1 ~ IoAddWidg.Name
                Inp2 ~ : Const {
                    = "SS .Cp"
                }
            }
            V2 ~ : TrApndVar @  {
                Inp1 ~ AdSlotName
                Inp2 ~ : Const {
                    = "SS .SCp"
                }
            }
        }
        ConnWdg_Dbg : State @  {
            _@ <  {
                = "SB false"
                Debug.LogLevel = "Dbg"
            }
            Inp ~ SdcConnWdg.Outp
        }
        # " Removing widget"
        SdcExtrSlot : ASdcExtract @  {
            _@ < Debug.LogLevel = "Err"
            Enable ~ IoRmWidg.Enable
            Name ~ ExtrSlotName : TrApndVar @  {
                Inp1 ~ SlotNamePref
                Inp2 ~ IoRmWidg.Name
            }
            Prev ~ : Const {
                = "SS Prev"
            }
            Next ~ : Const {
                = "SS Next"
            }
        }
        RmWdg : ASdcRm @  {
            _@ < Debug.LogLevel = "Err"
            Enable ~ IoRmWidg.Enable
            Enable ~ SdcExtrSlot.Outp
            Name ~ IoRmWidg.Name
        }
        RmSlot : ASdcRm @  {
            _@ < Debug.LogLevel = "Err"
            Enable ~ IoRmWidg.Enable
            Enable ~ SdcExtrSlot.Outp
            Name ~ ExtrSlotName
        }
        IoRmWidg.Done ~ : TrAndVar @  {
            Inp ~ RmWdg.Outp
            Inp ~ RmSlot.Outp
            Inp ~ SdcExtrSlot.Outp
        }
    }
    DLinearLayout : DContainer {
        Start : LinStart
        Start.Prev.XPadding ~ XPadding
        Start.Prev.YPadding ~ YPadding
        Start.Prev.LbpComp ~ : State {
            = "URI _INV"
        }
        End : LinEnd
        Cp.LbpUri ~ TLbpUri : TrApndVar @  {
            Inp1 ~ CntAgent.OutpLbpUri
            Inp2 ~ : TrSvldVar @  {
                Inp1 ~ End.Next.LbpComp
                Inp2 ~ : State {
                    = "URI"
                }
            }
        }
        SLbpComp_Dbg : State @  {
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "URI"
            }
            Inp ~ TLbpUri
        }
        Start.Prev ~ End.Next
        # "Inserting new widget to the end"
        SdcInsert : ASdcInsert2 @  {
            _@ < Debug.LogLevel = "Err"
            Enable ~ IoAddWidg.Enable
            Enable ~ CreateWdg.Outp
            Enable ~ AddSlot.Outp
            Name ~ AdSlotName
            Pname ~ : Const {
                = "SS End"
            }
            Prev ~ : Const {
                = "SS Prev"
            }
            Next ~ : Const {
                = "SS Next"
            }
        }
        IoAddWidg.Added ~ SdcInsert.Outp
    }
    DAlignment : DLinearLayout {
        RqsW.Inp ~ End.Next.CntRqsW
        RqsH.Inp ~ End.Next.CntRqsH
        SlotParent < = "SS AlignmentSlot"
    }
    DVLayout : DLinearLayout {
        RqsW.Inp ~ : TrAddVar @  {
            Inp ~ End.Next.CntRqsW
            Inp ~ : TrMplVar @  {
                Inp ~ End.Next.XPadding
                Inp ~ : State {
                    = "SI 2"
                }
            }
        }
        RqsH.Inp ~ Add2 : TrAddVar @  {
            Inp ~ End.Next.AlcY
            Inp ~ End.Next.AlcH
            Inp ~ End.Next.YPadding
        }
        SlotParent < = "SS FVLayoutSlot"
    }
    DHLayout : DLinearLayout {
        RqsW.Inp ~ : TrAddVar @  {
            Inp ~ End.Next.AlcX
            Inp ~ End.Next.AlcW
            Inp ~ End.Next.XPadding
        }
        RqsH.Inp ~ : TrAddVar @  {
            Inp ~ End.Next.CntRqsH
            Inp ~ : TrMplVar @  {
                Inp ~ End.Next.YPadding
                Inp ~ : State {
                    = "SI 2"
                }
            }
        }
        SlotParent < = "SS FHLayoutSlot"
    }
    # ">>> Column layout. Set of the colums of the widgets."
    ColumnsSlotPrevCp : SlotLinPrevCp {
        Pos : CpStateInp
    }
    ColumnsSlotNextCp : SlotLinNextCp {
        Pos : CpStateOutp
    }
    ColumnsStart : Syst {
        # "Column layout columns start slot"
        Prev : ColumnsSlotPrevCp
        Prev.Pos ~ : SI_0
    }
    ColumnsEnd : Syst {
        # "Column layout columns end slot"
        Next : ColumnsSlotNextCp
    }
    ColumnStart : Syst {
        # "Column layout column slots list start"
        Prev : SlotLinPrevCp {
            ItemPos : CpStateInp
            ColumnPos : CpStateInp
        }
    }
    ColumnEnd : Syst {
        # "Column layout column slots list end"
        Next : SlotLinNextCp {
            ItemPos : CpStateOutp
            ColumnPos : CpStateOutp
        }
    }
    ColumnLayoutSlot : Des {
        # "Column layout slot"
        Prev : ColumnsSlotPrevCp
        Next : ColumnsSlotNextCp
        Start : ColumnStart
        End : ColumnEnd
        Start.Prev ~ End.Next
        Start.Prev.AlcX ~ Add1 : TrAddVar @  {
            Inp ~ Next.AlcX
            Inp ~ Next.CntRqsW
            Inp ~ Next.XPadding
        }
        Start.Prev.YPadding ~ Next.YPadding
        Prev.CntRqsW ~ End.Next.CntRqsW
        Prev.CntRqsH ~ Add2 : TrAddVar @  {
            Inp ~ End.Next.AlcY
            Inp ~ End.Next.AlcH
            Inp ~ End.Next.YPadding
        }
        Prev.AlcX ~ Add1
        Prev.XPadding ~ Next.XPadding
        Prev.YPadding ~ Next.YPadding
        Prev.Pos ~ : TrAddVar @  {
            Inp ~ Next.Pos
            Inp ~ : SI_1
        }
        Start.Prev.ItemPos ~ : SI_0
        Start.Prev.ColumnPos ~ Next.Pos
        Pos_Dbg : State @  {
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "SI _INV"
            }
            Inp ~ Next.Pos
        }
        ItemsCount_Dbg : State @  {
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "SI _INV"
            }
            Inp ~ End.Next.ItemPos
        }
    }
    ColumnItemSlot : FVLayoutSlot {
        # "Column item slot"
        # "Extend chain CPs for positions io"
        Prev <  {
            ItemPos : CpStateInp
            ColumnPos : CpStateInp
        }
        Next <  {
            ItemPos : CpStateOutp
            ColumnPos : CpStateOutp
        }
        Prev.ItemPos ~ : TrAddVar @  {
            Inp ~ Next.ItemPos
            Inp ~ : SI_1
        }
        Prev.ColumnPos ~ Next.ColumnPos
    }
    ClAddColumnS : Socket {
        Enable : CpStateOutp
        Name : CpStateOutp
        # " Position: bool, false - start, true - end. Not used ATM"
        # "Pos : CpStateOutp"
        Done : CpStateInp
    }
    ClAddColumnSm : Socket {
        Enable : CpStateInp
        Name : CpStateInp
        # "Pos : CpStateInp"
        Done : CpStateOutp
    }
    ClReposWdgS : Socket {
        Enable : CpStateOutp
        Name : CpStateOutp
        # "New column pos"
        ColPos : CpStateOutp
        Done : CpStateInp
    }
    ClReposWdgSm : Socket {
        Enable : CpStateInp
        Name : CpStateInp
        # "New column pos"
        ColPos : CpStateInp
        Done : CpStateOutp
    }
    ColumnsLayout : DContainer {
        # ">>> Columns layout"
        # "IO"
        # "   Adding column to the left"
        IoAddColumn : ClAddColumnS
        # "   Repositioning widget"
        IoReposWdg : ClReposWdgS
        # "Constants"
        KS_Prev : Const {
            = "SS Prev"
        }
        KS_Next : Const {
            = "SS Next"
        }
        KSStart : Const {
            = "SS Start"
        }
        KSEnd : Const {
            = "SS End"
        }
        KU_Start : Const {
            = "URI Start"
        }
        KU_End : Const {
            = "URI End"
        }
        KU_Next : Const {
            = "URI Next"
        }
        KU_Prev : Const {
            = "URI Prev"
        }
        # "Paremeters"
        ColumnSlotParent : Const {
            = "SS ColumnLayoutSlot"
        }
        Start : ColumnsStart
        Start.Prev.XPadding ~ XPadding
        Start.Prev.YPadding ~ YPadding
        Start.Prev.AlcX ~ XPadding
        Start.Prev.AlcY ~ YPadding
        Start.Prev.LbpComp ~ : State {
            = "URI _INV"
        }
        End : ColumnsEnd
        ColumnsCount : ExtdStateOutp @  {
            Int ~ End.Next.Pos
        }
        SlotParent < = "SS ColumnItemSlot"
        Cp.LbpUri ~ TLbpUri : TrApndVar @  {
            Inp1 ~ CntAgent.OutpLbpUri
            Inp2 ~ : TrSvldVar @  {
                Inp1 ~ End.Next.LbpComp
                Inp2 ~ : State {
                    = "URI"
                }
            }
        }
        SLbpComp_Dbg : State @  {
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "URI"
            }
            Inp ~ TLbpUri
        }
        Start.Prev ~ End.Next
        # "Pair of columns end"
        EndPair : SdoPair @  {
            _@ < Debug.LogLevel = "Dbg"
            Vp ~ : Const {
                = "SS End.Next"
            }
        }
        Dbg_EndPair : State @  {
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "URI _INV"
            }
            Inp ~ EndPair
        }
        FirstColumn : SdoCompOwner @  {
            Comp ~ : SdoTcPair @  {
                Targ ~ KU_Start
                TargComp ~ KU_Prev
            }
        }
        FirstColumn_Dbg : State @  {
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "URI _INV"
            }
            Inp ~ FirstColumn
        }
        Cmp_Neq_1 : TrCmpVar @  {
            Inp ~ EndPair
            Inp2 ~ : Const {
                = "URI Start.Prev"
            }
        }
        Dbg_Neq_1 : State @  {
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "SB _INV"
            }
            Inp ~ Cmp_Neq_1
        }
        LastColumn : SdoCompOwner @  {
            _@ < Debug.LogLevel = "Err"
            Comp ~ EndPair
        }
        Dbg_LastColumn : State @  {
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "URI _INV"
            }
            Inp ~ LastColumn
        }
        _ <  {
            LastColumnEnd : SdoCompComp @  {
                _@ < Debug.LogLevel = "Dbg"
                Comp ~ LastColumn
                CompComp ~ : State {
                    = "URI End"
                }
            }
        }
        LastColumnEnd : TrApndVar @  {
            Inp1 ~ LastColumn
            Inp2 ~ KU_End
        }
        Dbg_LastColumnEnd : State @  {
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "URI _INV"
            }
            Inp ~ LastColumnEnd
        }
        ColToInsertWdg : DesUtils.ListItemByPos @  {
            InpPos ~ IoAddWidg.Pos
            InpMagLink ~ _$
        }
        _ <  {
            ColToInsertWdgEnd : SdoCompComp @  {
                _@ < Debug.LogLevel = "Dbg"
                Comp ~ ColToInsertWdg.OutpNode
                CompComp ~ KU_End
            }
        }
        ColToInsertWdgEnd : TrApndVar @  {
            Inp1 ~ ColToInsertWdg.OutpNode
            Inp2 ~ KU_End
        }
        ColToInsertWdgEnd_Dbg : State @  {
            _@ <  {
                Debug.LogLevel = "Dbg"
                = "URI _INV"
            }
            Inp ~ ColToInsertWdgEnd
        }
        # "Inserting new widget to the end of given column"
        SdcInsert : ASdcInsert2 @  {
            _@ < Debug.LogLevel = "Err"
            Enable ~ IoAddWidg.Enable
            Enable ~ CreateWdg.Outp
            Enable ~ AddSlot.Outp
            # "Name ~ AddSlot.OutpName;"
            Name ~ AdSlotName
            Pname ~ : TrTostrVar @  {
                Inp ~ ColToInsertWdgEnd
                # "Inp ~ LastColumnEnd"
            }
            Prev ~ KS_Prev
            Next ~ KS_Next
        }
        IoAddWidg.Added ~ SdcInsert.Outp
        # ">>> Adding column"
        # "  Creating column slot"
        CreateColSlot : ASdcComp @  {
            _@ < Debug.LogLevel = "Dbg"
            Enable ~ IoAddColumn.Enable
            Name ~ IoAddColumn.Name
            Parent ~ ColumnSlotParent
        }
        CreateColSlot_Dbg : State @  {
            _@ <  {
                = "SB false"
                Debug.LogLevel = "Dbg"
            }
            Inp ~ CreateColSlot.Outp
        }
        # "  Inserting column slot"
        SdcInsertColE : ASdcInsert2 @  {
            _@ < Debug.LogLevel = "Dbg"
            Enable ~ IoAddColumn.Enable
            Enable ~ CreateColSlot.Outp
            # "Enable ~ IoAddColumn.Pos"
            Name ~ IoAddColumn.Name
            Pname ~ KSEnd
            Prev ~ KS_Prev
            Next ~ KS_Next
        }
        IoAddColumn.Done ~ SdcInsertColE.Outp
        # "<<< Adding column"
        {
            # ">>> Reposition widget"
            # "   Extract"
            SdcReposExtrSlot : ASdcExtract @  {
                _@ < Debug.LogLevel = "Dbg"
                Enable ~ IoReposWdg.Enable
                Name ~ ReposSlotName : TrApndVar @  {
                    Inp1 ~ SlotNamePref
                    Inp2 ~ IoReposWdg.Name
                }
                Prev ~ KS_Prev
                Next ~ KS_Next
            }
            # "   Insert"
            _ <  {
                ColToReposWdg : DesUtils.ListItemByPos @  {
                    InpPos ~ IoReposWdg.ColPos
                    InpMagLink ~ _$
                }
            }
            ColToReposWdg : TrApndVar @  {
                Inp1 ~ : Const {
                    = "SS Column_"
                }
                Inp2 ~ : TrTostrVar @  {
                    Inp ~ : TrAddVar @  {
                        Inp ~ IoReposWdg.ColPos
                        InpN ~ : SI_1
                    }
                }
            }
            _ <  {
                ColToReposWdgEnd : SdoCompComp @  {
                    Comp ~ : TrToUriVar @  {
                        Inp ~ ColToReposWdg
                    }
                    CompComp ~ KU_End
                }
            }
            ColToReposWdgEnd : TrApndVar @  {
                Inp1 ~ : TrToUriVar @  {
                    Inp ~ ColToReposWdg
                }
                Inp2 ~ KU_End
            }
            ColToReposWdgEnd_Dbg : State @  {
                _@ <  {
                    = "URL _INV"
                    Debug.LogLevel = "Dbg"
                }
                Inp ~ ColToReposWdgEnd
            }
            SdcReposInsertSlot : ASdcInsert2 @  {
                _@ < Debug.LogLevel = "Dbg"
                # "Enable ~ IoReposWdg.Enable"
                Enable ~ SdcReposExtrSlot.Outp
                Name ~ ReposSlotName
                Pname ~ : TrTostrVar @  {
                    Inp ~ ColToReposWdgEnd
                }
                Prev ~ KS_Prev
                Next ~ KS_Next
            }
            IoReposWdg.Done ~ SdcReposInsertSlot.Outp
            # "<<< Reposition widget"
        }
        # "<<< Columns layout"
    }
}
