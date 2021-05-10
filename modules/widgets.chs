FvWidgets : Elem
{
    About : Content {  = "FAP2 visualization system. Widget-to-slot linkage approach"; }
        WidgetCp : Socket
        {
            InpAlcX : CpStateOutp;
            InpAlcY : CpStateOutp;
            InpAlcW : CpStateOutp;
            InpAlcH : CpStateOutp;
            OutAlcX : CpStateInp;
            OutAlcY : CpStateInp;
            OutAlcW : CpStateInp;
            OutAlcH : CpStateInp;
            RqsW : CpStateInp;
            RqsH : CpStateInp;
        }
        WidgetCpc : Socket
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
    FWidgetBase : Syst
    {
        # " Widget base";
        FontPath : Content { = "/usr/share/fonts/truetype/ubuntu/Ubuntu-R.ttf"; }
        Cp : WidgetCp;
        # " Allocation";
        AlcX : State;
        AlcX < {
            Debug : Content { Update : Content { = "y"; } }
            = "SI 0";
        }
        AlcY : State;
        AlcY < {
            Debug : Content { Update : Content { = "y"; } }
            = "SI 0";
        }
        AlcW : State;
        AlcW < {
            Debug : Content { Update : Content { = "y"; } }
            = "SI 0";
        }
        AlcH : State;
        AlcH < {
            Debug : Content { Update : Content { = "y"; } }
            = "SI 0";
        }
        # " Requisition";
        RqsW : State;
        RqsW < {
            Debug : Content { Update : Content { = "y"; } }
            = "SI 0";
        }
        RqsH : State;
        RqsH < {
            Debug : Content { Update : Content { = "y"; } }
            = "SI 0";
        }
        # " Color";
        FgColor : Content { R : Content; G : Content; B : Content; A : Content; }
        BgColor : Content { R : Content; G : Content; B : Content; A : Content; }
        # " Connections";
        AlcX.Inp ~ Cp.InpAlcX;
        AlcY.Inp ~ Cp.InpAlcY;
        AlcW.Inp ~ Cp.InpAlcW;
        AlcH.Inp ~ Cp.InpAlcH;
        AlcX ~ Cp.OutAlcX;
        AlcY ~ Cp.OutAlcY;
        AlcW ~ Cp.OutAlcW;
        AlcH ~ Cp.OutAlcH;
        RqsW ~ Cp.RqsW;
        RqsH ~ Cp.RqsH;
    }
    FWidget : FWidgetBase
    {
        # " Widget";
        WdgAgent : AVWidget;
    }
    FLabel : FWidgetBase
    {
        # " Label";
        WdgAgent : AVLabel;
    }
    FButton : FWidgetBase
    {
        # " Button";
        WdgAgent : AButton;
        Text : Content;
        Pressed : State;
        Pressed < { Debug : Content { Update : Content { = "y"; } } }
        Pressed < = "SB false";
        PressedReset : State;
        PressedReset < = "SB false";
        Pressed.Inp ~ PressedReset;
    }

}
