ContainerMod : Elem
{
    # "TODO To have Start and End as specific slots with CPs";
    About : Content { = "FAP3 widget visualization system"; }
    Modules : Node
    {
        + FvWidgets;
        + DesUtils;
    }
    SlotCp : Socket
    {
        InpAlcX : CpStateInp;
        InpAlcY : CpStateInp;
        InpAlcW : CpStateInp;
        InpAlcH : CpStateInp;
        OutAlcX : CpStateOutp;
        OutAlcY : CpStateOutp;
        OutAlcW : CpStateOutp;
        OutAlcH : CpStateOutp;
        RqsW : CpStateOutp;
        RqsH : CpStateOutp;
        LbpUri : CpStateOutp;
    }
    SlotLinNextCp : Socket
    {
        AlcX : CpStateOutp;
        AlcY : CpStateOutp;
        AlcW : CpStateOutp;
        AlcH : CpStateOutp;
        CntRqsW : CpStateOutp;
        CntRqsH : CpStateOutp;
        XPadding : CpStateOutp;
        YPadding : CpStateOutp;
        LbpComp : CpStateOutp;
    }
    SlotLinPrevCp : Socket
    {
        AlcX : CpStateInp;
        AlcY : CpStateInp;
        AlcW : CpStateInp;
        AlcH : CpStateInp;
        CntRqsW : CpStateInp;
        CntRqsH : CpStateInp;
        XPadding : CpStateInp;
        YPadding : CpStateInp;
        LbpComp : CpStateInp;
    }
    FSlot : VSlot
    {
        SCp : SlotCp;
    }
    LinStart : Syst
    {
        # "Lin layout slots list start";
        Prev : SlotLinPrevCp;
    }
    LinEnd : Syst
    {
        # "Lin layout slots list end";
        Next : SlotLinNextCp;
    }
    FContainer : FvWidgets.FWidgetBase
    {
        # " Container base";
        # " Padding value";
        XPadding : State { = "SI 1"; }
        YPadding : State { = "SI 1"; }
        InpMutAddWidget : CpStateInp;
        InpMutRmWidget : CpStateInp;
        OutCompsCount : CpStateOutp;
        OutCompNames : CpStateOutp;
    }
    # " Linear layout slot";
    FSlotLin : FSlot
    {
        Prev : SlotLinPrevCp;
        Next : SlotLinNextCp;
        Prev.XPadding ~ Next.XPadding;
        Prev.YPadding ~ Next.YPadding;
        Prev.LbpComp ~ : TrSvldVar @ {
            Inp1 ~ Next.LbpComp;
            Inp2 ~ SCp.LbpUri;
        };
    }
    FVLayoutSlot : FSlotLin
    {
        # " Vertical layout slot";
        Add1 : TrAddVar @ {
            Inp ~ Next.AlcY;
            Inp ~ Next.YPadding;
            Inp ~ Next.AlcH;
        }
        Max1 : TrMaxVar @ {
            Inp ~ Next.CntRqsW;
            Inp ~ SCp.RqsW;
        }
        Prev @ {
            AlcX ~ SCp.OutAlcX;
            AlcY ~ SCp.OutAlcY;
            AlcW ~ SCp.OutAlcW;
            AlcH ~ SCp.OutAlcH;
            CntRqsW ~ Max1;
        }
        SCp @ {
            InpAlcW ~ SCp.RqsW;
            InpAlcH ~ SCp.RqsH;
            InpAlcX ~ Next.AlcX;
            InpAlcY ~ Add1;
        }
    }
    FLinearLayout : FContainer
    {
        Start : LinStart;
        Start.Prev.XPadding ~ XPadding;
        Start.Prev.YPadding ~ YPadding;
        End : LinEnd;
    }
    FVLayout : FLinearLayout
    {
        CntAgent : AVLayout;
        Add2 : TrAddVar;
        RqsW.Inp ~ End.Next.CntRqsW;
        RqsH.Inp ~ Add2;
        Add2.Inp ~ End.Next.AlcY;
        Add2.Inp ~ End.Next.AlcH;
        Add2.Inp ~ End.Next.YPadding;
    }
    FHLayoutSlot : FSlotLin
    {
        # " Horisontal layout slot";
        Prev.AlcX ~ SCp.OutAlcX;
        Prev.AlcY ~ SCp.OutAlcY;
        Prev.AlcW ~ SCp.OutAlcW;
        Prev.AlcH ~ SCp.OutAlcH;
        SCp.InpAlcW ~ SCp.RqsW;
        SCp.InpAlcH ~ SCp.RqsH;
        SCp.InpAlcY ~ Next.AlcY;
        Add1 : TrAddVar;
        SCp.InpAlcX ~ Add1;
        Add1.Inp ~ Next.AlcX;
        Add1.Inp ~ Next.XPadding;
        Add1.Inp ~ Next.AlcW;
        Max1 : TrMaxVar;
        Prev.CntRqsH ~ Max1;
        Max1.Inp ~ Next.CntRqsH;
        Max1.Inp ~ SCp.RqsH;
    }
    FHLayoutBase : FLinearLayout
    {
        Add2 : TrAddVar;
        RqsW.Inp ~ Add2;
        Add2.Inp ~ End.Next.AlcX;
        Add2.Inp ~ End.Next.AlcW;
        Add2.Inp ~ End.Next.XPadding;
        RqsH.Inp ~ End.Next.CntRqsH;
    }
    FHLayout : FHLayoutBase
    {
        CntAgent : AVLayout;
    }
    AlignmentSlot : FSlotLin
    {
        # " Horisontal layout slot";
        Prev.AlcX ~ SCp.OutAlcX;
        Prev.AlcY ~ SCp.OutAlcY;
        Prev.AlcW ~ SCp.OutAlcW;
        Prev.AlcH ~ SCp.OutAlcH;
        SCp.InpAlcW ~ SCp.RqsW;
        SCp.InpAlcH ~ SCp.RqsH;
        AddX : TrAddVar;
        SCp.InpAlcX ~ AddX;
        AddX.Inp ~ Next.AlcX;
        AddX.Inp ~ Next.XPadding;
        AddY : TrAddVar;
        SCp.InpAlcY ~ AddY;
        AddY.Inp ~ Next.AlcY;
        AddY.Inp ~ Next.YPadding;
        AddCW : TrAddVar;
        Prev.CntRqsW ~ AddCW;
        AddCW.Inp ~ SCp.RqsW;
        AddCW.Inp ~ Next.XPadding;
        AddCH : TrAddVar;
        Prev.CntRqsH ~ AddCH;
        AddCH.Inp ~ SCp.RqsH;
        AddCH.Inp ~ Next.YPadding;
    }
    Alignment : FLinearLayout
    {
        CntAgent : AAlignment;
        Slot : AlignmentSlot;
        Slot.Next ~ Start.Prev;
        End.Next ~ Slot.Prev;
        RqsW.Inp ~ End.Next.CntRqsW;
        RqsH.Inp ~ End.Next.CntRqsH;
    }
    # " ";
    # " DES controlled container";
    DcAddWdgS : Socket {
        Enable : CpStateOutp;
        Name : CpStateOutp;
        Parent : CpStateOutp;
        Mut : CpStateOutp;
        Pos : CpStateOutp;
        Added : CpStateInp;
        # "TODO not used, remove";
        AddedName : CpStateInp;
    }
    DcAddWdgSc : Socket {
        Enable : CpStateInp;
        Name : CpStateInp;
        Parent : CpStateInp;
        Mut : CpStateInp;
        Pos : CpStateInp;
        Added : CpStateOutp;
        AddedName : CpStateOutp;
    }
    DcRmWdgS : Socket {
        Enable : CpStateOutp;
        Name : CpStateOutp;
        Done : CpStateInp;
    }
    DcRmWdgSc : Socket {
        Enable : CpStateInp;
        Name : CpStateInp;
        Done : CpStateOutp;
    }
    DContainer : FvWidgets.FWidgetBase
    {
        Controllable = "y";
        CntAgent : AVDContainer;
        # " Internal connections";
        CntAgent.InpFont ~ Font;
        CntAgent.InpText ~ SText;
        # " Padding value";
        XPadding : State { = "SI 1"; }
        YPadding : State { = "SI 1"; }
        IoAddWidg : DcAddWdgS;
        IoRmWidg : DcRmWdgS;
        # " Adding widget";
        CreateWdg : ASdcComp @ {
            _@ < Debug.LogLevel = "Err"; 
            Enable ~ IoAddWidg.Enable;
            Name ~ IoAddWidg.Name;
            Parent ~ IoAddWidg.Parent;
        }
        CreateWdg_Dbg : State @ { _@ < { = "SB false"; Debug.LogLevel = "Dbg"; } Inp ~ CreateWdg.Outp; }
         : ASdcMut @ {
            Enable ~ CreateWdg.Outp;
            Target ~ IoAddWidg.Name;
            Mut ~ IoAddWidg.Mut;
        }
        AddSlot : ASdcComp @ {
            _@ < Debug.LogLevel = "Err"; 
            Enable ~ IoAddWidg.Enable;
            Name ~ AdSlotName : TrApndVar @ {
                Inp1 ~ SlotNamePref : State { = "SS Slot_"; };
                Inp2 ~ IoAddWidg.Name;
            };
            Parent ~ SlotParent : State;
        }
        AddSlot_Dbg : State @ { _@ < { = "SB false"; Debug.LogLevel = "Dbg"; } Inp ~ AddSlot.Outp; }
        SdcConnWdg : ASdcConn @ {
            _@ < Debug.LogLevel = "Err"; 
            Enable ~ IoAddWidg.Enable;
            Enable ~ CreateWdg.Outp;
            Enable ~ AddSlot.Outp;
            V1 ~ : TrApndVar @ {
                Inp1 ~ IoAddWidg.Name;
                Inp2 ~ : State { = "SS .Cp"; };
            };
            V2 ~ : TrApndVar @ {
                Inp1 ~ AdSlotName;
                Inp2 ~ : State { = "SS .SCp"; };
            };
        }
        ConnWdg_Dbg : State @ { _@ < { = "SB false"; Debug.LogLevel = "Dbg"; } Inp ~ SdcConnWdg.Outp; }
        # " Removing widget";
        SdcExtrSlot : ASdcExtract @ {
            _@ < Debug.LogLevel = "Dbg"; 
            Enable ~ IoRmWidg.Enable;
            Name ~ ExtrSlotName : TrApndVar @ {
                Inp1 ~ SlotNamePref;
                Inp2 ~ IoRmWidg.Name;
            };
            Prev ~ : State { = "SS Prev"; };
            Next ~ : State { = "SS Next"; };
        }
        RmWdg : ASdcRm @ {
            _@ < Debug.LogLevel = "Dbg"; 
            Enable ~ IoRmWidg.Enable;
            Enable ~ SdcExtrSlot.Outp;
            Name ~ IoRmWidg.Name;
        }
        RmSlot : ASdcRm @ {
            _@ < Debug.LogLevel = "Dbg"; 
            Enable ~ IoRmWidg.Enable;
            Enable ~ SdcExtrSlot.Outp;
            Name ~ ExtrSlotName;
        }
        IoRmWidg.Done ~ : TrAndVar @ {
            Inp ~ RmWdg.Outp;
            Inp ~ RmSlot.Outp;
            Inp ~ SdcExtrSlot.Outp;
        };
    }
    DLinearLayout : DContainer
    {
        Start : LinStart;
        Start.Prev.XPadding ~ XPadding;
        Start.Prev.YPadding ~ YPadding;
        Start.Prev.LbpComp ~ : State { = "URI _INV"; };
        End : LinEnd;
        Cp.LbpUri ~ TLbpUri : TrApndVar @ {
            Inp1 ~ CntAgent.OutpLbpUri;
            Inp2 ~ : TrSvldVar @ {
                Inp1 ~ End.Next.LbpComp;
                Inp2 ~ : State { = "URI"; };
            };
        };
        SLbpComp_Dbg : State @ {
            _@ < { Debug.LogLevel = "Dbg";  = "URI"; }
            Inp ~ TLbpUri;
        }
        Start.Prev ~ End.Next;
        # "Inserting new widget to the end";
        SdcInsert : ASdcInsert2 @ {
            _@ < Debug.LogLevel = "Dbg"; 
            Enable ~ IoAddWidg.Enable;
            Enable ~ CreateWdg.Outp;
            Enable ~ AddSlot.Outp;
            # "Name ~ AddSlot.OutpName;";
            Name ~ AdSlotName;
            Pname ~ : State { = "SS End"; };
            Prev ~ : State { = "SS Prev"; };
            Next ~ : State { = "SS Next"; };
        }
        IoAddWidg.Added ~ SdcInsert.Outp;
    }
    DAlignment : DLinearLayout
    {
        RqsW.Inp ~ End.Next.CntRqsW;
        RqsH.Inp ~ End.Next.CntRqsH;
        SlotParent < = "SS AlignmentSlot";
    }
    DVLayout : DLinearLayout
    {
        RqsW.Inp ~ : TrAddVar @ {
            Inp ~ End.Next.CntRqsW;
            Inp ~ : TrMplVar @ {
                Inp ~ End.Next.XPadding;
                Inp ~ : State { = "SI 2"; };
            };
        };
        RqsH.Inp ~ Add2 : TrAddVar @ {
            Inp ~ End.Next.AlcY;
            Inp ~ End.Next.AlcH;
            Inp ~ End.Next.YPadding;
        };
        SlotParent < = "SS FVLayoutSlot";
    }
    DHLayout : DLinearLayout
    {
        RqsW.Inp ~ : TrAddVar @ {
            Inp ~ End.Next.AlcX;
            Inp ~ End.Next.AlcW;
            Inp ~ End.Next.XPadding;
        };
        RqsH.Inp ~ : TrAddVar @ {
            Inp ~ End.Next.CntRqsH;
            Inp ~ : TrMplVar @ {
                Inp ~ End.Next.YPadding;
                Inp ~ : State { = "SI 2"; };
            };
        };
        SlotParent < = "SS FHLayoutSlot";
    }

}
