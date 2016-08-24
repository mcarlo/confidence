###
rm(list = ls())
weekNum <- 1
csvFile <- paste0("D:/WTP/WEEK0", weekNum, "_2016.csv" )
load("fansimsSkeleton.RData")
load("altStuff.RData")
source("data_to_load.R") #getwd()

#processFile("~/WEEK10_2016.csv")  #
processFile(csvFile) #"2014week15.csv")

simDogs <- simDogs16
simFavs <- simFavs16
simOutcomes2 <- simOutcomes2_16
simPicks <- simPicks16
simplayerCols <- simplayerCols16
simPrior <- simPrior16
simRand <- simRand16
simRaw <- simRaw16
upsetMatrix <- upsetMatrix16
upsetDiagMatrix <- upsetDiagMatrix16
fanIndex <- fanIndex16

conditionGames(nGames = games)

genMtx() #strategies
simParams()
littleSim()

popConfList <- function(size){list(size, calcWinners(size))}
results05 <- popConfList(5)



resultsLists <- rep(results05, 20)

confTactics <- function(startList, maxSize = 100){
  # maxSize must be divisible by 5
  # startList <- results05
  # maxSize <- 100

  fanSizes <- seq(5, maxSize, by = 5)
  maxIter <- maxSize/5
  outList <- rep(startList, maxIter)

  for(i in 1:maxIter)  { #i=1

    size <- fanSizes[i]
    genList <- popConfList(size)
    outList[[2*(i - 1) + 1]] <- genList[[1]]
    outList[[2*i]] <- genList[[2]]

  }
  outList
}
system.time(resultsLists <- confTactics(results05))
thisDate <- as.character(format(Sys.time(), "%D %I:%M %Z"))
fileName <- paste0("WTP_confidence/useWeeklyFile2016_", weekNum, ".RData")
#setwd("D:/Documents/GitHub/fs2/weeklyApp_confidence")
save(resultsLists, gameRanks, strategies, weekFileConf, thisDate, file = fileName)
# write.csv(resultsLists, "resultsLists.csv")
# write.csv(gameRanks, "gameRanks.csv")
# write.csv(strategies, "strategies.csv")
# write.csv(weekFileConf, "weekFileConf.csv")
# resultsLists
# str(thisDate)