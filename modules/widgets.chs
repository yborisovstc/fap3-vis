FvWidgets : Elem {
    About : Content {
        = "FAP3 visualization system. Widget-to-slot linkage approach"
    }
    WidgetCp : Socket {
        InpAlcX : CpStateOutp
        InpAlcY : CpStateOutp
        InpAlcW : CpStateOutp
        InpAlcH : CpStateOutp
        OutAlcX : CpStateInp
        OutAlcY : CpStateInp
        OutAlcW : CpStateInp
        OutAlcH : CpStateInp
        RqsW : CpStateInp
        RqsH : CpStateInp
        LbpUri : CpStateInp
    }
    WidgetCpc : Socket {
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
    IWidget : Des {
        # "Widget iface"
        Cp : WidgetCp
    }
    FWidgetBase : Syst {
        # " Widget base"
        FontPath : Content {
            = "/usr/share/fonts/truetype/ubuntu/Ubuntu-R.ttf"
        }
        Font : State {
            = "SS /usr/share/fonts/truetype/ubuntu/Ubuntu-R.ttf"
        }
        FontSize : State {
            = "SI 16"
        }
        SText : State {
            = "SS _INV"
        }
        Cp : WidgetCp
        # " Allocation"
        AlcX : State
        AlcX <  {
            = "SI 0"
        }
        AlcY : State
        AlcY <  {
            = "SI 0"
        }
        AlcW : State
        AlcW <  {
            = "SI 0"
        }
        AlcH : State
        AlcH <  {
            = "SI 0"
        }
        # " Requisition"
        RqsW : State
        RqsW <  {
            = "SI 0"
        }
        RqsH : State
        RqsH <  {
            = "SI 0"
        }
        # " Color"
        FgColor : Content {
            R : Content
            G : Content
            B : Content
            A : Content
        }
        BgColor : Content {
            R : Content
            G : Content
            B : Content
            A : Content
        }
        # " Connections"
        AlcX.Inp ~ Cp.InpAlcX
        AlcY.Inp ~ Cp.InpAlcY
        AlcW.Inp ~ Cp.InpAlcW
        AlcH.Inp ~ Cp.InpAlcH
        AlcX ~ Cp.OutAlcX
        AlcY ~ Cp.OutAlcY
        AlcW ~ Cp.OutAlcW
        AlcH ~ Cp.OutAlcH
        RqsW ~ Cp.RqsW
        RqsH ~ Cp.RqsH
    }
    FWidget : FWidgetBase {
        # " Widget"
        WdgAgent : AVWidget
        # " Internal connections"
        # "TODO to do dynamic connection in WdgBase as soon as WdgAgent created"
        # "TODO or to apply named segment, ref ds_cli_nseg"
        WdgAgent.InpFont ~ Font
        WdgAgent.InpText ~ SText
        RqsW.Inp ~ WdgAgent.OutpRqsW
        RqsH.Inp ~ WdgAgent.OutpRqsH
        Cp.LbpUri ~ WdgAgent.OutpLbpUri
    }
    FLabel : FWidgetBase {
        # " Label"
        WdgAgent : AVLabel
        # " Internal connections"
        # "TODO duplicated in widgets, to avoid"
        WdgAgent.InpFont ~ Font
        WdgAgent.InpText ~ SText
        RqsW.Inp ~ WdgAgent.OutpRqsW
        RqsH.Inp ~ WdgAgent.OutpRqsH
        Cp.LbpUri ~ WdgAgent.OutpLbpUri
    }
    FButton : FWidgetBase {
        # " Button"
        WdgAgent : AButton
        # " Internal connections"
        WdgAgent.InpFont ~ Font
        WdgAgent.InpText ~ SText
        RqsW.Inp ~ WdgAgent.OutpRqsW
        RqsH.Inp ~ WdgAgent.OutpRqsH
        Cp.LbpUri ~ WdgAgent.OutpLbpUri
        VisPars : Des {
            Border : State {
                = "SB true"
            }
        }
        Pressed : State
        Pressed < Debug.LogLevel = "Dbg"
        Pressed < = "SB false"
        PressedReset : State
        PressedReset < = "SB false"
        Pressed.Inp ~ PressedReset
    }
}
