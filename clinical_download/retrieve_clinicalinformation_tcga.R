## -------download tcga patient clinical info.-----------##
# author: Hongming XU, CCF, 2020
# email: mxu@ualberta.ca

#- to install TCGAbiolinks (see: https://bioconductor.org/install/): use below code for >R3.6:
# BiocManager::install("TCGAbiolinks")


#- tcga biolinks website
# https://bioconductor.org/packages/devel/bioc/vignettes/TCGAbiolinks/inst/doc/clinical.html

#- notes:
# results are save into the directory ./results
# make sure there is a fold called results

library("TCGAbiolinks")




setwd("./")


mv_CancerTypes = read.table("TCGA_Cancer_Type_List.txt")



for (mn_i in 31:length(mv_CancerTypes[, 1])) {
  mstr_type <- paste0(mv_CancerTypes[mn_i, ], "")
  
  tryCatch({
    #clinical <- GDCquery_clinic(project = "TCGA-LUAD", type = "clinical")
    #datatable(clinical, filter = 'top',
    #          options = list(scrollX = TRUE, keys = TRUE, pageLength = 5),
    #          rownames = FALSE)
    
    
    query <-GDCquery(project = mstr_type,
                     data.category = "Clinical",
                     file.type = "xml")
    
    GDCdownload(query)
    
    
    clinical.patient <- GDCprepare_clinic(query, clinical.info = "patient")
    
    clinical.followup <- GDCprepare_clinic(query,clinical.info = "follow_up")
    
    
    write.table(
      clinical.patient,
      file = paste0("./results/", mstr_type, "_patient_info.txt"),
      sep = "\t",
      quote = FALSE,
      row.names = FALSE
    )
    
    write.table(
      clinical.followup,
      file = paste0("./results/", mstr_type, "_patient_follow_up_info.txt"),
      sep = "\t",
      quote = FALSE,
      row.names = FALSE
    )
    
  },error = function(err) {
    print(paste(mn_i, mstr_type, "download error"))
    
  })
  
}
