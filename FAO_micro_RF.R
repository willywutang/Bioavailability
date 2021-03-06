#' Random Forest regression bioavailability predictions of wheat tissue micronutrient contents from soil data
#' Soil and wheat plant wet chemistry data courtesy of FAO (doc @ https://www.dropbox.com/s/gwk07tanhu86tqj/Silanpaa%20Report.pdf?dl=0)
#' MIR soil data courtesy of ICRAF (2016)
#' M. Walsh, May 2016

# Required packages
# install.packages(c("devtools","caret","doParallel","randomForest")), dependencies=TRUE)
suppressPackageStartupMessages({
  require(devtools)
  require(caret)
  require(doParallel)
  require(randomForest)
})

# Data setup --------------------------------------------------------------
# Run this first: https://github.com/mgwalsh/Bioavailability/blob/master/FAO_micro_setup.R
# or run ...
# SourceURL <- "https://raw.githubusercontent.com/mgwalsh/Bioavailability/master/FAO_micro_setup.R"
# source_url(SourceURL)

# Labels: Wheat plant micro-nutrient concentrations (ppm)
pB  <- fao_cal$pB  ## Boron
pCu <- fao_cal$pCu ## Copper
pMn <- fao_cal$pMn ## Manganese
pMo <- fao_cal$pMo ## Molybdenum
pZn <- fao_cal$pZn ## Zinc
pFe <- fao_cal$pFe ## Iron

# Covariates
wetc <- fao_cal[c(4:24)] ## Wet chemistry calibration data
wetv <- fao_val[c(4:24)] ## Wet chemistry validation data
mirc <- fao_cal[c(32:1795)] ## MIR calibration data
mirv <- fao_val[c(32:1795)] ## MIR validation data

# RF models ---------------------------------------------------------------
# Start doParallel to parallelize model fitting
mc <- makeCluster(detectCores())
registerDoParallel(mc)

# Control setup
set.seed(1385321)
tc <- trainControl(method = "oob", allowParallel = TRUE)
tg <- expand.grid(mtry=seq(5, 20, by=1))

# Plant Boron content (ppm) -----------------------------------------------
# Wet chemistry covariates
pB_wet.rfo <- train(wetc, pB,
                    preProc = c("center", "scale"),
                    method = "rf",
                    ntree = 501,
                    tuneGrid = tg,
                    trControl = tc)
print(pB_wet.rfo)
pB_wet.imp <- varImp(pB_wet.rfo, useModel = FALSE)
plot(pB_wet.imp, cex=1.2, cex.axis=2, col="black", top=20)
plot(pB~fitted(pB_wet.rfo), xlab="Soil wet chemistry model fit (ppm)", ylab="Boron content of wheat plants (ppm)",
     xlim=c(-0.1,100.1), ylim=c(-0.1,100.1), cex=0.8, wetc)
abline(c(0,1), col="red", lwd=2)

# MIR covariates
pB_mir.rfo <- train(mirc, pB,
                    preProc = c("center", "scale"),
                    method = "rf",
                    ntree = 501,
                    tuneGrid = tg,
                    trControl = tc)
print(pB_mir.rfo)
pB_mir.imp <- varImp(pB_mir.rfo, useModel = FALSE)
plot(pB_mir.imp, top=20)

# Plant Copper content (ppm) ----------------------------------------------
# Wet chemistry covariates
pCu_wet.rfo <- train(wetc, pCu,
                     preProc = c("center", "scale"),
                     method = "rf",
                     ntree = 501,
                     tuneGrid = tg,
                     trControl = tc)
print(pCu_wet.rfo)
pCu_wet.imp <- varImp(pCu_wet.rfo, useModel = FALSE)
plot(pCu_wet.imp, top=20)

# MIR covariates
pCu_mir.rfo <- train(mirc, pCu,
                     preProc = c("center", "scale"),
                     method = "rf",
                     ntree = 501,
                     tuneGrid = tg,
                     trControl = tc)
print(pCu_mir.rfo)
pCu_mir.imp <- varImp(pCu_mir.rfo, useModel = FALSE)
plot(pCu_mir.imp, top=20)

# Plant Manganese content (ppm) -------------------------------------------
# Wet chemistry covariates
pMn_wet.rfo <- train(wetc, pMn,
                     preProc = c("center", "scale"),
                     method = "rf",
                     ntree = 501,
                     tuneGrid = tg,
                     trControl = tc)
