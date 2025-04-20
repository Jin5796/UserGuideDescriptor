library(stringr)
library(plyr)
home=getwd()
data=dir(path=paste(home,"/LUMO_HOMO",sep=""),pattern="\\.txt")
Orbital_data <- read.csv(file=paste(home,"LOMO_HOMO_140_orbital.csv",sep=""), header=T)
head(Orbital_data)
chemical = Orbital_data$chemical
chemical = str_pad(chemical,width=10,pad="0")
HOMO = Orbital_data$HOMOOrbital
LUMO = Orbital_data$LUMOOrbital
for (i in 1:length(chemical)){
  comfile = scan(file="E:/FED_SPN.txt", what=character(), sep="\n")

  sink(file=str_c(home,"/LUMO_HOMO/Orbital_data/p",chemical[i],"_FED_SPN.txt"))
  cat(comfile[1:3], sep="\n")
  cat(HOMO[i],"\n")
  cat(LUMO[i],"\n")
  cat(comfile[6:8], sep="\n")
  sink()
  }
