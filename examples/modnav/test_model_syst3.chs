model : Syst {
    # "Connecting subs input to extender"
    Outp : Extd {
        Int : CpStateInp
    }
    SysInpA : ExtdStateInp
    SysOutpA : ExtdStateOutp
    Syst1 : Syst {
        # "System 1"
        SysInp1 : ExtdStateInp
    }
    Syst2 : Syst {
        # "System 2"
        SysOutp1 : ExtdStateOutp
    }
    State1 : State (
        _@ < = "SI"
        Inp ~ Syst2.SysOutp1
    )
    SysOutpA.Int ~ State1
    Syst1.SysInp1 ~ SysInpA.Int
}
