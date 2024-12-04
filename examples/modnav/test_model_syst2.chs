model : Syst {
    Syst1 : Syst {
        # "System 1"
        SysInp1 : ExtdStateInp
        SysInp2 : ExtdStateInp
        SysInp3 : ExtdStateInp
        SysOutp1 : ExtdStateOutp
        SysOutp2 : ExtdStateOutp
        SysOutp3 : ExtdStateOutp
        SysOutp1.Int ~ SysInp1.Int
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
    Syst4 : Syst {
        # "System 4"
        SysInp1 : ExtdStateInp
        SysInp2 : ExtdStateInp
        SysOutp1 : ExtdStateOutp
    }
    Syst5 : Syst {
        # "System 5"
        SysInp1 : ExtdStateInp
        SysInp2 : ExtdStateInp
        SysInp3 : ExtdStateInp
        SysOutp1 : ExtdStateOutp
        SysOutp2 : ExtdStateOutp
        SysOutp3 : ExtdStateOutp
        Syst5_1 : Syst {
            SysInp1 : ExtdStateInp
            SysOutp1 : ExtdStateOutp
        }
        Syst5_2 : Syst5_1 {
            SysOutp2 : ExtdStateOutp
            SysInpX : ExtdStateInp
        }
        Syst5_3 : Syst5_2 {
            SysInp3 : ExtdStateInp
        }
        Syst5_2.SysOutp1 ~ Syst5_1.SysInp1
        Syst5_3.SysOutp1 ~ Syst5_2.SysInp1
        Syst5_1.SysOutp1 ~ Syst5_3.SysInp3
        Syst5_2.SysInpX ~ SysInp2.Int
    }
    Syst1.SysOutp1 ~ Syst2.SysInp1
    Syst2.SysOutp2 ~ Syst3.SysInp1
    Syst2.SysOutp1 ~ Syst4.SysInp1
    Syst2.SysOutp1 ~ Syst5.SysInp1
    Syst3.SysInp2 ~ Syst1.SysOutp2
    Syst3.SysOutp1 ~ Syst1.SysInp2
    Syst3.SysOutp1 ~ Syst5.SysInp2
    Syst1.SysOutp3 ~ Syst1.SysInp3
    Syst4.SysOutp1 ~ Syst1.SysInp3
    Syst4.SysOutp1 ~ Syst1.SysInp1
}
