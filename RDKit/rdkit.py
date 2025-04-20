########################### 整合描述符
from rdkit import Chem
from rdkit.Chem import rdMolDescriptors,AllChem
from rdkit.Chem.EState import Fingerprinter
from rdkit.Chem.Pharm2D import Gobbi_Pharm2D, Generate
from rdkit.Chem.rdmolops import PatternFingerprint
from rdkit.Chem import rdReducedGraphs
from rdkit.Chem.rdMHFPFingerprint import MHFPEncoder

# 创建对象
from rdkit.Chem import Descriptors
from rdkit.ML.Descriptors import MoleculeDescriptors
des_list = [x[0] for x in Descriptors._descList]
calculator = MoleculeDescriptors.MolecularDescriptorCalculator(des_list)

from tqdm import tqdm
import numpy as np
import pandas as pd
import os

# 3D Descriptors
RDKit_3Ddesc_list = pd.read_csv('D:/111/jqxx/rdkit/RDKit_3Ddesc_list.csv')
Autocorr2D_list = list(np.array(RDKit_3Ddesc_list.iloc[:,0].dropna()).flatten(order='C'))
Autocorr3D_list = list(np.array(RDKit_3Ddesc_list.iloc[:,1].dropna()).flatten(order='C'))
RDF_list = list(np.array(RDKit_3Ddesc_list.iloc[:,2].dropna()).flatten(order='C'))
MORSE_list = list(np.array(RDKit_3Ddesc_list.iloc[:,3].dropna()).flatten(order='C'))
WHIM_list = list(np.array(RDKit_3Ddesc_list.iloc[:,4].dropna()).flatten(order='C'))
GETAWAY_list = list(np.array(RDKit_3Ddesc_list.iloc[:,5].dropna()).flatten(order='C'))

# Fringerprint
EStateFP_RDKit_list = ['EStateFP' + str(i) + '_RDKit' for i in range(1,80)]
EStateFPSum_RDKit_list = ['EStateSumFP' + str(i) + '_RDKit' for i in range(1,80)]
RDKFP_RDKit_list = ['RDKFP' + str(i) + '_RDKit' for i in range(1,2049)]
PharmFP_RDKit_list = ['PharmFP' + str(i) + '_RDKit' for i in range(1,39973)]
ECFPs2048_RDKit_list = ['ECFPs2048_' + str(i) + '_RDKit' for i in range(1,2049)]
ECFPs1024_RDKit_list = ['ECFPs1024_' + str(i) + '_RDKit' for i in range(1,1025)]
FCFPs2048_RDKit_list = ['FCFPs2048_' + str(i) + '_RDKit' for i in range(1,2049)]
FCFPs10_RDKit_list = ['FCFPs10_' + str(i) + '_RDKit' for i in range(1,11)]
PatternFP_RDKit_list = ['PatternFP' + str(i) + '_RDKit' for i in range(1,2049)]
ErGFP_RDKit_list = ['ErGFP' + str(i) + '_RDKit' for i in range(1,316)]
MHFP_RDKit_list = ['MHFP' + str(i) + '_RDKit' for i in range(1,2049)]
SECFP_RDKit_list = ['SECFP' + str(i) + '_RDKit' for i in range(1,2049)]
FuncFP_RDKit_list = ['FuncFP' + str(i) + '_RDKit' for i in range(1,6555)]

NameSmi = pd.read_csv('D:/test/smiles_shi.csv')
fh = open('D:/test/smiles_shi.csv')
fw1 = open('D:/test/0220517_3ndOPT_173_RDKit_1.csv','w')
fw2 = open('D:/test/20220517_3ndOPT_173_RDKit_Pharm.csv','w')
fw3 = open('D:/test/20220517_3ndOPT_173_RDKit_func.csv','w')

