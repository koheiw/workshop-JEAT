require(quanteda)

# CSVを読み込み（ファイルが必要であれば川田氏に相談）
dat <- read.csv(file = "tottori.csv")
names(dat) <- stringi::stri_trans_tolower(names(dat))

# shigotonyを分析対象としてコーパスを作成
corp <- corpus(dat, text_field = "shigotony")
print(corp, max_nchar = -1)

# コーパスを保存
saveRDS(corp, file = "corpus_tottori.RDS")
