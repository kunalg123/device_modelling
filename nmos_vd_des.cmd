File {
* input files:
Grid = "nmos_final_fps.tdr"
* output files:
Plot = "nmosVd_SIM"
Current = "nmosVd_SIM"
Output = "nmosVd_SIM"
}

Electrode{
{ Name="source" Voltage=0.0 }
{ Name="drain" Voltage=0.0 }
{ Name="gate" Voltage=1.8 }
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
RelErrControl
}

Solve {
# initial solution
Poisson
Coupled { Poisson Electron }
# ramp gate 
Quasistationary ( Maxstep=0.05 
Goal { name="drain" voltage=1.8 } )
{ Coupled { Poisson Electron } }
}