### 生成官能团描述符的前期准备
# from rdkit import Chem #【前面有定义】
from rdkit.Chem import RDConfig
from rdkit.Chem import FragmentCatalog
## 先将多个分子的片段汇总到一个片段存储器中
# 传入参数器，创建一个片段存储器，产生的分子片段都会存储在该对象中
fName = os.path.join(RDConfig.RDDataDir, 'FunctionalGroups.txt')#txt里有39个官能团
fparams = FragmentCatalog.FragCatParams(1, 6, fName)
fcat = FragmentCatalog.FragCatalog(fparams)
# 创建一个片段生成器：通过该对象生成片段
fcgen = FragmentCatalog.FragCatGenerator()
smi='CC#N'
mol = Chem.MolFromSmiles(smi)
print(mol)#<rdkit.Chem.rdchem.Mol object at 0x000001F3E6F23BC0>
if mol:
    fcgen.AddFragsFromMol(mol, fcat)
# 查看分子片段数量
# fcat.GetNumEntries() # 6554
## 存储器收集完所有片段后，再用它来生成分子指纹
# 创建一个片段指纹生成器
fpgen = FragmentCatalog.FragFPGenerator()

def processString(txt):
    specialChars = "[]'()" 
    for specialChar in specialChars:
        txt = txt.replace(specialChar,'')
    #print(txt)
    #txt = txt.replace(' ', '')#运行的出来，但是查看结果会让python崩溃
    return txt
    
newline_1 = "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n"%(
        'PCAS',des_list,
        Autocorr2D_list,Autocorr3D_list,
        RDF_list,MORSE_list,WHIM_list,GETAWAY_list,
        EStateFP_RDKit_list,EStateFPSum_RDKit_list,
        RDKFP_RDKit_list,
        ECFPs2048_RDKit_list,ECFPs1024_RDKit_list,
        FCFPs2048_RDKit_list,FCFPs10_RDKit_list,
        PatternFP_RDKit_list,ErGFP_RDKit_list,
        MHFP_RDKit_list,SECFP_RDKit_list,)

newline_2 = "%s,%s\n"%(
        'PCAS',PharmFP_RDKit_list,)

newline_3 = "%s,%s\n"%(
        'PCAS',FuncFP_RDKit_list,)

newline1 = processString(newline_1)
newline2 = processString(newline_2)
newline3 = processString(newline_3)

fw1.write(newline1)
fw2.write(newline2)
fw3.write(newline3)

# for循环读取SMILES，计算分子描述符，将结果写入csv文件

mol = Chem.MolFromMolFile(smi)
    #print(mol)
if mol:
        descriptors = calculator.CalcDescriptors(mol)
        Autocorr2D = rdMolDescriptors.CalcAUTOCORR2D(mol)
        #Autocorr3D = rdMolDescriptors.CalcAUTOCORR3D(mol)
        #RDF = rdMolDescriptors.CalcRDF(mol)
        #MORSE = rdMolDescriptors.CalcMORSE(mol)
        #WHIM = rdMolDescriptors.CalcWHIM(mol)
        #GETAWAY = rdMolDescriptors.CalcGETAWAY(mol)
        
        EStateFP = Fingerprinter.FingerprintMol(mol)
        EStateFP_counts_vector = list(EStateFP[0])
        EStateFP_sums_vector = list(EStateFP[1])

        RDK = Chem.RDKFingerprint(mol)
        RDK_vector = [int(i) for i in RDK.ToBitString()]
        
        Pharm = Generate.Gen2DFingerprint(mol, Gobbi_Pharm2D.factory)
        Pharm_vector = [int(i) for i in Pharm.ToBitString()]
        
        ECFPs2048 = AllChem.GetMorganFingerprintAsBitVect(mol, 2)
        ECFPs2048_vector = [int(i) for i in ECFPs2048.ToBitString()]
        ECFPs1024 = AllChem.GetMorganFingerprintAsBitVect(mol, 2, nBits=1024)
        ECFPs1024_vector = [int(i) for i in ECFPs1024.ToBitString()]
        FCFPs2048 = AllChem.GetMorganFingerprintAsBitVect(mol, 2, useFeatures=True)
        FCFPs2048_vector = [int(i) for i in FCFPs2048.ToBitString()]
        FCFPs10 = AllChem.GetMorganFingerprintAsBitVect(mol, 2, useFeatures=True, nBits=10)
        FCFPs10_vector = [int(i) for i in FCFPs10.ToBitString()]
        
        PatternFP = PatternFingerprint(mol)
        PatternFP_vector = [int(i) for i in PatternFP.ToBitString()]
        
        ErGFP = rdReducedGraphs.GetErGFingerprint(mol) # Array of float64
        ErGFP_vector = list(ErGFP)
        
        # 创建MHFP编译器
        a = MHFPEncoder()
        # MHFP长度是2048，但是数值不是01二分
        MHFP = MHFPEncoder.EncodeMol(a,mol)
        MHFP_vector = [int(i) for i in MHFP]
        # SECFP binary vector
        SECFP = MHFPEncoder.EncodeSECFPMol(a,mol)
        SECFP_vector = [int(i) for i in SECFP.ToBitString()]
        
        #FuncFP = fpgen.GetFPForMol(mol, fcat)
        #FuncFP_vector = [int(i) for i in FuncFP.ToBitString()]
        
