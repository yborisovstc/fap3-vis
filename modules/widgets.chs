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
            LbpUri : CpStateInp;
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
            LbpUri : CpStateOutp;
}
    FWidgetBase : Syst
    {
        # " Widget base";
        FontPath : Content { = "/usr/share/fonts/truetype/ubuntu/Ubuntu-R.ttf"; }
        Font : State { = "SS /usr/share/fonts/truetype/ubuntu/Ubuntu-R.ttf"; }
        FontSize : State { = "SI 16"; }
        SText : State { = "SS"; Debug.LogLevel = "Dbg"; }
        Cp : WidgetCp;
        # " Allocation";
        AlcX : State;
        AlcX < {
            Debug.LogLevel = "Dbg";
            = "SI 0";
        }
        AlcY : State;
        AlcY < {
            Debug.LogLevel = "Dbg";
            = "SI 0";
        }
        AlcW : State;
        AlcW < {
            Debug.LogLevel = "Dbg";
            = "SI 0";
        }
        AlcH : State;
        AlcH < {
            Debug.LogLevel = "Dbg";
            = "SI 0";
        }
        # " Requisition";
        RqsW : State;
        RqsW < {
            Debug.LogLevel = "Dbg";
            = "SI 0";
        }
        RqsH : State;
        RqsH < {
            Debug.LogLevel = "Dbg";
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
        # " Internal connections";
        # "TODO to do dynamic connection in WdgBase as soon as WdgAgent created";
        # "TODO or to apply named segment, ref ds_cli_nseg";
        WdgAgent.InpFont ~ Font;
        WdgAgent.InpText ~ SText;
        RqsW.Inp ~ WdgAgent.OutpRqsW;
        RqsH.Inp ~ WdgAgent.OutpRqsH;
	Cp.LbpUri ~ WdgAgent.OutpLbpUri;
    }
    FLabel : FWidgetBase
    {
        # " Label";
        WdgAgent : AVLabel;
        # " Internal connections";
        # "TODO duplicated in widgets, to avoid";
        WdgAgent.InpFont ~ Font;
        WdgAgent.InpText ~ SText;
        RqsW.Inp ~ WdgAgent.OutpRqsW;
        RqsH.Inp ~ WdgAgent.OutpRqsH;
	Cp.LbpUri ~ WdgAgent.OutpLbpUri;
    }
    FButton : FWidgetBase
    {
        # " Button";
        WdgAgent : AButton;
        # " Internal connections";
        WdgAgent.InpFont ~ Font;
        WdgAgent.InpText ~ SText;
        RqsW.Inp ~ WdgAgent.OutpRqsW;
        RqsH.Inp ~ WdgAgent.OutpRqsH;
	Cp.LbpUri ~ WdgAgent.OutpLbpUri;
        VisPars : Des {
            Border : State { = "SB true"; }
        }
        Pressed : State;
        Pressed < Debug.LogLevel = "Dbg";
        Pressed < = "SB false";
        PressedReset : State;
        PressedReset < = "SB false";
        Pressed.Inp ~ PressedReset;
    }
    FNodeCrp : FWidgetBase
    {
        # " Node visual repesentation";
        WdgAgent : ANodeCrp;
        BgColor < { R < = "0.0"; G < = "0.3"; B < = "0.0"; }
        FgColor < { R < = "1.0"; G < = "1.0"; B < = "1.0"; }
    }
}
