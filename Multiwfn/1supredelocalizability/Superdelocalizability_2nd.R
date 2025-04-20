# superdelocalizability_2nd

# Clear all variables
rm(list = ls(all=TRUE))
# close all figures
graphics.off() 

library(stringr)
library(plyr)

# List txt files from directory, extract chemical name  注：Chemical 为了对应做了一些调整
data=dir(path="F:/2ndALL/0 Gaussian16计算文件_替换2分子/Super/", pattern="\\_Superdelocalizability_2nd.txt")

# Remove extension, leading p
data=gsub("_Superdelocalizability_2nd.txt","",data)
Chemical=gsub("p","",data)

df=data.frame(Chemical)
  df$DNmaxatom = NA
  df$DNmax = NA
  
  df$DNminatom = NA
  df$DNmin = NA
  
  df$DEmaxatom = NA
  df$DEmax = NA
  
  df$DEminatom = NA
  df$DEmin = NA
  
  df$DN0maxatom = NA
  df$DN0max = NA
  
  df$DN0minatom = NA
  df$DN0min = NA
  
  df$DE0maxatom = NA
  df$DE0max = NA
  
  df$DE0minatom = NA
  df$DE0min = NA
  
df$TDN = NA
df$TDE = NA
df$TDN0 = NA
df$TDE0 = NA

#最大最小值 同时对应多个原子
df$Repeat = NA
  
# Loop through all txt files in directory
for (i in 1:length(Chemical)){
  
  #     Scan in each txt file
  fptxt <- paste("F:/2ndALL/0 Gaussian16计算文件_替换2分子/Super/p", Chemical[i], "_Superdelocalizability_2nd.txt", sep="")

  txtfile <- scan(file=fptxt, what=character(), sep="\n")
  
  # Index current chemical in data frame
  rindx = grep(paste("^",Chemical[i],"$",sep=""),df$Chemical)
  
  # set point
  Con1 = grep("D_E_0: Electrophilic superdelocalizability without alpha parameter", txtfile)
  Con2 = grep("Sum of D_N:", txtfile)
  TDN = Con2
  TDE = Con2+1
  TDN0 = Con2+2
  TDE0 = Con2+3

  # Collect Total value
  df$TDN[rindx] = as.numeric(gsub(x=str_sub(string=txtfile[TDN], start=-27, end=-9), pattern=" ", replacement=""))
  df$TDE[rindx] = as.numeric(gsub(x=str_sub(string=txtfile[TDE], start=-27, end=-9), pattern=" ", replacement=""))
  df$TDN0[rindx] = as.numeric(gsub(x=str_sub(string=txtfile[TDN0], start=-24, end=-9), pattern=" ", replacement=""))
  df$TDE0[rindx] = as.numeric(gsub(x=str_sub(string=txtfile[TDE0], start=-24, end=-9), pattern=" ", replacement=""))

  # Condensed local Nucleophilic/Electrophilic superdelocalizability value and relavant-atom
  local_start = Con1 + 3
  # 注：按照格式定位出错Con2-2 对应的不是原子最后一行
  local_end = Con2 - 1
  DNnum = NULL
  DEnum = NULL
  DN0num = NULL
  DE0num = NULL
  for (j in local_start:local_end){
    DNnum[j] = as.numeric(gsub(x=str_sub(string=txtfile[j], start=-67, end=-51), pattern=" ", replacement=""))
    DEnum[j] = as.numeric(gsub(x=str_sub(string=txtfile[j], start=-50, end=-34), pattern=" ", replacement=""))
    DN0num[j] = as.numeric(gsub(x=str_sub(string=txtfile[j], start=-33, end=-17), pattern=" ", replacement=""))
    DE0num[j] = as.numeric(gsub(x=str_sub(string=txtfile[j], start=-16), pattern=" ", replacement=""))
	}
  df$DNmax[rindx] = max(DNnum[local_start:local_end])
  df$DNmin[rindx] = min(DNnum[local_start:local_end])
  df$DEmax[rindx] = max(DEnum[local_start:local_end])
  df$DEmin[rindx] = min(DEnum[local_start:local_end])
  df$DN0max[rindx] = max(DN0num[local_start:local_end])
  df$DN0min[rindx] = min(DN0num[local_start:local_end])
  df$DE0max[rindx] = max(DE0num[local_start:local_end])
  df$DE0min[rindx] = min(DE0num[local_start:local_end])
  
  DNmaxAtom1 = which(DNnum==max(DNnum[local_start:local_end]),arr.ind=TRUE)
  DNminAtom1 = which(DNnum==min(DNnum[local_start:local_end]),arr.ind=TRUE)
  DEmaxAtom1 = which(DEnum==max(DEnum[local_start:local_end]),arr.ind=TRUE)
  DEminAtom1 = which(DEnum==min(DEnum[local_start:local_end]),arr.ind=TRUE)
  DN0maxAtom1 = which(DN0num==max(DN0num[local_start:local_end]),arr.ind=TRUE)
  DN0minAtom1 = which(DN0num==min(DN0num[local_start:local_end]),arr.ind=TRUE)
  DE0maxAtom1 = which(DE0num==max(DE0num[local_start:local_end]),arr.ind=TRUE)
  DE0minAtom1 = which(DE0num==min(DE0num[local_start:local_end]),arr.ind=TRUE)
  
  #输出重复的组别 用"-"分开
  if(length(DNmaxAtom1)>1|length(DNminAtom1)>1|length(DEmaxAtom1)>1|length(DEminAtom1)>1|
     length(DN0maxAtom1)>1|length(DN0minAtom1)>1|length(DE0maxAtom1)>1|length(DE0minAtom1)>1){
  df$Repeat [rindx] = paste(DNmaxAtom1[1:length(DNmaxAtom1)],DNminAtom1[1:length(DNminAtom1)],DEmaxAtom1[1:length(DEmaxAtom1)],DEminAtom1[1:length(DEminAtom1)],
                            DN0maxAtom1[1:length(DN0maxAtom1)],DN0minAtom1[1:length(DN0minAtom1)],DE0maxAtom1[1:length(DE0maxAtom1)],DE0minAtom1[1:length(DE0minAtom1)],collapse = '-')}
  
  df$DNmaxatom[rindx] = gsub(x=str_sub(string=txtfile[DNmaxAtom1], start=1, end=10), pattern=" ", replacement="")
  df$DNminatom[rindx] = gsub(x=str_sub(string=txtfile[DNminAtom1], start=1, end=10), pattern=" ", replacement="")
  
  df$DEmaxatom[rindx] = gsub(x=str_sub(string=txtfile[DEmaxAtom1], start=1, end=10), pattern=" ", replacement="")
  df$DEminatom[rindx] = gsub(x=str_sub(string=txtfile[DEminAtom1], start=1, end=10), pattern=" ", replacement="")
  
  df$DN0maxatom[rindx] = gsub(x=str_sub(string=txtfile[DN0maxAtom1], start=1, end=10), pattern=" ", replacement="")
  df$DN0minatom[rindx] = gsub(x=str_sub(string=txtfile[DN0minAtom1], start=1, end=10), pattern=" ", replacement="")

  df$DE0maxatom[rindx] = gsub(x=str_sub(string=txtfile[DE0maxAtom1], start=1, end=10), pattern=" ", replacement="")
  df$DE0minatom[rindx] = gsub(x=str_sub(string=txtfile[DE0minAtom1], start=1, end=10), pattern=" ", replacement="")
  
}
write.csv(df, file="F:/2ndALL/0 Gaussian16计算文件_替换2分子/txt_superdelocalizability_2nd_173.csv", row.names=F)
