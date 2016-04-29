# -*- coding: utf-8 -*-
"""
Created on Fri Apr 15 10:10:15 2016

@author: Steven_Pellizzeri (spelliz[@]clemson.edu)
"""
from ase.atoms import string2symbols
from ase.thermochemistry import HarmonicThermo,IdealGasThermo
from ase.io import write, read
from glob import glob

## user input
shape = "nonlinear"      ## strucutre shape
symnum = 1              ## symmetry number
spin = 6                 ## spin number
temp = 298.15            ## temperature in K
pres = 101325        ## pressure in Pa

RMFREQ_KbT = "True" ## Remove frequencies below KbT cutoff

## conversion factors
HarttoeV = float(27.2114)
CmtoeV = float(1.239842E-4)

## get log file name

file_list = glob('*.log')
log_file = file_list[0]

## get SCF energy from the log file
Energy = []
infile = open(log_file)
for line in infile:
    if "SCF Done:" in line:
        Energy.append(line)
infile.close()

final_energy = Energy[-1]
scf_energy_hartree = float(final_energy.split(" ")[7])
scf_energy_eV = scf_energy_hartree * HarttoeV


## get the frequencies from the frequencies.dat file"
Freq = []
freq_file = open("frequencies.dat")
raw_freq = freq_file.read().replace('[', ' ').replace(']', ' ').split()[-1]
for i in raw_freq.split(','):
    Freq.append(float(i)*CmtoeV)

for i in Freq:
    if i <= 0:
        Freq.remove(i)

freq_kbt_cutoff = float(8.6173324E-5 * temp)

freq_remove = []

if RMFREQ_KbT == "True":
    for i in Freq:
        if i <= freq_kbt_cutoff:
            freq_remove.append(i)
    for i in freq_remove:
        if i in Freq:
            Freq.remove(i)

## get the strucuter from the output file
struc = read(log_file,format='gaussian-out')

## get the ideal gas limit thermodynamic values
thermo = IdealGasThermo(vib_energies=Freq, potentialenergy=scf_energy_eV,
                        atoms=struc, geometry=shape,
                        symmetrynumber=symnum, spin=spin)

print "Ideal Gas Limit"

ZPE = thermo.get_ZPE_correction()
H = thermo.get_enthalpy(temperature=temp)
S = thermo.get_entropy(temperature=temp,pressure=pres)
G = thermo.get_gibbs_energy(temperature=temp,pressure=pres)

print " "
print "ZPE correction (ZPE) = ", ZPE, " eV"
print "Ethalpy (H) = ", H, " eV"
print "Entropy (S) = ", S, " eV/K"
print "Gibbs Energy (G) = ", G, " eV"

## get the harmonic limit thermodynamic values
thermo = HarmonicThermo(vib_energies=Freq, potentialenergy=scf_energy_eV)

print
print "Harmonic Approximation"

ZPE = thermo.get_ZPE_correction()
U = thermo.get_internal_energy(temperature=temp)
S = thermo.get_entropy(temperature=temp)
H = thermo.get_helmholtz_energy(temperature=temp)

print " "
print "ZPE correction (ZPE) = ", ZPE , " eV"
print "Internal energy (U) = ", U, " eV"
print "Entropy (S) = ", S, " eV/K"
print "Helmholtz Energy (F) = ", F, " eV"
