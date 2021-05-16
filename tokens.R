require(quanteda)
require(quanteda.textstats)

# コーパスを読み込み
corp <- readRDS(file = "corpus_tottori.RDS")

# トークン化し、数字、ひらがな、カタカナ、漢字を選択
toks <- tokens(corp, remove_punct = TRUE, remove_symbols = TRUE, remove_numbers = TRUE, 
               remove_url = TRUE, padding = TRUE) 
toks <- tokens_select(toks, "^[０-９ぁ-んァ-ヶー一-龠]+$", valuetype = 'regex', padding = TRUE)

# カタカナと漢字から成る共起語を特定し、複合語として結合
seqs <- toks %>% 
    tokens_remove(stopwords("ja", "marimo"), padding = TRUE) %>% 
    tokens_select('[ァ-ヶー一-龠]', valuetype = 'regex', padding = TRUE) %>% 
    textstat_collocations(min_count = 10, tolower = FALSE)
seqs <- seqs[seqs$z > 3,]
toks <- tokens_compound(toks, seqs, concatenator = '', join = FALSE)

# 共起語を保存
saveRDS(seqs, file = "collocations.RDS")

# トークンを保存
saveRDS(toks, file = "tokens_tottori.RDS")
