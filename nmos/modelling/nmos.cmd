AdvancedCalibration
#Defining Initial 2D Grid and Simulation Domain
line x location= 0.0      spacing= 1.0<nm>  tag=SiTop        
line x location=50.0<nm>  spacing=10.0<nm>                    
line x location= 0.5<um>  spacing=50.0<nm>                      
line x location= 2.0<um>  spacing= 0.2<um>                       
line x location= 4.0<um>  spacing= 0.4<um>                       
line x location=10.0<um>  spacing= 2.0<um>  tag=SiBottom   

line y location=0.0       spacing=50.0<nm>  tag=Mid         
line y location=0.40<um>  spacing=50.0<nm>  tag=Right       

region Silicon xlo=SiTop xhi=SiBottom ylo=Mid yhi=Right

init concentration=1.0e+15<cm-3> field=Phosphorus

#Boron Implantations
implant  Boron  dose=2.0e13<cm-2>  energy=200<keV> tilt=0 rotation=0  
implant  Boron  dose=1.0e13<cm-2>  energy= 80<keV> tilt=0 rotation=0  
implant  Boron  dose=2.0e12<cm-2>  energy= 25<keV> tilt=0 rotation=0

#Growing Gate Oxide
grid set.min.normal.size=1<nm> set.normal.growth.ratio.2d=1.5

diffuse temperature=1050<C> time=10.0<s>   

select z=1
layers

#Defining Polysilicon Gate
deposit material= {PolySilicon} type=anisotropic time=1 rate= {0.18}

mask name=gate_mask left=-1 right=90<nm>
etch material= {PolySilicon} type=anisotropic time=1 rate= {0.2} mask=gate_mask
etch material= {Oxide}       type=anisotropic time=1 rate= {0.1}

#Polysilicon Reoxidation
diffuse temperature=900<C> time=10.0<min>  O2 
pdbSet Oxide Grid perp.add.dist 1e-7

#Saving Snapshots
struct tdr=n1node1_NMOS1  ; # p-Well

#Remeshing for LDD and Halo Implantations
refinebox Silicon min= {0.0 0.05} max= {0.1 0.12} xrefine= {0.01 0.01 0.01} \
                                                  yrefine= {0.01 0.01 0.01} add
refinebox remesh

#LDD and Halo Implantations
implant Arsenic dose=4e14<cm-2> energy=10<keV> tilt=0 rotation=0  

implant Boron dose=0.25e13<cm-2> energy=20<keV> tilt=30<degree> \
              rotation=0            
implant Boron dose=0.25e13<cm-2> energy=20<keV> tilt=30<degree> \
              rotation=90<degree>   
implant Boron dose=0.25e13<cm-2> energy=20<keV> tilt=30<degree> \
              rotation=180<degree>  
implant Boron dose=0.25e13<cm-2> energy=20<keV> tilt=30<degree> \
              rotation=270<degree>  

diffuse temperature=1050<C> time=0.1<s> ; # Quick activation 

#Spacer Formation
deposit material= {Nitride} type=isotropic   time=1 rate= {0.06}
etch    material= {Nitride} type=anisotropic time=1 rate= {0.084} \
				isotropic.overetch=0.01
etch    material= {Oxide}   type=anisotropic time=1 rate= {0.01} 

#Remeshing for Source-Drain Implantations
refinebox Silicon min= {0.04 0.12} max= {0.18 0.4} xrefine= {0.01 0.01 0.01} \
                                                   yrefine= {0.05 0.05 0.05} add
refinebox remesh
#implant Arsenic dose=5e15<cm-2> energy=40<keV> 

#Source-Drain Implantations
implant Arsenic dose=5e15<cm-2> energy=40<keV> 
diffuse temperature=1050<C> time=10.0<s> 

#Contact Pads
deposit material= {Aluminum} type=isotropic time=1 rate= {0.03}

mask name=contacts_mask left=0.2<um> right=1.0<um>
etch material= {Aluminum} type=anisotropic time=1 rate= {0.25} \
     mask=contacts_mask


#Saving the Full Structure
transform reflect left
contact name="substrate" bottom Silicon
contact name="source" box Silicon xlo=0.0 xhi=0.005 ylo=-0.4 yhi=-0.2
contact name="drain" box Silicon xlo=0.0 xhi=0.005 ylo=0.2 yhi=0.4
contact name="gate" box PolySilicon xlo=-0.181 xhi=-0.05 ylo=-0.088 yhi=0.088
 
struct tdr= n1node1_NMOS ; # Final

#Extracting 1D Profiles
SetPlxList   {BTotal NetActive}
WritePlx n1node1_NMOS_channel.plx  y=0.0 Silicon
SetPlxList   {AsTotal BTotal NetActive}
WritePlx n1node1_NMOS_ldd.plx y=0.1 Silicon
SetPlxList   {AsTotal BTotal NetActive}
WritePlx n1node1_NMOS_sd.plx y=0.39 Silicon