print(pMn_wet.rfo)
pMn_wet.imp <- varImp(pMn_wet.rfo, useModel = FALSE)
plot(pMn_wet.imp, top=20)

# MIR covariates
pMn_mir.rfo <- train(mirc, pMn,
                     preProc = c("center", "scale"),
                     method = "rf",
                     ntree = 501,
                     tuneGrid = tg,
                     trControl = tc)
print(pMn_mir.rfo)
pMn_mir.imp <- varImp(pMn_mir.rfo, useModel = FALSE)
plot(pMn_mir.imp, top=20)

# Plant Zinc content (ppm) ------------------------------------------------
# Wet chemistry covariates
pZn_wet.rfo <- train(wetc, pZn,
                     preProc = c("center", "scale"),
                     method = "rf",
                     ntree = 501,
                     tuneGrid = tg,
                     trControl = tc)
print(pZn_wet.rfo)
pZn_wet.imp <- varImp(pZn_wet.rfo, useModel = FALSE)
plot(pZn_wet.imp, cex=1.2, col="black", top=20)
plot(pZn~fitted(pZn_wet.rfo), xlab="Soil wet chemistry model fit (ppm)", ylab="Zinc content of wheat plants (ppm)",
     xlim=c(-0.1,100.1), ylim=c(-0.1,100.1), cex=0.8, wetc)
abline(c(0,1), col="red", lwd=2)

# MIR covariates
pZn_mir.rfo <- train(mirc, pZn,
                     preProc = c("center", "scale"),
                     method = "rf",
                     ntree = 501,
                     tuneGrid = tg,
                     trControl = tc)
print(pZn_mir.rfo)
pZn_mir.imp <- varImp(pZn_mir.rfo, useModel = FALSE)
plot(pZn_mir.imp, top=20)

# Plant Iron contents (ppm) -----------------------------------------------
# Wet chemistry covariates
pFe_wet.rfo <- train(wetc, pFe,
                     preProc = c("center", "scale"),
                     method = "rf",
                     ntree = 501,
                     tuneGrid = tg,
                     trControl = tc)
print(pFe_wet.rfo)
pFe_wet.imp <- varImp(pFe_wet.rfo, useModel = FALSE)
plot(pZn_wet.imp, top=20)

# MIR covariates
pFe_mir.rfo <- train(mirc, pFe,
                     preProc = c("center", "scale"),
                     method = "rf",
                     ntree = 501,
                     tuneGrid = tg,
                     trControl = tc)
print(pFe_mir.rfo)
pFe_mir.imp <- varImp(pFe_mir.rfo, useModel = FALSE)
plot(pFe_mir.imp, top=20)

# Stop doParallel
stopCluster(mc)

# Test set predictions ----------------------------------------------------
# Wet chemistry covariates
pB_wet  <- predict(pB_wet.rfo, wetv)
pCu_wet <- predict(pCu_wet.rfo, wetv)
pMn_wet <- predict(pMn_wet.rfo, wetv)
pMo_wet <- predict(pMo_wet.rfo, wetv)
pZn_wet <- predict(pZn_wet.rfo, wetv)
pFe_wet <- predict(pFe_wet.rfo, wetv)
wet_pred <- cbind.data.frame(pB_wet,pCu_wet,pMn_wet,pMo_wet,pZn_wet,pFe_wet)
wet_test <- fao_val[c("SSID","pB","pCu","pMn","pMo","pZn","pFe")]
wet_eval <- cbind(wet_test, wet_pred)

# MIR covariates
pB_mir  <- predict(pB_mir.rfo, mirv)
pCu_mir <- predict(pCu_mir.rfo, mirv)
pMn_mir <- predict(pMn_mir.rfo, mirv)
pMo_mir <- predict(pMo_mir.rfo, mirv)
pZn_mir <- predict(pZn_mir.rfo, mirv)
pFe_mir <- predict(pFe_mir.rfo, mirv)
mir_pred <- cbind.data.frame(pB_mir,pCu_mir,pMn_mir,pMo_mir,pZn_mir,pFe_mir)
mir_test <- fao_val[c("SSID","pB","pCu","pMn","pMo","pZn","pFe")]
mir_eval <- cbind(mir_test, mir_pred)

# Write data files --------------------------------------------------------
write.csv(wet_eval, "wet_eval.csv", row.names=F)
write.csv(mir_eval, "mir_eval.csv", row.names=F)
