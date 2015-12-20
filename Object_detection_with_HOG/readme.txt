AR 20151205
Scripts and materials for exracting HOG feagures and training ML models.

negativeImages -- a collection of negative samples used for head-detection
positiveImages -- a collectionof positive sampels
calcHOGparms.m -- development script of the logic to recalculate HOG CellSize parameter based on image size

-------The main script--------
createTrainingMatrixHOG.m -- main function used extract HOG features from sample images. 
------------------------------

funCalcCellSize.m -- funciton called by createTrainingMatrixHOG.m
HOGmat<#number>.mat -- training matrixes of #number-long ready for model training.  First column is the response variable.
imgSampleInfo.m -- a development script.  Not important.  Keeping just in case
Object_detection_with_HOG.m -- a development script. Not important. Keeping just in case.

