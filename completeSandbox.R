###
rm(list = ls())
setwd("D:/Documents/GitHub/confidence")
weekNum <- 1
csvFile <- paste0("D:/WTP/WEEK0", weekNum, "_2016.csv" )
load("fansimsSkeleton.RData")
load("altStuff.RData")
source("data_to_load.R") #getwd()

#processFile("~/WEEK10_2015.csv")  #weekfile <- read.csv("D:/WTP/WEEK12_2015.csv", header = T, stringsAsFactors = F)
processFile(csvFile) #processFile("D:/WTP/WEEK13_2015.csv") #"2014week15.csv")

weekFileConf <- weekFileConf[order(weekFileConf$YahooOrder),]
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

genMtx() #sets up strategies
simParams() #narrows outcomes to fan samples of 250
littleSim()

outcomeMatrix <- simOutcomes2_16

setwd("D:/Documents/GitHub/pickem")
load("straightStartSpecific.Rdata")


moneyPicks <- function(wpVector=winProb, favVector=comparisonPicks16[,13332], outcomeMatrix = simOutcomes2_16){#favVector = comparisonPicks16[,1:100]
  adjWP <- wpVector * favVector + (1 - favVector) * (2 - wpVector)
  nCols <- dim(favVector)[2]
  outMatrix <- matrix(rep(0L, 2000 * nCols), nrow = 2000)
  for (i in (1:nCols)){
    outMatrix[, i] <- (t(rank(adjWP[, i], ties.method = "random")) %*% ((outcomeMatrix * favVector[, i]) + ((1 - outcomeMatrix) * (1 - favVector[, i])))) 
  }
  outMatrix
}

confPicks <- function(picks){
  weekFileConf$WinProbability * picks + (1 - picks) * (2 - weekFileConf$WinProbability)
}

system.time(ptsMult <- moneyPicks(favVector = comparisonPicks16))

findThird <- function(vec){# vec = totalPointsIter[2, 1:numberFans]
  vec[which(rank(-vec, ties.method = "random") == 3)]
}

sampleFans <- function(numberFans = 100){
  mtx <- matrix(sample(1:250, numberFans * 100, replace = T), nrow = 100)
  mtx
}

sfm <- sampleFans()

sampleBest <- matrix(rep(0, 100 * 2000), nrow = 2000)
for (j in 1:100){#j = 1
  sampleBest[, j] <- apply(totalPointsIter[, sfm[j, ]], 1, findThird)
} #sampleBest[1:10, 1:10]

system.time(sampleBest <- matrix(foreach(j = 1:100, .combine = cbind) %do% apply(totalPointsIter[, sfm[j, ]], 1, findThird), 
                                 nrow = 2000))


findITM <- function(numberFans = 100){#numberFans = 60
  #system.time(sampleBest <- matrix(foreach(j = 1:100, .combine = cbind) %do% apply(totalPointsIter[, sfm[j, ]], 1, findThird), 
  #                                 nrow = 2000))
  winVector <- rep(0, 65536)
  for (j in 1:numberFans){
    winVector <- winVector + colSums(ptsMult >= sampleBest[, j])
  }
  bestScore <- max(winVector)
  winners <- which(winVector == bestScore)
  winVector[winners]
  comparisonPicks16[, winners]
}
# weekFileConf$Game
# comparisonPicks16[, 3]
#sum(ptsMult[, 3] > totalPointsVector)

vecMatch <- function(vec, vec2){
  sum(vec == vec2) == length(vec)
}

winners <- findITM(5)
winColumn <- which(apply(comparisonPicks16, 2, vecMatch, vec2 = winners) == TRUE)

picks <- weekFileConf$Victor
picks[comparisonPicks16[, winColumn] == 0] <- weekFileConf$Underdog[comparisonPicks16[, winColumn] == 0]
cbind(picks[weekFileConf$YahooOrder],
      rank(confPicks(comparisonPicks16[, winColumn]), ties.method = "random")[weekFileConf$YahooOrder],
      weekFileConf$Game[weekFileConf$YahooOrder])