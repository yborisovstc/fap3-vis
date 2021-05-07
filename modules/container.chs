ContainerMod : Elem
{
    About = "FAP2 widget visualization system";
    Modules : AImports
    {
        + FvWidgets;
    SlotCp : Socket
    {
        InpAlcX : CpStatecInp;
        InpAlcY : CpStatecInp;
        InpAlcW : CpStatecInp;
        InpAlcH : CpStatecInp;
        OutAlcX : CpStatecOutp;
        OutAlcY : CpStatecOutp;
        OutAlcW : CpStatecOutp;
        OutAlcH : CpStatecOutp;
        RqsW : CpStatecOutp;
        RqsH : CpStatecOutp;
    }
    SlotLinNextCp : Socket
    {
        AlcX : CpStatecOutp;
        AlcY : CpStatecOutp;
        AlcW : CpStatecOutp;
        AlcH : CpStatecOutp;
        CntRqsW : CpStatecOutp;
        CntRqsH : CpStatecOutp;
        Padding : CpStatecOutp;
    }
    SlotLinPrevCp : Socket
    {
        AlcX : CpStatecInp;
        AlcY : CpStatecInp;
        AlcW : CpStatecInp;
        AlcH : CpStatecInp;
        CntRqsW : CpStatecInp;
        CntRqsH : CpStatecInp;
        Padding : CpStatecInp;
    }
    }
    FContainer : FvWidgets.FWidgetBase
    {
        # " Container base";
        # " Padding value";
        Padding : State;
        Padding < = "SI 10";
        InpMutAddWidget : CpStatecInp;
        InpMutRmWidget : CpStatecInp;
        OutCompsCount : CpStatecOutp;
        OutCompNames : CpStatecOutp;
    }
    FSlotl : VSlot
    {
        SCp : SlotCp;
    }
    # " Linear layout slot";
    FSlotlLin : FSlotl
    {
        Prev : SlotLinPrevCp;
        Next : SlotLinNextCp;
        Prev.Padding ~ Next.Padding;
    }
    FVLayoutLSlot : FSlotlLin
    {
        # " Vertical layout slot";
        Prev.AlcX ~ SCp.OutAlcX;
        Prev.AlcY ~ SCp.OutAlcY;
        Prev.AlcW ~ SCp.OutAlcW;
        Prev.AlcH ~ SCp.OutAlcH;
        SCp.InpAlcW ~ SCp.RqsW;
        SCp.InpAlcH ~ SCp.RqsH;
        SCp.InpAlcX ~ Next.AlcX;
        Add1 : ATrcAddVar;
        SCp.InpAlcY ~ Add1;
        Add1.Inp ~ Next.AlcY;
        Add1.Inp ~ Next.Padding;
        Add1.Inp ~ Next.AlcH;
        Max1 : ATrcMaxVar;
        Prev.CntRqsW ~ Max1;
        Max1.Inp ~ Next.CntRqsW;
        Max1.Inp ~ SCp.RqsW;
    }
    FLinearLayoutL : FContainerL
    {
        Start : SlotLinPrevCp;
        Start.Padding ~ Padding;
        End : SlotLinNextCp;
    }
    FVLayout : FLinearLayout
    {
        CntAgent : AVLayoutL;
        Add2 : ATrcAddVar;
        RqsW.Inp ~ End.CntRqsW;
        RqsH.Inp ~ Add2;
        Add2.Inp ~ End.AlcY;
        Add2.Inp ~ End.AlcH;
        Add2.Inp ~ End.Padding;
    }
    FHLayoutLSlot : FSlotlLin
    {
        # " Horisontal layout slot";
        Prev.AlcX ~ SCp.OutAlcX;
        Prev.AlcY ~ SCp.OutAlcY;
        Prev.AlcW ~ SCp.OutAlcW;
        Prev.AlcH ~ SCp.OutAlcH;
        SCp.InpAlcW ~ SCp.RqsW;
        SCp.InpAlcH ~ SCp.RqsH;
        SCp.InpAlcY ~ Next.AlcY;
        Add1 : ATrcAddVar;
        SCp.InpAlcX ~ Add1;
        Add1.Inp ~ Next.AlcX;
        Add1.Inp ~ Next.Padding;
        Add1.Inp ~ Next.AlcW;
        Max1 : ATrcMaxVar;
        Prev.CntRqsH ~ Max1;
        Max1.Inp ~ Next.CntRqsH;
        Max1.Inp ~ SCp.RqsH;
    }
    FHLayoutLBase : FLinearLayout
    {
        Add2 : ATrcAddVar;
        RqsW.Inp ~ Add2;
        Add2.Inp ~ End.AlcX;
        Add2.Inp ~ End.AlcW;
        Add2.Inp ~ End.Padding;
        RqsH.Inp ~ End.CntRqsH;
    }
    FHLayoutL : FHLayoutLBase
    {
        CntAgent : AVLayoutL;
    }
    AlignmentSlot : FSlotlLin
    {
        # " Horisontal layout slot";
        Prev.AlcX ~ SCp.OutAlcX;
        Prev.AlcY ~ SCp.OutAlcY;
        Prev.AlcW ~ SCp.OutAlcW;
        Prev.AlcH ~ SCp.OutAlcH;
        SCp.InpAlcW ~ SCp.RqsW;
        SCp.InpAlcH ~ SCp.RqsH;
        AddX : ATrcAddVar;
        SCp.InpAlcX ~ AddX;
        AddX.Inp ~ Next.AlcX;
        AddX.Inp ~ Next.Padding;
        AddY : ATrcAddVar;
        SCp.InpAlcY ~ AddY;
        AddY.Inp ~ Next.AlcY;
        AddY.Inp ~ Next.Padding;
        AddCW : ATrcAddVar;
        Prev.CntRqsW ~ AddCW;
        AddCW.Inp ~ SCp.RqsW;
        AddCW.Inp ~ Next.Padding;
        AddCH : ATrcAddVar;
        Prev.CntRqsH ~ AddCH;
        AddCH.Inp ~ SCp.RqsH;
        AddCH.Inp ~ Next.Padding;
    }
    Alignment : FLinearLayoutL
    {
        CntAgent : AAlignment;
        Slot : AlignmentSlot;
        Slot.Next ~ Start;
        End ~ Slot.Prev;
        RqsW.Inp ~ End.CntRqsW;
        RqsH.Inp ~ End.CntRqsH;
    }
}
