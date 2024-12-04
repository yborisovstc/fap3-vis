model : Des {
    # "Connecting subs input to extender"
    InpA : ExtdStateInp
    OutpA : ExtdStateOutp
    InpB : ExtdStateInp
    OutpB : ExtdStateOutp
    Des1 : Des {
        # "System 1"
        Inp1 : ExtdStateInp
    }
    Des2 : Des {
        # "System 2"
        Outp1 : ExtdStateOutp
    }
    State1 : State (
        _@ < = "SI"
        Inp ~ : TrAdd2Var (
            Inp ~ : Const {
                = "SI 2"
            }
            Inp2 ~ Des2.Outp1
        )
    )
    OutpA.Int ~ State1
    Des1.Inp1 ~ InpA.Int
    OutpA.Int ~ InpA.Int
    Des1.Inp1 ~ Des2.Outp1
}
