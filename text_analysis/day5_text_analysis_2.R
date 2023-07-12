# install.packages("word2vec")
library(word2vec)

textdata <- readRDS("sicss-berlin/text_analysis/data/CNN_complete.Rds")
model <- word2vec(textdata$body, type = "cbow", window = 5, dim = 50)

embeddings <- as.matrix(model)

head(embeddings)

predict(model, c("criminal", "violent"), type = "nearest", top_n = 10)


wv <- embeddings["white", ] - embeddings["person", ] + embeddings["racism", ]
predict(model, newdata = wv, type = "nearest", top_n = 10)


write.word2vec(model, "mymodel.bin")
model <- read.word2vec("mymodel.bin")
