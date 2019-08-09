AdvancedCalibration
#Defining an initial 1D grid
line x location=0.0 spacing=1<nm> tag=SiTop
line x location=10<nm> spacing=2<nm>
line x location=50<nm> spacing=10<nm>
line x location=300<nm> spacing=20<nm>
line x location=0.5<um> spacing=50<nm>
line x location=2.0<um> spacing=0.2<um> tag=SiBottom

#Defining initial simulation domain
region silicon xlo=SiTop xhi=SiBottom

#Initializing the simulation
init concentration=1.0e15<cm-3> field=Boron

#Setting up an MGOALS meshing strategy
mgoals on accuracy=3<nm>

#Growing screening oxide
gas_flow name=O2_1_N2_1 pressure=1<atm> \
flowO2=1.2<l/min> flowN2=1.0<l/min>
diffuse temperature=900<C> time=40<min> gas_flow=O2_1_N2_1
grid remesh

#Measuring oxide thickness
select z=Boron
layers

#Depositing screening oxide
deposit Oxide type=isotropic thickness=10.0<nm>
diffuse temperature=900<C> time=40<min>

#Implantation
implant Arsenic energy=50<keV> dose=1e14<cm-2> tilt=7<degree> rotation=0<degree>

#Saving the as-implanted profile
SetPlxList { BTotal Arsenic_Implant }
WritePlx 1DasImpl.plx

#Thermal annealing, drive-in, activation, and screening oxide strip
diffuse temperature=1000<C> time=30<min>
strip oxide
SetPlxList { BTotal BActive AsTotal AsActive }
WritePlx 1Danneal.plx
struct tdr=nmos1d
