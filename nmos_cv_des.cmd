File {
* input files:
Grid = "nmos_final_fps.tdr"
* output files:
Plot = "nmosCAP_SIM"
Current = "nmosCAP_SIM"
Output = "nmosCAP_SIM"
ACExtract = "nmoscv_des"
}

Device nmos_final_fps {
Electrode{
{ Name="source" Voltage=0.0 }
{ Name="drain" Voltage=0.0 }
{ Name="gate" Voltage=0.0 }
{ Name="substrate" Voltage=0.0 }
}
}

Physics {
Mobility (DopingDep HighFieldSaturation Enormal)
EffectiveIntrinsicDensity (OldSlotboom)
*Recombination (SRH Auger Avalanche)
}

System{
nmos_final_fps nmos_1 ("source"=0 "drain"=0 "gate"=gate substrate=substrate)
 Vsource_pset vA (gate 0) {dc=0}
 Vsource_pset vC (substrate 0) {dc=0}
 *Capacitor_pset cout ( G B )
 *Plot moscap_des.plt
}

Plot {
eDensity hDensity eCurrent hCurrent
ElectricField eEparallel hEparallel
eQuasiFermi hQuasiFermi
Potential SpaceCharge
ConductionBandEnergy ValenceBandEnergy
eQuasiFermiEnergy eQuasiFermiPotential
hQuasiFermiEnergy hQuasiFermiPotential
SRHRecombination Auger AvalancheGeneration
eMobility hMobility eVelocity hVelocity
Doping DonorConcentration AcceptorConcentration
}

Math {
Number_Of_Threads=1
Extrapolate
Derivatives
Iterations=20
RelErrControl
Digits=5
Method=ILS
NotDamped=50
Transient=BE
}

Solve {
#-build up initial solution
NewCurrentPrefix = "init"
Coupled(Iterations=100) { Poisson }
Coupled{ Poisson Electron Hole }
Quasistationary ( InitialStep=0.1 Increment=1.3 MinStep=1e-5 MaxStep=0.05
Goal { Parameter=vA.dc Voltage=-3 }
)
{ Coupled { Poisson Electron Hole } }
NewCurrentPrefix = ""
Quasistationary ( InitialStep=0.1 Increment=1.3 MinStep=1e-5 MaxStep=0.05
Goal { Parameter=vA.dc Voltage=3 }
)


{ACCoupled (
StartFrequency=1000 EndFrequency=1000 NumberOfPoints=1 Decade
Node(gate substrate) *Exclude(vA vC)
ACCompute (Time=(Range=(0 1) Intervals=20))) {Poisson Electron Hole} }
}



