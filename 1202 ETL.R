# ETL process in R

# 1. install necessary packeages
install.packages("stringr")
install.packages("XLConnect")
install.packages("Rcpp")
install.packages("dplyr")
library(stringr)
library(XLConnect)
library(dplyr)
update.packages(checkBuilt = TRUE)

# 2. Define path
setwd("C:/Users/49330/Desktop/superstore_cleaned.csv")

# 3.read the raw data and merge different data sources
# 3-1 read different sheets into R
workbook = loadWorkbook("Sample - Superstore.xls")
orders = readWorksheet(workbook, sheet = "Orders", header = TRUE)
returns = readWorksheet(workbook, sheet = "Returns", header = TRUE)
people = readWorksheet(workbook, sheet = "People", header = TRUE)

#3-2 merge the data into onefile
temp1 <- merge(x=orders, y=returns, by=c("Order.ID"), all.x=TRUE)
superstore <- merge(x=temp1, y=people, by=c("Region"), all.x=TRUE)

#3-3 check the characteristics for the full dataset
str(superstore)

# 4. handle the missing values in the dataset
# 4-1 check if mssing values exist 
table(is.na(superstore))
# 4-2 check which column contains missing values 
colnames(superstore)[colSums(is.na(superstore)) > 0]
# 4-3 encode missing values 
superstore$Returned<- ifelse(is.na(superstore$Returned), '0', '1')
# 4-4 dispay the column 
table(superstore$Returned)
# 4-5 define the variable type to factor
superstore$Returned <- factor(superstore$Returned, levels = c(0,1), labels = c("no","yes"), ordered= TRUE)
plot((superstore$Returned))

# 5. check if there is other missing values in this dataset 
summary(superstore)

# 6. write cleansed dataset to the local
write.csv(superstore,"superstore_cleaned.csv")