model : Syst {
    Syst1 : Syst {
        # "System 1"
        SysInp1 : ExtdStateInp
        SysInp2 : ExtdStateInp
        SysInp3 : ExtdStateInp
        SysOutp1 : ExtdStateOutp
        SysOutp2 : ExtdStateOutp
        SysOutp3 : ExtdStateOutp
    }
    Syst2 : Syst {
        # "System 2"
        SysInp1 : ExtdStateInp
        SysInp2 : ExtdStateInp
        SysInp3 : ExtdStateInp
        SysOutp1 : ExtdStateOutp
        SysOutp2 : ExtdStateOutp
    }
    Syst3 : Syst {
        # "System 3"
        SysInp1 : ExtdStateInp
        SysInp2 : ExtdStateInp
        SysOutp1 : ExtdStateOutp
    }
    Syst1.SysOutp1 ~ Syst2.SysInp1
    Syst2.SysOutp2 ~ Syst3.SysInp1
    Syst3.SysInp2 ~ Syst1.SysOutp2
    Syst3.SysOutp1 ~ Syst1.SysInp2
    Syst1.SysOutp3 ~ Syst1.SysInp3
}
