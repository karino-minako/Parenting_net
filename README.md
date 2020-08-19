<img width="873" alt="readme-fix" src="https://user-images.githubusercontent.com/63790886/90463496-0836f080-e146-11ea-930f-f3b78a13f6a5.png">

# 子育てネット

## サイト概要
ご覧いただきありがとうございます。こちらは就職活動のためポートフォリオとして作成したSNSとQ&A両方の形式を組み合わせた Web アプリケーションです。 (4月16日学習開始 / 7月15日公開)
<br>
サイトへはこちらから(https://parenting-net-2.work/)

## なぜ子育てネットを作ったか
子育てネットは子育てに関する日常の共有や悩みの解決を目的とした SNS + Q&A サイトです。
現状、子育てに関するサイトは、SNS・Q&Aどちらかの形式が多いと考え、両方の形式を取り入れたサイトがあれば、より多くのユーザに使ってもらうことが可能になると考えました。

## 技術面
### 言語・環境等

- RubyonRails(5.2.4.3)
- Ruby(2.5.7)
- javascript
- jQuery
- Vagrant
- AWS(EC2 / EIP / RDS / Certificate Manager / S3 / ALB /Lambda)

### 使用した技術

- Bootstrap(CSSフレームワーク)
- Rspec(テストフレームワーク)
- devise(ユーザー認証)
- kaminari(ページネーション)
- refile(画像投稿機能)
- acts-as-taggable-on(タグ付け)
- rails-i18n(多言語化)
- dotenv-rails(環境変数化)

## スクリーンショット

### ActionMailerを利用した新規登録完了メール
<img width="942" alt="mail" src="https://user-images.githubusercontent.com/63790886/90583547-6679d700-e20b-11ea-8e44-c13fcdf07b63.png">

### チャット(Gemを使わずに実装)＆通知機能
![chat-move](https://user-images.githubusercontent.com/63790886/90602164-41e62500-e234-11ea-99b3-029ba0199360.gif)

## 設計書

### AWS構成図
<img width="419" alt="aws" src="https://user-images.githubusercontent.com/63790886/90584272-39c6bf00-e20d-11ea-91e8-154877eea2e3.png">

### 機能一覧
https://docs.google.com/spreadsheets/d/1LJX8CJAoy1UPZLBxU8R3bZ3ZLrB5h5Uk23fIBGNPHkA/edit?usp=sharing