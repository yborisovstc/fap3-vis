GVisComps : Elem
{
    About : Content { = "Visualization system based on GLUT"; }
    Modules : Node
    {
        SceneCp : Socket
        {
            Width : CpStateOutp;
            Height : CpStateOutp;
        }
        SceneCpc : Socket
        {
            Width : CpStateInp;
            Height : CpStateInp;
        }
    }
    VisEnv : Syst
    {
        About : Content { = "Visualization system environment"; }
        VisEnvAgt : AVisEnv {
	    Init : Content;
        }
    }
    Window : GWindow
    {
        About : Content { = "Top-level window"; }
	Init : Content;
        Inp_X : CpStateInp;
        Inp_Y : CpStateInp;
        Inp_W : CpStateInp;
        Inp_H : CpStateInp;
        Inp_Title : CpStateInp;
        Width : State { = "SI 640"; }
        Height : State {  = "SI 480"; }
        ScCpc : SceneCpc;
        ScCpc.Width ~ Width;
        ScCpc.Height ~ Height;
    }
    Scene : GtScene
    {
        About : Content { = "Visualization system scene"; }
        Cp : SceneCp;
    }
}
