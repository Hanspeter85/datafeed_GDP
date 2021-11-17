options(warn=-1)
################################################################################
concfeed_name <- "BGS_Reg_Source2Root_conc"
print(paste0("concfeed_PIOLab_",concfeed_name," initiated."))
######################################################################
library(readxl)

library(dplyr)
# Determine loaction of root folder
################################################################################
#install.packages("xlsx", INSTALL_opts=c("--no-multiarch"))
#install.packages("xlsx")



# Set library path depending on whether data feed runs on Uni Sydney server or local
if(Sys.info()[1] == "Linux")
{
  # Setting the R package library folder on Uni Sydney server
  .libPaths("/suphys/hwie3321/R/x86_64-redhat-linux-gnu-library/3.5")
  
  # Define location of root directory on the Uni Sydney server:
  root_folder <- "/import/emily1/isa/IELab/Roots/PIOLab/"
  
} else{
  
  # Locating folder where the present script is stored locally to derive the root folder 
  this_file <- commandArgs() %>% 
    tibble::enframe(name = NULL) %>%
    tidyr::separate(col=value, into=c("key", "value"), sep="=", fill='right') %>%
    dplyr::filter(key == "--file") %>%
    dplyr::pull(value)
  
  if(length(this_file)==0) this_file <- rstudioapi::getSourceEditorContext()$path
  
  root_folder <- substr(dirname(this_file),1,nchar(dirname(this_file))-23)
  root_folder1 <- substr(dirname(this_file),1,nchar(dirname(this_file))-23)
  remove(this_file)
}
ms <- list.files(paste0(root_folder,"/ConcordanceLibrary/BGS"))
ms <- ms[grepl("Flow",ms)]
for(i in 1:length(ms)){ 
  Reg_conc <- read_excel(paste0(root_folder,"/ConcordanceLibrary/BGS/",ms[i]))[,-(1:2)]
  write.table(Reg_conc, paste0(root_folder,"/ConcordanceLibrary/",substr(ms[i],1,nchar(ms[i])-5),".csv"), col.names=F, row.names = F, sep=',')
}

