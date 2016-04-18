
library(ggplot2)
library(ngram)
library(stringi)
library(stringr)
library(tm)
library(RWeka)



unigrams <- readRDS("unigrams.rds")
bigrams <- readRDS("bigrams.rds")
trigrams <- readRDS("trigrams.rds")


getNextWordPrediction <- function(strSearch)
{
  resultNum <- 5  ##return the num of nextword
  segStr <- unlist( strsplit(strSearch," ") )
  
  if(length(segStr) > 2)
  {
    ##max support trigram model
    ##get the last two word
    inString <- paste0(segStr[(length(segStr)-1):length(segStr)],collapse=" ")
  }
  else
  {
    inString <- strSearch
  }
  
  
  segStr <- unlist( strsplit(inString," ") )
  if(length(segStr) == 0)
  {
    ##search unigram
    search_table <- unigrams[1:20,]
    nextWords <- as.character(head(search_table$word, resultNum))
    print("unigram")
    return(nextWords)
  }
  else
  {
    ##search bigram,trigram...
    for (i in length(segStr):1)
    {
      inString <- paste0(segStr[(length(segStr)-i+1):length(segStr)],collapse=" ")
      str_start_regexpr <- paste0('^\\<', inString, '\\>')
      #print(tmpstr)
    
      if(i == 2)
      {
        ##search in the trigram
        search_table <- subset(trigrams, 
                grepl(str_start_regexpr, trigrams$word))
        if(nrow(search_table) != 0)
        {
          str_start_regexpr <- paste0('^\\<', inString, '\\s+')
          search_table$word <- gsub(str_start_regexpr, "", paste(search_table$word))
          print("trigram")
          break
        }
      }
      else if(i == 1)
      {
        ##search in the bigram
        search_table <- subset(bigrams, grepl(str_start_regexpr, bigrams$word))
        if(nrow(search_table) != 0)
        {
          str_start_regexpr <- paste0('^\\<', inString, '\\s+')
          search_table$word <- gsub(str_start_regexpr, "", paste(search_table$word))
          print("bigram")
          break
        }
      }
    }
    
    ##without the trigram and bigram
    if(nrow(search_table) == 0)
    {
      ##unigram
      search_table <- unigrams[1:20,]
      print("unigram")
    }
  }
  
  probability <- NULL
  for (i in 1:nrow(search_table))
  {
    seqFreq <- search_table$frequency[i]
    probability <- c(probability, (seqFreq/sum(search_table$frequency)))
  }
  
  search_table$probability <- probability
  
  nextWords <- as.character( head(search_table$word, resultNum))  
  return(nextWords)
}
  

#inString <- ""
#predictWord <- getNextWordPrediction(inString)
#print(predictWord)


#inString <- "word"
#predictWord <- getNextWordPrediction(inString)
#print(predictWord)


#inString <- "world cup"
#predictWord <- getNextWordPrediction(inString)
#print(predictWord)

#inString <- "world cup is"
#predictWord <- getNextWordPrediction(inString)
#print(predictWord)


#inString <- "World"
#predictWord <- getNextWordPrediction(inString)
#print(predictWord)
