test : Syst
{
    $ # " Unit test for ceation of system. System includes connpoint with roles specified.
     So System supports different type of relations (roled relations)
     This test is just for conn points connection
     System specific mutation is used for connection
     ";
    Modules : AImports
    {
        $ + /SysComps/ConnPoint;
        $ + /SysComps/Extender;
    }
    Syst1 : Syst
    {
        cp : /test/Modules/SysComps/ConnPoint
        {
            Provided < $ = Role1;
            Required < $ = Role2;
        }
        ep : /test/Modules/SysComps/Extender
        {
            ./Int/Provided < $ = Role3;
            ./Int/Required < $ = Role4;
        }
    }
    cp1 : /test/Modules/SysComps/ConnPoint
    {
        Provided < $ = Role1;
        Required < $ = Role2;
    }
    cp2 : /test/Modules/SysComps/ConnPoint
    {
        Provided < $ = Role2;
        Required < $ = Role1;
    }
    cp3 : /test/Modules/SysComps/ConnPoint
    {
        Provided < $ = Role4;
        Required < $ = Role3;
    }
    cp1 ~ cp2;
    ./Syst1/cp ~ cp2;
    ./Syst1/ep/Int ~ cp3;
}
