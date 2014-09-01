library(TableToLongForm)
library(reshape2)
library(plyr)

nestncea_raw <- as.matrix(read.csv("nestncea_raw.csv", header = FALSE))

# long form
nestncea <- TableToLongForm(nestncea_raw) 
colnames(nestncea) <- paste0("C", sprintf("%02d", 1:12)) # pad with leading zero for sort
nestncea <- ldply(nestncea, function(x) {as.integer(as.character(x))})
nestncea <- melt(nestncea)
colnames(nestncea) <- c("class", "student", "credits")
nestncea <- arrange(nestncea, class)

# region and school levels
region <- gl(2, 24, labels = c("Wellington", "Auckland"))
school <- gl(6, 8, labels = paste0("S", 1:6))

# put together
nestncea <- cbind(region, school, nestncea[, c(1, 3)])

# save
write.csv(nestncea, "nestncea.csv", row.names = FALSE, quote = FALSE)

# repeat without leading zeros, like the official version
classes <- gl(12, 4, labels = paste0("C", 1:12))
nestncea$class <- classes
write.csv(nestncea, "nestncea2.csv", row.names = FALSE, quote = FALSE)

# repeat without leading zeros and in lowercase
classes <- tolower(classes)
school <- tolower(school)
nestncea$class <- classes
nestncea$school <- school
write.csv(nestncea, "nestncea_lower.csv", row.names = FALSE, quote = FALSE)

