Device NMOS {

  Electrode{
    { Name="source"    Voltage=0.0 }
    { Name="drain"     Voltage=0.0 }
    { Name="gate"      Voltage=0.0 }
    { Name="substrate" Voltage=0.0 }
  }

  File{
     Grid    = "/home/kunalg/mnit_manipur_tcad/nmos_v1/modelling/nmos_final_fps.tdr" 
     Plot    = "nmos"
     Current = "nmos"
*--     Param   = "/home/kunalg/mnit_manipur_tcad/nmos_v1/modelling/models.par"
  }

  Physics{
    AreaFactor=5
    Mobility( DopingDep HighFieldSaturation Enormal )
    EffectiveIntrinsicDensity( oldSlotboom )
  }

}

Device PMOS{
  
  Electrode{
    { Name="source"    Voltage=0.0 }
    { Name="drain"     Voltage=0.0 }
    { Name="gate"      Voltage=0.0 } 
    { Name="substrate" Voltage=0.0 }
  }

  File{
     Grid    = "/home/kunalg/mnit_manipur_tcad/pmos/modelling/pmos_final_fps.tdr"
     Plot    = "pmos"
     Current = "pmos"
*--     Param   = "/home/kunalg/mnit_manipur_tcad/pmos/modelling/models.par"
  }
    
  Physics{
    AreaFactor=10
    Mobility( DopingDep HighFieldSaturation Enormal )
    EffectiveIntrinsicDensity( oldSlotboom )
  }

}

File{
   Output = "cmos.log"
}

Plot{
    eDensity hDensity
    eCurrent hCurrent
    ElectricField eEnormal hEnormal
    eQuasiFermi hQuasiFermi
    Potential Doping SpaceCharge
    SRH Auger 
    AvalancheGeneration
    eMobility hMobility
    DonorConcentration AcceptorConcentration
    Doping
    eVelocity hVelocity
}

Math{
  Extrapolate
  RelErrControl
  Digits=4
  Notdamped=50
  Iterations=100
  Transient=BE
  Method=Blocked
  SubMethod=ParDiSo
}

System{
  Vsource_pset vdd (dd 0) { dc = 0.0 }
  Vsource_pset vin (in 0) { dc = 0.0 }

  NMOS nmos1 ( "source"=0  "drain"=out "gate"=in "substrate"=0 )
  PMOS pmos1 ( "source"=dd "drain"=out "gate"=in "substrate"=dd )  
  Capacitor_pset cout ( out 0 ){ capacitance = 3e-14 }

  Plot "cmos_sys_des.plt" (time() v(in) v(out) 
                              i(nmos1,out) i(pmos1,out) i(cout,out) )
}

Solve{  
  NewCurrentPrefix="init"
  Coupled(Iterations=100){ Poisson }
  Coupled{ Poisson Electron Hole Contact Circuit }

  Quasistationary( 
     InitialStep=1e-3 Increment=1.35
     MinStep=1e-5 MaxStep=0.05 
     Goal{ Parameter=vdd.dc Voltage= 1.8 } 
  ){ Coupled{ nmos1.poisson nmos1.electron nmos1.hole nmos1.contact 
              pmos1.poisson pmos1.electron pmos1.hole pmos1.contact
              circuit }
  }

  NewCurrentPrefix="final"
  Coupled(Iterations=100){ Poisson }
  Coupled{ Poisson Electron Hole Contact Circuit }

  Quasistationary( 
     InitialStep=1e-3 Increment=1.35
     MinStep=1e-5 MaxStep=0.05 
     Goal{ Parameter=vin.dc Voltage= 1.8 } 
  ){ Coupled{ nmos1.poisson nmos1.electron nmos1.hole nmos1.contact 
              pmos1.poisson pmos1.electron pmos1.hole pmos1.contact
              circuit }
  }
}
