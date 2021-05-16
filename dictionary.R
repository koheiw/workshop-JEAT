require(quanteda)

# トークンを読み込み
toks <- readRDS(file = "tokens_tottori.RDS")

# 辞書を読み込み
dict <- dictionary(file = "dictionary.yml")

# 辞書を適用し、キーワードを検出
toks_dict <- tokens_lookup(toks, dict, levels = 2)

# 文書行列
dfmt_dict <- dfm(toks_dict)
freq <- featfreq(dfmt_dict)

# 頻度を視覚化
par(mar = c(4, 5, 1, 1))
barplot(freq, horiz = TRUE, las = 2)
