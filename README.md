# 経済学における量的テキスト分析入門

経済学における日本語の量的テキスト分析の方法を示す。ハローワークの求人票の分析を題材として、頻度分析、共起分析、辞書分析、機械学習の使い方を説明。2021年の日本経済学会春季大会で行ったチュートリアルの素材が元になっている。

最新の[qnuateda](https://github.com/quanteda/quanteda)による日本語の前処理や、seeded-LDAによる準教師ありトピックモデルを主題とするので、やや古くなった[『Rによる日本語のテキスト分析入門』](https://github.com/koheiw/workshop-IJTA)と合わせて参照すべし。


## スライド

- [slides.md](slides.md)

## デモ用ファイル

- 前処理
    - [corpus.R](corpus.R)
    - [tokens.R](tokens.R)
- 頻度分析
    - [frequency.R](frequency.R)
- 辞書分析
    - [dictionary.R](dictionary.R)
- トピックモデル
    - [lda.R](lda.R)
    
## トピックモデルの結果
    
- [lda.md](lda.md)
