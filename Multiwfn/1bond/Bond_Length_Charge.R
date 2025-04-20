# -2 to -1 出错
# Collect Bond length Charge

# Clear all variables
rm(list = ls(all=TRUE))
# close all figures
graphics.off() 

library(stringr)
library(plyr)

# List chg files from directory, extract chemical name
data=dir(path="F:/2ndALL/0 Gaussian16计算文件/HF_N_fchk/ADCH Charges/", pattern="\\.chg")

# Remove extension, leading p
data=gsub(".chg","",data)
chemical=gsub("p","",data)

#Build the data frame df
df=data.frame(chemical)

df$Warning=NA
df$FBOError=NA
df$Radialpo=NA
df$Angularpo=NA
df$FBOmax=NA
df$FBOmin=NA
df$FBOmin5=NA #补充Bond>5min

df$QCPositivemax=NA
df$QCNegativemax=NA #补充C-max
df$QCNegativemin=NA
df$QHPositivemax=NA

df$LccMax=NA
df$LccMin=NA
df$LccAver=NA

# Loop through all chg and txt files in directory
for (i in 1:length(chemical)){
  
  #     Scan in each chg and txt file
  fpchg <- paste("F:/2ndALL/0 Gaussian16计算文件/HF_N_fchk/ADCH Charges/p", chemical[i], ".chg", sep="")
  fptxt <- paste("F:/2ndALL/0 Gaussian16计算文件/HF_N_fchk/Bond_Length/p", chemical[i], "_Bond_Length_Chargenouse.txt", sep="")  
  
  chgfile <- scan(file=fpchg, what=character(), sep="\n")
  txtfile <- scan(file=fptxt, what=character(), sep="\n")
  
  # Index current chemical in data frame
  rindx = grep(paste("^",chemical[i],"$",sep=""),df$chemical)
  
  # collect accuracy of FBO-Calculation
  Err = grep("Error of AOM is", txtfile)  
  Warn = grep("Warning", txtfile)
  Radial = grep("Radial points", txtfile)
  Angular = grep("Angular points", txtfile)
  
  Errnum = as.numeric(gsub(x=str_sub(string=txtfile[Err], start=-10), pattern=" ", replacement=""))
  Radialponum = as.numeric(gsub(x=str_sub(string=txtfile[Radial], start=16, end=24), pattern=" ", replacement=""))
  Angularponum = as.numeric(gsub(x=str_sub(string=txtfile[Angular], start=40, end=47), pattern=" ", replacement=""))
  
  df$Warning[rindx] = length(Warn)
  df$Radialpo[rindx] = Radialponum
  df$Angularpo[rindx] = Angularponum
  df$FBOError[rindx] = Errnum
    
  # collect Fuzzy Bond order
  Bondorder1 = grep("The total bond order", txtfile)
  Bondorder1 = Bondorder1+1
  Bondorder2 = grep("If outputting bond order matrix to bndmat", txtfile)
  Bondorder2 = Bondorder2-2
  # 做for循环前，一定要先定义变量
  BondOrder =NULL
  BondOrder5 =NULL
  k = 0
  for (j in Bondorder1:Bondorder2){
    BondOrder[j] = as.numeric(gsub(x=str_sub(string=txtfile[j], start=-10), pattern=" ", replacement=""))     
    
	#单独提取出BondOrder>0.5的Bond order为一个向量
	if (BondOrder[j]>0.5){
	BondOrder5[k] = BondOrder[j]
	k = k + 1}
	}
	
	df$FBOmin5[rindx]= min(BondOrder5)
  FBOmaxnum = max(BondOrder[Bondorder1:Bondorder2])
  FBOminnum = min(BondOrder[Bondorder1:Bondorder2])
  df$FBOmax[rindx] = FBOmaxnum
  df$FBOmin[rindx] = FBOminnum
  
  # collect Charge of C and H
  C = grep("C ", chgfile)
  H = grep("H", chgfile)
  Qc = NULL
  Qh = NULL
  m = 0
  QcNegative = NULL
  for (j in C){
    Qc[j] = as.numeric(gsub(x=str_sub(string=chgfile[j], start=-13), pattern=" ", replacement=""))     
	
	#单独提取出Qc<0的电荷为一个向量
	if (Qc[j]<0){
	QcNegative[m] = Qc[j]
	m = m + 1}
	}
	df$QCNegativemax[rindx] = max(QcNegative)#如果向量只有一个值，不会输出，会显示=inf
	
  for (j in H){
    Qh[j] = as.numeric(gsub(x=str_sub(string=chgfile[j], start=-13), pattern=" ", replacement=""))     
	}
  Qcmax = max(Qc[C])
  Qcmin = min(Qc[C])
  Qhmax = max(Qh[H])
  df$QCPositivemax[rindx] = Qcmax
  df$QCNegativemin[rindx] = Qcmin
  df$QHPositivemax[rindx] = Qhmax
  
  # collect Length of C C
  Lmax = grep("Maximum length", txtfile)
  Lmin = grep("Minimum length", txtfile)
  Laver = grep("Average bond length between C  C  is", txtfile)
  Lmaxnum = as.numeric(gsub(x=str_sub(string=txtfile[Lmax], start=23, end=30), pattern=" ", replacement=""))
  Lminnum = as.numeric(gsub(x=str_sub(string=txtfile[Lmin], start=23, end=30), pattern=" ", replacement=""))
  Lavernum = as.numeric(gsub(x=str_sub(string=txtfile[Laver], start=-17, end=-10), pattern=" ", replacement=""))
  df$LccMax[rindx] = Lmaxnum
  df$LccMin[rindx]= Lminnum
  df$LccAver[rindx]= Lavernum
	
	
}
write.csv(df, file="F:/2ndALL/0 Gaussian16计算文件_替换2分子/Chg_txt_bond_length_charge_173_to.csv", row.names=F)
