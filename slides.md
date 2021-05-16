経済学における量的テキスト分析
================
渡辺耕平
2021年05月16日

## 本チュートリアルの構成

-   概要
    -   政治学における応用
    -   テキスト分析の手順
    -   量的分析法の種類
-   デモ
    -   ハローワークの求人票の分析
-   まとめ
    -   追加の情報など
-   質疑応答

## 使用するソフトウェア

-   R 4.0以降
-   Rパッケージ
    -   quanteda
    -   quanteda.textstats
    -   seededlda
-   R Studio

## quantedaの特徴

-   Unicodeに準拠し，アジア言語の文書を処理できる．
-   C++による並列化により大規模なテキストデータを処理できる．
-   欧米の大学の量的テキスト分析の研究と教育で広く使われている．

## 配布ファイル

Dropbox (<https://bit.ly/3ePC9AC>)

-   スライド
    -   slides.html
-   データ（元ファイルが必要であれば川田氏に相談）
-   キーワード辞書
-   Rスクリプト

## 量的テキスト分析とは

-   政治学では文書が重要な研究資料
    -   質的テキスト分析
        -   例：スピーチ，選挙広報，政府報告書，新聞記事など
    -   量的テキスト分析（2000年代以降)
        -   自然言語処理のツールを用いて多数の文書を分析する
        -   文書データを数値データに変換し，統計的な分析を行う．
-   政治学者は文書そのものに関心があるわけではない
    -   文書を通じて政治的行為者に関する推定を行う．
        -   例：イデオロギー，精神状態，偏見，行動など
    -   文書を直接的には測定できないものを推計する
        -   例：政治的な影響力，経済的の不確実性，地政学的な脅威認識など

## 一般的な分析手順

-   文書の収集
-   前処理
    -   クリーニング（ページ番号，日付などの削除）
    -   トークン化（文を語に分割）
        -   語彙に基づいた分割（形態素解析は行わない）
        -   共起分析によって未知語をトークン化する
    -   数字，記号，文法的語の削除
    -   文書行列の作成
-   量的分析
    -   頻度分析，クラスタリング，辞書分析，ネットワーク分析，機械学習など
-   結果の解釈

# 前処理

## トークン化

``` r
require(quanteda)
## Loading required package: quanteda
## Warning in .recacheSubclasses(def@className, def, env): undefined subclass
## "numericVector" of class "Mnumeric"; definition not updated
## Package version: 3.0.0
## Unicode version: 13.0
## ICU version: 66.1
## Parallel computing: 6 of 6 threads used.
## See https://quanteda.io for tutorials and examples.
txt <- c("施設利用者の生活支援、作業支援、食事介助、入浴介助などを行っています。",
         "福祉に興味、熱意のある方を募集しています。未経験者も歓迎します。")
toks <- tokens(txt, remove_punct = TRUE)
print(toks, max_ndoc = -1, max_ntok = -1)
## Tokens consisting of 2 documents.
## text1 :
##  [1] "施設" "利用" "者"   "の"   "生活" "支援" "作業" "支援" "食事" "介助"
## [11] "入浴" "介助" "など" "を"   "行"   "って" "い"   "ます"
## 
## text2 :
##  [1] "福祉"   "に"     "興味"   "熱意"   "の"     "ある"   "方"     "を"    
##  [9] "募集"   "し"     "てい"   "ます"   "未経験" "者"     "も"     "歓迎"  
## [17] "し"     "ます"
```

## 共起分析によるトークンの修正

``` r
seqs <- readRDS("collocations.RDS")
nrow(seqs)
## [1] 3561
head(seqs)
##   collocation count count_nested length   lambda        z
## 1     利用 者  1601            0      2 6.189393 140.5496
## 2   未経験 者  1199            0      2 5.187306 128.8927
## 3     事業 所  1086            0      2 8.532710 123.5738
## 4   雇用 期間   902            0      2 8.020318 121.0938
## 5       用 車   744            0      2 6.757942 114.9101
## 6   業務 全般  1327            0      2 4.642487 112.8731
```

``` r
toks <- tokens_compound(toks, seqs, concatenator = '', join = FALSE)
print(toks, max_ndoc = -1, max_ntok = -1)
## Tokens consisting of 2 documents.
## text1 :
##  [1] "施設利用" "利用者"   "の"       "生活支援" "作業支援" "食事介助"
##  [7] "入浴介助" "など"     "を"       "行"       "って"     "い"      
## [13] "ます"    
## 
## text2 :
##  [1] "福祉"     "に"       "興味"     "熱意"     "の"       "ある"    
##  [7] "方"       "を"       "募集"     "し"       "てい"     "ます"    
## [13] "未経験者" "も"       "歓迎"     "し"       "ます"
```

## 文法的語の削除

