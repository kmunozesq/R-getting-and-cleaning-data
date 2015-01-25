createCodeBook <- function()
{
        dir <- "data_cln_project"
        DT <- read.table(file=file.path(getwd(),dir,"tidy_data.txt"), header=TRUE, sep ="") %>%
                str
                #writeLines(file.path(getwd(),"CodeBook.txt"), sep ="/t")
}