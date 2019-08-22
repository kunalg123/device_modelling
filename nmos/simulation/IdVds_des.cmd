#setdep @node|nMOS@

*-- @tmodel@

#define _Vdd_     1.1
#define _Vginit_  1.8

#if "@tmodel@" == "DD"
#define _Tmodel_     * DriftDiffusion
#define _DF_       GradQuasiFermi
#define _EQUATIONSET__  Poisson Electron Hole
#elif "@tmodel@" == "HD"
#define _Tmodel_     Hydrodynamic(eTemperature)
#define _DF_       CarrierTempDrive
#define _EQUATIONSET_  Poisson Electron Hole eTemperature Temperature
#elif "@tmodel@" == "Thermo"
#define _Tmodel_     Thermodynamic 
#define _DF_       GradQuasiFermi
#define _EQUATIONSET_  Poisson Electron Hole Temperature
#endif


#-- quantum correction
#if "@QC@" == "DG"
#define _QC_ eQuantumPotential 
#else
#define _QC_
#endif


File{
   Grid      = "/home/kunalg/mnit_manipur_tcad/nmos_v1/modelling/nmos_final_fps.tdr"
   Plot      = "IdVds"
*--   Parameter = "@parameter@"
   Current   = "IdVds"
   Output    = "IdVds"
}

Electrode{
   { Name="source"    Voltage=0.0 }
   { Name="drain"     Voltage=0.0 }
   { Name="gate"      Voltage=1.8 }
   { Name="substrate" Voltage=0.0 }
}

Thermode{ 
  { Name="substrate" Temperature=300 SurfaceResistance=5e-4 } 
  { Name="drain" Temperature=300 SurfaceResistance=1e-3 } 
  { Name="source" Temperature=300 SurfaceResistance=1e-3 } 
}

Physics{
   Thermodynamic  
   
   Fermi
   EffectiveIntrinsicDensity( OldSlotboom )     
   Mobility(
      DopingDep
      eHighFieldsaturation( GradQuasiFermi )
      hHighFieldsaturation( GradQuasiFermi )
      Enormal
   )
   Recombination(
      SRH( DopingDep TempDependence )
   )           
}

Plot{
*--Density and Currents, etc
   eDensity hDensity
   TotalCurrent/Vector eCurrent/Vector hCurrent/Vector
   eMobility hMobility
   eVelocity hVelocity
   eQuasiFermi hQuasiFermi

*--Temperature 
   eTemperature Temperature * hTemperature

*--Fields and charges
   ElectricField/Vector Potential SpaceCharge

*--Doping Profiles
   Doping DonorConcentration AcceptorConcentration

*--Generation/Recombination
   SRH Band2Band * Auger
   AvalancheGeneration eAvalancheGeneration hAvalancheGeneration

*--Driving forces
   eGradQuasiFermi/Vector hGradQuasiFermi/Vector
   eEparallel hEparallel eENormal hENormal

*--Band structure/Composition
   BandGap 
   BandGapNarrowing
   Affinity
   ConductionBand ValenceBand
   
}

Math {
   Extrapolate
   Iterations= 20
   Notdamped= 100
   Method= Blocked
   SubMethod= Pardiso
}

Solve {
   *- Build-up of initial solution:
*-   NewCurrentPrefix="init_"
   Coupled(Iterations=100){ Poisson  }
   Coupled{ Poisson Electron Hole  }
   
   *- Bias drain to target bias
 *-  Quasistationary(
 *-     InitialStep=0.01 MinStep=1e-5 MaxStep=1
 *-     Goal{ Name="drain" Voltage= 1.8  }
 *-  ) { Coupled { Poisson Electron Hole  } }
  
   *-  gate voltage sweep
   NewCurrentPrefix="IdVds_"
   Quasistationary(
      InitialStep=1e-3 MinStep=1e-5 MaxStep=1
      Goal{ Name="drain" Voltage= 1.8 }
   ) { Coupled { Poisson Electron Hole  }
       CurrentPlot(Time=(Range=(0 1) Intervals=20))
     }
*-   System("rm init_IdVgs_des.plt")
}

