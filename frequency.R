require(quanteda)
require(quanteda.textstats)

# トークンを読み込み、文法的な語を削除
toks <- readRDS(file = "tokens_tottori.RDS") %>% 
    tokens_remove(stopwords("ja", "marimo"), padding = TRUE)  %>% 
    tokens_remove("^[ぁ-ん]+$", valuetype = "regex", min_nchar = 2, padding = TRUE)

# 文書行列を生成
dfmt <- dfm(toks, remove_padding = TRUE)
topfeatures(dfmt, 20)

table(dfmt$emptype)

# 雇用形態に関係した語を選択
key_full <- textstat_keyness(dfmt, dfmt$emptype == "正社員")
head(key_full, 10)

key_else <- textstat_keyness(dfmt, dfmt$emptype == "正社員以外")
head(key_else, 10)

key_part <- textstat_keyness(dfmt, dfmt$emptype == "パート労働者")
head(key_part, 10)
