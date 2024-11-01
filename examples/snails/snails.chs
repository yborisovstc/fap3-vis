root : Elem {
    # "FAP3/FAP3_VIS Demo app --Snails racing--"
    + GVisComps
    + FvWidgets
    Launcher : VDesLauncher {
        Debug.LogLevel = "Dbg"
        Env : GVisComps.VisEnv
        Env.VisEnvAgt < Init = "Yes"
        Window : GVisComps.Window {
            Init = "Yes"
            Width < = "SI 1200"
            Height < = "SI 800"
            Scene : GVisComps.Scene {
                # "Scene"
                Snail1Wdg : FvWidgets.FLabel {
                    BgColor <  {
                        R < = "1.0"
                        G < = "1.0"
                        B < = "0.0"
                        A < = "1.0"
                    }
                    SText < = "SS Snail_1"
                    AlcX < = "SI 200"
                    AlcY < = "SI 100"
                    AlcW < = "SI 200"
                    AlcH < = "SI 80"
                }
                Snail2Wdg : FvWidgets.FLabel {
                    BgColor <  {
                        R < = "1.0"
                        G < = "1.0"
                        B < = "0.0"
                        A < = "1.0"
                    }
                    SText < = "SS Snail_2"
                    AlcX < = "SI 200"
                    AlcY < = "SI 300"
                    AlcW < = "SI 200"
                    AlcH < = "SI 20"
                }
            }
        }
    }
}
