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
######################################################
#Section: create and write conc as xlsx

#ONLY USED FOR EXCEL FILE CREATION
# #####################################################
# count_match <- as.character(data.frame(read_excel(paste0(root_folder,"ProcessedData/GDP/ALL_GDP.xlsx")))[,1])
# r2r <- read_excel(paste0(root_folder,"Settings/Root/Legends/PIOLab_RootClassification.xlsx"), sheet=1)
# 
# # create and write Reg2Root concordance easy due no old regions in the data
# Reg_conc <- sapply(r2r$RootCountryAbbreviation,function(x){grepl(x,count_match)})*1
# row.names(Reg_conc) <- count_match
# 
# 
# filename_conc <- "/GDP_Reg_Source2Root.xlsx" # Define name of file
# write.xlsx(Reg_conc, paste0(root_folder,"/ConcordanceLibrary/GDP/",filename_conc),col.names = T, row.names=T)

######################################################
#Section: create and write conc as xlsx
######################################################
conc <- data.frame(read_excel(paste0(root_folder,"/ConcordanceLibrary/GDP/GDP_Reg_Source2Root.xlsx"), sheet=1))[,-c(1,2)]
write.table(conc, paste0(root_folder,"/ConcordanceLibrary/GDP_Reg_Source2Root.csv"), col.names=F, row.names = F, sep=',')

