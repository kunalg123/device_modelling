# Copyright (c) 1994-2014 Synopsys, Inc.
# This file and the associated documentation are proprietary to
# Synopsys, Inc.  This file may only be used in accordance with the
# terms and conditions of a written license agreement with Synopsys,
# Inc.  All other use, reproduction, or distribution of this file is
# strictly prohibited.

#setdep @node|-1:all@
#----------------------------------------------------------------------#
#- Sentaurus Device input deck for a transient mixed-mode simulation of the
#- switching of an inverter build with a nMOSFET and a pMOSFET.
#----------------------------------------------------------------------#

# define the n-channel MOSFET;
Device NMOS {

  Electrode {
    { name="source"    Voltage=0.0 Area=5 }
    { name="drain"     Voltage=0.0 Area=5 }
    { name="gate"      Voltage=0.0 Area=5  Barrier=-0.55 }
    { name="substrate" Voltage=0.0 Area=5 }
  }

File {
        grid    = "/home/kunalg/mnit_manipur_tcad/nmos_v1/modelling/nmos_final_fps.tdr"
    	Plot    = "nmos"
    	Current = "nmos"
*--        Param   = "mos"
}

  Physics {
    Mobility( DopingDep HighFieldSaturation Enormal )
    EffectiveIntrinsicDensity( oldSlotboom )
  }

}


# define the p-channel MOSFET;
Device PMOS{
  Electrode {
    { Name="source"    Voltage=0.0 Area=10 }
    { Name="drain"     Voltage=0.0 Area=10 }
    { Name="gate"      Voltage=0.0 Area=10  Barrier=0.55 } 
    { Name="substrate" Voltage=0.0 Area=10 }
  }

  File {
        grid    = "/home/kunalg/mnit_manipur_tcad/pmos/modelling/pmos_final_fps.tdr"
    	Plot    = "pmos"
    	Current = "pmos"
*--        Param   = "mos"
  }
    
  Physics {
    Mobility( DopingDep HighFieldSaturation Enormal )
    EffectiveIntrinsicDensity( oldSlotboom )
  }

}

System {
  Vsource_pset v0 (n1 n0) { pwl = (0.0e+00 0.0
                                   1.0e-11 0.0
                                   1.5e-11 2.0
                                  10.0e-11 2.0
                                  10.5e-11 0.0
                                  20.0e-11 0.0)}

  NMOS nmos( "source"=n0 "drain"=n3 "gate"=n1 "substrate"=n0 )
  PMOS pmos( "source"=n2 "drain"=n3 "gate"=n1 "substrate"=n2 )
    
  Capacitor_pset c1 ( n3 n0 ){ capacitance = 3e-15 }
   
  Set (n0 = 0)
  Set (n2 = 0)
  Set (n3 = 0)

  Plot "nodes.plt" (time() n0 n1 n2 n3 )
}

File {
   Current= "inv"
   Output = "inv"
}

Plot {
    eDensity hDensity
    eCurrent hCurrent
    ElectricField eEnormal hEnormal
    eQuasiFermi hQuasiFermi
    Potential Doping SpaceCharge
    DonorConcentration AcceptorConcentration
}

Math {
  Extrapolate
  RelErrControl
  Digits=4
  Notdamped=50
  Iterations=12
  NoCheckTransientError
}

Solve {  
  #-build up initial solution
  NewCurrentPrefix = "ignore_"
  Coupled { Poisson }
  Quasistationary ( InitialStep=0.1  MaxStep=0.1
                    Goal { Node="n2" Voltage=2 }
                    Goal { Node="n3" Voltage=2 }
                   )
                  { Coupled { Poisson Electron Hole } }
    	
  NewCurrentPrefix = "final_"
  Unset (n3)

  Transient (
    InitialTime=0 FinalTime=20e-11
    InitialStep=1e-12 MaxStep=1e-11 MinStep=1e-15
    Increment=1.3
  ) 
  { Coupled { nmos.poisson nmos.electron nmos.contact 
              pmos.poisson pmos.hole     pmos.contact
              circuit }
   }
}












