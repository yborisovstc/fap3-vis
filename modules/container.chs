ContainerMod : Elem
{
    About : Content { = "FAP3 widget visualization system"; }
    Modules : Node
    {
        + FvWidgets;
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
    }
    SlotLinNextCp : Socket
    {
        AlcX : CpStateOutp;
        AlcY : CpStateOutp;
        AlcW : CpStateOutp;
        AlcH : CpStateOutp;
        CntRqsW : CpStateOutp;
        CntRqsH : CpStateOutp;
        Padding : CpStateOutp;
    }
    SlotLinPrevCp : Socket
    {
        AlcX : CpStateInp;
        AlcY : CpStateInp;
        AlcW : CpStateInp;
        AlcH : CpStateInp;
        CntRqsW : CpStateInp;
        CntRqsH : CpStateInp;
        Padding : CpStateInp;
    }
    FSlot : VSlot
    {
        SCp : SlotCp;
    }
    FContainer : FvWidgets.FWidgetBase
    {
        # " Container base";
        # " Padding value";
        Padding : State;
        Padding < = "SI 10";
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
        Prev.Padding ~ Next.Padding;
    }
    FVLayoutSlot : FSlotLin
    {
        # " Vertical layout slot";
        Prev.AlcX ~ SCp.OutAlcX;
        Prev.AlcY ~ SCp.OutAlcY;
        Prev.AlcW ~ SCp.OutAlcW;
        Prev.AlcH ~ SCp.OutAlcH;
        SCp.InpAlcW ~ SCp.RqsW;
        SCp.InpAlcH ~ SCp.RqsH;
        SCp.InpAlcX ~ Next.AlcX;
        Add1 : TrAddVar;
        SCp.InpAlcY ~ Add1;
        Add1.Inp ~ Next.AlcY;
        Add1.Inp ~ Next.Padding;
        Add1.Inp ~ Next.AlcH;
        Max1 : TrMaxVar;
        Prev.CntRqsW ~ Max1;
        Max1.Inp ~ Next.CntRqsW;
        Max1.Inp ~ SCp.RqsW;
    }
    FLinearLayout : FContainer
    {
        Start : SlotLinPrevCp;
        Start.Padding ~ Padding;
        End : SlotLinNextCp;
    }
    FVLayout : FLinearLayout
    {
        CntAgent : AVLayout;
        Add2 : TrAddVar;
        RqsW.Inp ~ End.CntRqsW;
        RqsH.Inp ~ Add2;
        Add2.Inp ~ End.AlcY;
        Add2.Inp ~ End.AlcH;
        Add2.Inp ~ End.Padding;
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
        Add1.Inp ~ Next.Padding;
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
        Add2.Inp ~ End.AlcX;
        Add2.Inp ~ End.AlcW;
        Add2.Inp ~ End.Padding;
        RqsH.Inp ~ End.CntRqsH;
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
        AddX.Inp ~ Next.Padding;
        AddY : TrAddVar;
        SCp.InpAlcY ~ AddY;
        AddY.Inp ~ Next.AlcY;
        AddY.Inp ~ Next.Padding;
        AddCW : TrAddVar;
        Prev.CntRqsW ~ AddCW;
        AddCW.Inp ~ SCp.RqsW;
        AddCW.Inp ~ Next.Padding;
        AddCH : TrAddVar;
        Prev.CntRqsH ~ AddCH;
        AddCH.Inp ~ SCp.RqsH;
        AddCH.Inp ~ Next.Padding;
    }
    Alignment : FLinearLayout
    {
        CntAgent : AAlignment;
        Slot : AlignmentSlot;
        Slot.Next ~ Start;
        End ~ Slot.Prev;
        RqsW.Inp ~ End.CntRqsW;
        RqsH.Inp ~ End.CntRqsH;
    }
}