``` r
toks <- tokens_remove(toks, stopwords("ja", "marimo"), padding = TRUE) 
toks <- tokens_remove(toks, "^[ぁ-ん]+$", valuetype = "regex", min_nchar = 2, padding = TRUE)
print(toks, max_ndoc = -1, max_ntok = -1)
## Tokens consisting of 2 documents.
## text1 :
##  [1] "施設利用" "利用者"   ""         "生活支援" "作業支援" "食事介助"
##  [7] "入浴介助" ""         ""         ""         ""         ""        
## [13] ""        
## 
## text2 :
##  [1] "福祉"     ""         "興味"     "熱意"     ""         ""        
##  [7] ""         ""         "募集"     ""         ""         ""        
## [13] "未経験者" ""         "歓迎"     ""         ""
```

## 文書行列の作成

``` r
dfm(toks, remove_padding = TRUE)
## Document-feature matrix of: 2 documents, 12 features (50.00% sparse) and 0 docvars.
##        features
## docs    福祉 興味 熱意 募集 歓迎 未経験者 施設利用 利用者 生活支援 作業支援
##   text1    0    0    0    0    0        0        1      1        1        1
##   text2    1    1    1    1    1        1        0      0        0        0
## [ reached max_nfeat ... 2 more features ]
```

# 量的分析

## 量的分析の手法

-   統計分析
    -   頻度分析，共起分析など
-   辞書分析
    -   感情分析，話題分類，地理分類など
-   機械学習
    -   教師あり，教師なし，準教師あり学習

## 頻度分析

-   単純頻度
    -   文法もしくは分野と関連する一般的な語が強調される．
-   相対頻度
    -   選択された文書の内容と関連した語が強調される．

## 辞書分析

-   既存の辞書
    -   英語
        -   Lexicoder Sentiment Dictionary (LSD)，Linguistic Inquiry and
            Word Count (LIWC) など
    -   日本語
        -   日本語評価極性辞書
-   辞書の作成
    -   分析者が関心のある概念を選び，それらを多数のキーワードによって定義する．
    -   正確な分析のためには数百から数千のキーワードを辞書に含む必要がある．

## 辞書の例

YAMLフォーマットによって，辞書の階層的な構造を定義できる．

    ## tasks: 
    ##     office:   ["パソコン", "メール", "電話", "経理", "会計"]
    ##     factory:  ["組立", "製造", "加工"]
    ##     engineer: ["設計", "開発", "検査", "操作"]
    ##     builder:  ["施工", "工事", "建設", "塗装", "溶接"]
    ##     nurse:    ["看護", "介護", "保育"]
    ##     catering: ["調理", "配膳"]
    ##     sales:    ["営業", "接客"]

## 機械学習

-   教師あり学習
    -   Support Vector Machine，ナイーブベイズ，Random Forestsなど
    -   訓練データを通じてユーザーが分析結果を制御できる．
    -   複雑なモデルを訓練するためのコストが高い．
-   教師なし学習
    -   Latent Dirichlet Allocation（LDA），対応分析，Multi-dimensional
        Scalingなど
    -   ユーザーが分析結果を制御できない．
    -   訓練をするための費用が全くかからない．
-   準教師あり学習
    -   Seeded LDA，Newsmap，Latent Semantic Scaling
    -   種語を通じてユーザーが分析結果を制御できる．
    -   訓練するためのコストが小さい．

## デモ用ファイル

Dropbox (<https://bit.ly/3ePC9AC>)

-   前処理
    -   corpus.R
    -   tokens.R
-   頻度分析
    -   frequency.R
-   辞書分析
    -   dictionary.R
-   トピックモデル
    -   lda.R
    -   lda.Rmd

## まとめ

-   Rパッケージだけで，アジア言語の文書を分析をできる．
    -   日本語だけではなく中国語，韓国語，アラビア語なども分析できる．
    -   quanteda，seededldaはすべてCRANで公開されているオープンソースのソフトウェア．
-   準教師あり学習で，理論的枠組みに基づいた分析を低コストで自動化できる．
    -   種語を選ぶだけで，アルゴリズムが関連する語を自動的に特定し，文書の分類を行う．
    -   適切な種語を選択するためには分析するデータを深く理解する必要がある．
-   量的テキスト分析で文書から数値データを生成し，経済学の研究に用いることができるだろう．

## 追加情報

-   ブログ
    -   Watanabe Kohei (<https://blog.koheiw.net>)
-   Rパッケージ
    -   Quanteda (CRAN, <https://quanteda.io>)
    -   Quanteda Tutorials (<https://tutorials.quanteda.io>)
-   論文
    -   Watanabe, K. (2020). Latent Semantic Scaling: A Semisupervised
        Text Analysis Technique for New Domains and Languages.
        Communication Methods and Measures.
        <https://doi.org/10.1080/19312458.2020.1832976>
    -   Watanabe, K., & Zhou, Y. (2020). Theory-Driven Analysis of Large
        Corpora: Semisupervised Topic Classification of the UN Speeches:
        Social Science Computer Review.
        <https://doi.org/10.1177/0894439320907027>
    -   Catalinac, A, & Watanabe, K. (2019). 日本語の量的テキスト分析.
        WIAS Research Bulletin 2018.
        <https://www.waseda.jp/inst/wias/assets/uploads/2019/03/RB011_133-143.pdf>
