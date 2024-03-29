<!-- 必要のない項目は削ったり、カスタマイズして使ってください -->

## 概要

<!-- 必要のない項目は削ったり、カスタマイズして使ってください -->
<!-- issueなどがあれば貼り付けましょう -->
<!-- 感覚的に大きいPRは、小さく切り出せそうなら切り出しましょう -->

## 依存 PR

<!-- 依存しているPRがあれば、ここに箇条書きで記述しましょう -->

## 問題/課題感、改善・提案感

<!-- 必要のない項目は削ったり、カスタマイズして使ってください -->
<!-- issueがあれば、それを貼り付ければOK -->

## 対応したこと・やったこと(厳密である必要はありません)

<!-- 不要な行は消してください -->

- ✅ ユーザーに関係ある機能を実装・変更・改善・修正
- ✅ 品質向上-テスト追加・改善・修正
- ✅ DX 向上-CI/CD 周りの実装・改善・修正
- ✅ DX 向上-ドキュメンテーション・コメント改善・修正・タイポ
- ✅ DX 向上-変数名・クラス名・メソッド名・関数名・ファイル名の変更・改善・修正
- ✅ DX 向上-その他
  - <!-- その他の場合、なんとなくでいいので書きましょう -->

※ DX(Developer eXperience: 開発体験=気持ちよく開発・保守できるか)

## 変更・改善・修正するレイヤー

<!-- 3つ以上チェックが付くときは小分けにすることも検討してみてください(しょうがない場合もあります) -->
<!-- 不要な行は消してください -->

- ✅ Presentation(実装/テスト)
- ✅ UseCase(実装/テスト)
- ✅ Domain(実装/テスト)
- ✅ Infra(実装/テスト)
- ✅ その他(実装/テスト)

## 挙動確認する手順

- ✅ 手元で挙動確認しなくて良い(眺めて、気になったところ等のレビューが欲しい)
- ✅ branch をチェックアウトして `./gradlew test.full`

---

## レビューする時

[コードレビューはつまらないから丁寧なプルリクエストでチームの生産性向上を目指す](https://blog.tai2.net/how-to-code-review.html)

[Google に学ぶコードレビューのポイント](https://cloudsmith.co.jp/blog/efficient/2021/08/1866630.html)

[レビュアーの時によく使う GitHub の便利機能](https://qiita.com/kata_1997/items/fd6cd3009e3d7704f984)

- レビューに粒度はありません
  - 気軽にレビューしていきましょう
  - 気軽に質問していきましょう

## コメントする方へ

以下のようなラベルをつけると温度感や、ざっくりと伝えたいことががわかります(小文字でも OK です。厳密な使い分けは不要です)

- **[MUST]** 必ず修正・変更して欲しい
- **[WANT]** できれば修正・変更して欲しい
- **[IMO]** (In my opinion) 私の意見では
- **[IMHO]** (In my humble opinion) 私のつたない意見では
- **[nits]** (nitpick) ほんの小さな指摘。インデントミスなどの細かいところに。
- **[ASK]** 質問。わからないことがあれば質問してみましょう。
- **[FYI]** (For Your Informatio) 参考までに
- **[GOTCHA]** やったぜ
- **[NP]** 問題ない

## emoji を探す時に便利です（ご活用ください)

[Copy and Paste Emoji](https://getemoji.com/)

## コードレビューたまりがち問題に直面してるな？と感じたら

[「コードレビューたまりがち問題」を解決するには](https://zenn.dev/shun91/articles/thinking-about-code-review)
