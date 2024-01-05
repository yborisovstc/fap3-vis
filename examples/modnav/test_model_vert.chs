model : Syst {
    vert1 : Vert {
        vert1_1 : Vert {
            vert1_2_1 : Vert
        }
        unit2 : Unit {
            unit3 : Unit
        }
        vert1_2 : Vert {
            vert1_2_1 : Vert
        }
        vert1_3 : Vert
    }
    vert3 : vert1 {
        vert4 : vert1.vert1_1 {
            vert4_1 : Vert
        }
        vert3_1 : Vert
    }
    vert5 : vert1.vert1_1
    vert4_1i : vert3.vert4.vert4_1
    vert6 : vert1 {
        vert1_2 < vert6_1 : Vert {
            vert6_2 : Vert
            vert6_3 : Vert
        }
    }
    syst1 : Syst {
        syst1_v1 : Vert
        syst1_v2 : Vert
        syst1_v1 ~ syst1_v2
    }
    vert1 ~ vert6
    vert3 ~ vert5
}