else:
        descriptors = ['NA']*len(des_list)
        Autocorr2D = ['NA']*len(Autocorr2D_list)
        Autocorr3D = ['NA']*len(Autocorr3D_list)
        RDF = ['NA']*len(RDF_list)
        MORSE = ['NA']*len(MORSE_list)
        WHIM = ['NA']*len(WHIM_list)
        GETAWAY = ['NA']*len(GETAWAY_list)
        
        EStateFP_counts_vector = ['NA']*len(EStateFP_RDKit_list)
        EStateFP_sums_vector = ['NA']*len(EStateFPSum_RDKit_list)
        
        RDK_vector = ['NA']*len(RDKFP_RDKit_list)
        
        Pharm_vector = ['NA']*len(PharmFP_RDKit_list)
        
        # Morgan Fingerprints
        ECFPs2048_vector = ['NA']*len(ECFPs2048_RDKit_list)
        ECFPs1024_vector = ['NA']*len(ECFPs1024_RDKit_list)
        FCFPs2048_vector = ['NA']*len(FCFPs2048_RDKit_list)
        FCFPs10_vector = ['NA']*len(FCFPs10_RDKit_list)
        
        PatternFP_vector = ['NA']*len(PatternFP_RDKit_list)
        
        ErGFP_vector = ['NA']*len(ErGFP_RDKit_list)
        
        MHFP_vector = ['NA']*len(MHFP_RDKit_list)
        SECFP_vector = ['NA']*len(SECFP_RDKit_list)
        
        FuncFP_vector = ['NA']*len(FuncFP_RDKit_list)

    newline_1 = "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n"%(
                                        name,descriptors,
                                        Autocorr2D,#Autocorr3D,RDF,
                                        #MORSE,WHIM,GETAWAY,
                                        EStateFP_counts_vector,EStateFP_sums_vector,
                                        RDK_vector,
                                        ECFPs2048_vector,ECFPs1024_vector,
                                        FCFPs2048_vector,FCFPs10_vector)
                                        #PatternFP_vector,ErGFP_vector）#,
                                        #MHFP_vector,SECFP_vector,)
    newline_2 = "%s,%s\n"%(
            name,Pharm_vector,)
    newline_3 = "%s,%s\n"%(
            name,FuncFP_vector,)
    
    newline1 = processString(newline_1)
    newline2 = processString(newline_2)
    newline3 = processString(newline_3)

    fw1.write(newline1)
    fw2.write(newline2)
    fw3.write(newline3)

fw1.close()
fw2.close()
fw3.close()

#包含的特征个数：61622