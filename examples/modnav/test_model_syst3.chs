model : Syst {
    # "Connecting subs input to extender"
    Outp : Extd {
        Int : CpStateInp
    }
    SysInpA : ExtdStateInp
    Syst1 : Syst {
        # "System 1"
        SysInp1 : ExtdStateInp
    }
    Syst2 : Syst {
        # "System 2"
        SysOutp1 : ExtdStateOutp
    }
    Syst1.SysInp1 ~ SysInpA.Int
}
