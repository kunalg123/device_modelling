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
init concentration=1.0e+15<cm-3> field=Phosphorus wafer.orient=100

#Boron implants
implant Boron dose=2.0e13<cm-2> energy=200<keV> tilt=0 rotation=0
implant Boron dose=1.0e13<cm-2> energy=80<keV> tilt=0 rotation=0
implant Boron dose=2.0e12<cm-2> energy=25<keV> tilt=0 rotation=0

#Growing gate oxide
mgoals on accuracy=3<nm>
gas_flow name=O2_1_N2_1 pressure=1<atm> \
        flowO2=1.2<l/min> flowN2=1.0<l/min>
diffuse temperature=850<C> time=10.0<min> gas_flow=O2_1_N2_1
grid remesh
select z=Boron
layers

#Defining polysilicon gate
deposit poly type=anisotropic thickness=0.18<um>
mask name=gate_mask left=-1 right=90<nm>
etch poly type=anisotropic thickness=0.2<um> mask=gate_mask
etch oxide type=anisotropic thickness=0.1<um>

#Working with masks
mask clear
mask name=imp_mask left=-1.0<um> right= 2.0<um>
mask name=imp_mask left= 4.0<um> right=20.0<um>

implant Boron mask=imp_mask dose=2e13<cm-2> energy=30<keV>

#Polysilicon reoxidation
diffuse temperature=900<C> time=10.0<min> O2 pressure=0.5<atm> \
mgoals.native

struct tdr=NMOS4

#Remeshing for LDD and halo implants
refinebox silicon min= {0.0 0.05} max= {0.1 0.12} \
xrefine= {0.01 0.01 0.01} yrefine= {0.01 0.01 0.01} add
refinebox remesh

#LDD and halo implants
implant Arsenic dose=4e14<cm-2> energy=10<keV> tilt=0 rotation=0

implant Boron dose=0.25e13<cm-2> energy=20<keV> \
tilt=30<degree> rotation=0
implant Boron dose=0.25e13<cm-2> energy=20<keV> \
tilt=30<degree> rotation=90<degree>
implant Boron dose=0.25e13<cm-2> energy=20<keV> \
tilt=30<degree> rotation=180<degree>
implant Boron dose=0.25e13<cm-2> energy=20<keV> \
tilt=30<degree> rotation=270<degree>

diffuse temperature=1050<C> time=5.0<s>

#Spacer formation
deposit nitride type=isotropic thickness=60<nm>
etch nitride type=anisotropic thickness=84<nm>
etch oxide type=anisotropic thickness=10<nm>

#Remeshing for source/drain implants
refinebox silicon min= {0.04 0.05} max= {0.18 0.4} \
xrefine= {0.01 0.01 0.01} yrefine= {0.05 0.05 0.05} add
refinebox remesh

#Source/drain implants
implant Arsenic dose=5e15<cm-2> energy=40<keV> \
tilt=7<degree> rotation=-90<degree>
diffuse temperature=1050<C> time=10.0<s>

#Contact pads
deposit Aluminum type=isotropic thickness=30<nm>

mask name=contacts_mask left=0.2<um> right=1.0<um>
etch Aluminum type=anisotropic thickness=0.25<um> mask=contacts_mask
etch Aluminum type=isotropic thickness=0.02<um> mask=contacts_mask

#Saving the full structure
transform reflect left
struct smesh=NMOS
#struct ise.mdraw=NMOS
