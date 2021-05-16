require(quanteda)
require(seededlda)

# トークンを読み込み、文法的な語を削除
toks <- readRDS(file = "tokens_tottori.RDS") %>% 
    tokens_remove(stopwords("ja", "marimo"), padding = TRUE)  %>% 
    tokens_remove("^[ぁ-ん]+$", valuetype = "regex", min_nchar = 2, padding = TRUE)

# 文書行列を生成し、頻度が低い語（10回未満）と一般的な語（1割以上の文書）を削除
dfmt <- dfm(toks, remove_padding = TRUE) %>% 
    dfm_trim(min_termfreq = 10, max_docfreq = 0.1, docfreq_type = "prop")

# 教師なしLDAを適用
lda <- textmodel_lda(dfmt, k = 10, verbose = TRUE)
terms(lda, 100)

# 順教師ありLDAを適用
dict <- dictionary(file = "dictionary.yml")
slda <- textmodel_seededlda(dfmt, dict$tasks, residual = TRUE, verbose = TRUE)
terms(slda, 30)

# ２つのLDAを保存
save(lda, slda, file = "lda.RDA")
