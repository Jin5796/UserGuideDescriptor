# UserGuideDescriptor
##################################Multiwfn#############################################
1. Preparation
Download and install Multiwfn version 3.7 from the official website (http://sobereva.com).

 2. Calculation of Bond, Supredelocalizability, Surface, and Weight Descriptors
(1) Place the following files in the same working directory:

Multiwfn.exe, Multiwfn.ini, and all required .dll files from the Multiwfn installation folder.

The .fchk files of the target molecules (these should be obtained from Gaussian optimization).

The batch script Bond_Length_Charge.bat and the input configuration file Bond_Length_Charge.txt.

(2) Run Bond_Length_Charge.bat by double-clicking it. This will generate corresponding output files for each compound, including .txt and .chg files.

(3) Use the Bond_Length_Charge.R script to extract relevant information from the output files and compile the descriptors into a .csv file.

(4) The procedures for calculating supredelocalizability, surface, and weight descriptors are similar and follow the same steps as above.

3. Calculation of FED Descriptors
(1) Place the following files in a single directory:

Multiwfn.exe, Multiwfn.ini, and all necessary .dll files.

The .fchk files of the target molecules.

The batch script 1LOMO_HOMO.bat and the input file 1LOMO_HOMO.txt.

(2) Execute 1LOMO_HOMO.bat to generate the intermediate files pxxx_LOMO_HOMO.txt.

(3) Modify the directory path in 1LOMO_HOMO.R and run the script to extract orbital information from pxxx_LOMO_HOMO.txt (make sure no other .txt files are present in the folder). This will produce the file LOMO_HOMO_140_orbital.csv.

(4) Use 2Multiwfn_FED_LUMOHOMO.R to generate pxxx_FED_SPN.txt.

(5) Place pxxx_FED_SPN.txt, 3FED_SPN.txt, 3FED_SPN.bat, and the corresponding .fchk files in the same folder. Run 3FED_SPN.bat to generate the output file pxxx_FED.txt.

(6) Finally, use 4FED.R to extract information from pxxx_FED.txt and generate the final descriptor file txt_FED_140.csv.

4. Frequency Descriptor Extraction
(1) Place all Gaussian frequency calculation .log files in a single directory. Use the From_3ndOPT_Freq_Log.R script to extract frequency-related descriptors such as HF3ndOPT and Gibbs free energy.

(2) Use the Log_Read_irac_v3_adjed_Condensed.R script to extract orbital descriptors such as LUMO and HOMO.


##################################PaDEL#############################################
1. Software Installation and Environment Setup
(1) Install Java and Anaconda, and configure a virtual environment with the required Python libraries, including:
keras, numpy, openbabel, pandas, rdkit, scikit-learn, and tqdm.

For Anaconda installation guidance, refer to: CSDN Tutorial

For usage instructions, refer to: Jianshu Tutorial

(2) Conversion of .fchk to .mol Files
Open the Anaconda Prompt, navigate to the directory containing the .fchk files and the batch script OpenBabel_fchk_to_mol.bat, and execute the script by typing:  OpenBabel_fchk_to_mol.bat

This will convert all .fchk files in the directory into .mol format using Open Babel.

(3) Running PaDEL-Descriptor via Command Line
Open the Command Prompt (Win + R → type cmd) and change the drive and directory to the location of the .jar file.

(4) Descriptor and Fingerprint Generation
In the PaDEL-Descriptor interface:

Select the folder containing the .mol files as input.

Specify the output .csv file path.

Check all options under the 1D & 2D, 3D, and Fingerprints tabs.

Click Start to compute and export the 2D, 3D descriptors and molecular fingerprints separately.

##################################RDKit#############################################
The RDKit molecular descriptors were calculated by running the rdkit.py script in Spyder. After modifying the code as required, the script was executed to produce three output .csv files containing the descriptor data.
The content of **RKDit_173.csv** should be replaced with the actual compounds to be calculated as needed; the file is provided as a template only.
