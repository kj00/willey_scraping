library(rvest)
library(stringr)

###
dldir <- "C:/Users/Koji/Documents/dlpdf/"  ##  MUST End with  "/" 
##
setwd(dldir)

#dir.create(dldir) #if needed

###
wilurl <- "http://onlinelibrary.wiley.com/book/10.1002/0471266981"



###

current_page <- html_session(wilurl) #access url

#
title <- current_page %>% read_html() %>% html_nodes("h1") %>%
  gsub('<h1 id="productTitle">|</h1>', "", .) %>% 
  gsub("[^[:alnum:]]", "", . )  ##need to exclude any special letters like ":"
  
  

#
pdf_nodes <- current_page %>% read_html() %>% html_nodes("a.standardPdfLink") #get pdf links


for (i in 1:length(pdf_nodes)) {

pdfurl  <- str_match(pdf_nodes, "doi.+pdf")[i] %>% #clean up pdf address
    paste("http://onlinelibrary.wiley.com/" ,. , sep = "") #combine strings into url

pdf_page <- jump_to(current_page, pdfurl) #preceed

dl <-   pdf_page %>% read_html() %>% html_nodes(xpath = '//*[@id="pdfDocument"]') %>% #get pdf file node 
html_attr(name = "src") #extract pdf source url


#####sometime this doesn't work##########################################
pdf_dl_page <- jump_to(pdf_page, dl)
writeBin(pdf_dl_page$response$content, con = paste(i, "_", title, ".pdf", sep = ""))
##########################################################################


}

