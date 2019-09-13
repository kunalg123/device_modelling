AdvancedCalibration
#Defining an initial 1D grid
line x location=0.0 spacing=1<nm> tag=SiTop
line x location=50<nm> spacing=10<nm>
line x location=0.5<um> spacing=50<nm>
line x location=2.0<um> spacing=0.2<um>
line x location=4.0<um> spacing=0.4<um>
line x location=10.0<um> spacing=2.0<um> tag=SiBottom

line y location=0.0 spacing=50.0<nm> tag=Mid
line y location=0.40<um> spacing=50.0<nm> tag=Right

#Defining simulation domain and initializing simulation
region silicon xlo=SiTop xhi=SiBottom ylo=Mid yhi=Right

#initialize simulation
init concentration=1.0e+15<cm-3> field=Phosphorus wafer.orient=100

#refinement in vertical direction
refinebox clear
refinebox min = 0 max = 50.0<nm> xrefine = {2.0<nm> 10.0<nm>}
refinebox min = 50.0<nm> max = 2.0<um> xrefine = {10.0<nm> 0.1<um> 0.2<um>}
refinebox min = 2.0<um> max = 10.0<um> xrefine = {0.2<um> 2.0<um>}

#interface refinement
refinebox interface.materials = {Oxide Silicon}

#SnMesh settings for automatic meshing in newly generated layers
pdbSet Grid SnMesh min.normal.size 1.0e-3
pdbSet Grid SnMesh normal.growth.ratio.2d 1.4

#n-well, anti-punchthrough & Vt adjustment implants
implant Phosphorus dose=1.0e16<cm-2> energy=300<keV> tilt=0 rotation=0
implant Arsenic dose=1.0e12<cm-2> energy=100<keV> tilt=0 rotation=0
implant Arsenic dose=1.0e12<cm-2> energy=100<keV> tilt=0 rotation=0

#n-well: RTA of channel implants
diffuse temperature=1050<C> time=20.0<s>

#Saving structure
struct tdr=1_Pwell FullD; # p-well

#Growing gate oxide
diffuse temperature=800<C> time=120.0<min> O2
select z=1
layers
struct tdr=2_Oxidation FullD; # GateOx

#Defining polysilicon gate
deposit poly type=isotropic thickness=0.4<um>
implant Phosphorus dose=5e15<cm-2> energy=60<keV> tilt=0 rotation=0

#Poly gate pattern/etch
mgoals accuracy=2e-5
mask name=gate_mask segments = {-1 90<nm>}
etch poly type=anisotropic thickness=0.5<um> mask=gate_mask
etch oxide type=anisotropic thickness=0.1<um>
struct tdr=3_Polygate ; # Polygate

#Poly reoxidation
diffuse temperature=900<C> time=10.0<min> O2 pressure=0.5<atm>
struct tdr=4_Polyreox ; #Poly Reox

#LDD implantation
refinebox silicon min = {0.0 0.045<um>} max = {0.1<um> 0.125<um>} xrefine= 0.01<um> yrefine=0.01<um>
grid remesh
implant Boron dose=5e13<cm-2> energy=10<keV> tilt=0 rotation=0
diffuse temperature=1050<C> time=0.1<s>; # Quick activation
struct tdr=5_LDD ; # LDD Implant

#Halo implantation: Quad HALO implants
diffuse temperature=1050<C> time=5.0<s>
struct tdr=6_Halo ; # Halo RTA

#Nitride spacer
deposit nitride type=isotropic thickness=60<nm>
etch nitride type=anisotropic thickness=84<nm> isotropic.overetch=0.01
etch oxide type=anisotropic thickness=10<nm>
struct tdr=7_Spacer  ; # Spacer

#P+ implantation 
refinebox silicon min= {0.04 0.11} max= {0.18 0.4} xrefine= 0.01<um> yrefine= {0.02<um> 0.05<um>}
grid remesh
implant Boron dose=3e15<cm-2> energy=5<keV> tilt=7<degree> rotation=-90<degree>

#P+ implantation and final RTA
diffuse temperature=1050<C> time=10.0<s>
struct tdr=8_Source ; # S/D implants

#Remove bottom of structure
transform cut location=1.00 down

#Reflect
transform reflect left

#Contact pads
contact name="substrate" bottom Silicon
contact name="source" box Silicon xlo=0.0 xhi=0.005 ylo=-0.4 yhi=-0.2
contact name="drain" box Silicon xlo=0.0 xhi=0.005 ylo=0.2 yhi=0.4
contact name="gate" box PolySilicon xlo=-0.5 xhi=-0.05 ylo=-0.088 yhi=0.088

#Final
struct smesh=pmos_final
