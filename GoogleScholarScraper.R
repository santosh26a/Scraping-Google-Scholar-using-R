#Scraping Google Scholar for citations
library(XML)
citations <- vector("list")
sleep_times <- seq(20, 70, length.out = length(ArticleList$ArticleTitle))
#userAgent <- read.table("user_agents.txt")
for (i in 1:length(ArticleList$ArticleTitle)) {
  
  article_str = ArticleList$ArticleTitle[[i]]
  author_str = gsub('[c()\"]', "", ArticleList$Authors[[i]])
  
  scholar_url = URLencode(paste("http://scholar.google.com/scholar?q=", article_str, 
                                " ", author_str, sep = ""))
  scholar_page = htmlParse(scholar_url, isURL = TRUE)
  citationX = xpathSApply(scholar_page, 
                          "//div[@class='gs_fl']/a[contains(.,'Cited by')]/text()", 
                          xmlValue)
  citations[[i]] <- as.numeric(gsub('Cited by','', citationX))
  Sys.sleep(sample(sleep_times, 1))
}
