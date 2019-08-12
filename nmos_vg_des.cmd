File {
* input files:
Grid = "nmos_final_fps.tdr"
* output files:
Plot = "nmosVg_SIM"
Current = "nmosVg_SIM"
Output = "nmosVg_SIM"
}

Electrode{
{ Name="source" Voltage=0.0 }
{ Name="drain" Voltage=1.8 }
{ Name="gate" Voltage=0.0 }
{ Name="substrate" Voltage=0.0 }
}

Physics {
Mobility (PhuMob HighFieldSat Enormal)
EffectiveIntrinsicDensity (BandGapNarrowing (OldSlotboom))
Recombination(eBarrierTunneling(Band2Band TwoBand Transmission) hBarrierTunneling (Band2Band TwoBand Transmission) )
}

Plot {
eDensity hDensity eCurrent hCurrent
Potential SpaceCharge ElectricField
eMobility hMobility eVelocity hVelocity
Doping DonorConcentration AcceptorConcentration
}

Math {
Extrapolate
Derivatives
RelErrControl
}

Solve {
# initial solution
Poisson
Coupled { Poisson Electron }
# ramp gate 
Quasistationary ( Maxstep=0.05 
Goal { name="gate" voltage=1.8 } )
{ Coupled { Poisson Electron } }
}



