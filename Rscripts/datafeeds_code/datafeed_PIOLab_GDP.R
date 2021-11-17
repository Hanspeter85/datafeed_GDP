options(warn=-1)
################################################################################
datafeed_name <- "GDP"
print(paste0("datafeed_PIOLab_",datafeed_name," initiated."))
######################################################################
library(readxl)
library(xlsx)
library(stringr)
library(tidyverse)
library(tidyr)
library(dplyr)
library(magrittr)
library(reshape2)
library(XLConnect)
library(data.table)
library(matrixStats)


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

################################################################################
#Section: define some vectors we want to loop through & create directories
################################################################################

#load whole dataset in the HS Code is not 10
dir <- paste0(root_folder,"RawDataRepository/GDP/")#,countries,"/YB_xlsx/")#,year,".xlsx")

#load setting which decides if NAs should be replaced by 0
NA_setting <- read_excel(paste0(root_folder,'Settings/datafeed_settings/GDP_settings.xlsx'))

# Check if folder with processed data exists, in case delete and create empty one inkl metal directoreis
dir0 <- paste0(root_folder,"ProcessedData/GDP/")
if( dir.exists(dir0) ) unlink(dir0, force = T, recursive = T) 
dir.create(dir0)

df <- data.frame(read_excel(paste0(root_folder,'RawDataRepository/GDP/API_NY.GDP.MKTP.CD_DS2_en_excel_v2_3158925.xls')))
names(df) <- df[3,]
df <- df[-c(1:3),-c(1,3:4)]

#write the overview files
write.xlsx(df,paste0(root_folder,"/ProcessedData/GDP/","/ALL_GDP.xlsx"),col.names = T, row.names=F)

