# やる気の森

![1](https://github.com/nanamitoshimasu/studying_mate/assets/130431149/0c8940a6-7dc5-48d9-b0a1-6012145fe35c)

## サービス概要
- `やる気の森`は同じような学習目的や目標を持ったプログラミング学習者同士をつなげ、
学習時間を計測し、目標学習時間をチームで達成させる学習時間記録サービスです。
学習時間に応じた「森林」を増やして、絶滅危惧種を救うという世界観で学習に取り組んでいただけます。

## サービスURL
- https://www.yaruki-morimori.com/
## 記事
- https://qiita.com/nanamitoshimasu/items/efb55eb8edf55c2f3a3d

## 想定されるユーザー層
- プログラミング学習を継続して行いたい方。
- 学習時間を確保したい、目標時間を設けて達成させたい方。
- 1人だとつい怠けてしまう方。
- プログラミング学習を通して交流を深めたい方。
- 動物に親しみながら勉強を頑張りたい方。

## サービスコンセプト
- 独学での挫折率9割といわれている、プログラミング学習。
ひとりで学習を進めていると「やる気」や「モチベーション」などの理由から学習時間が思うように取れなかったり、
人間どうしても怠けてしまうことがあります。
わたし自身も学習を進める中で、サボろうとしたり、ダラダラしてしまったりすることが何度かありました。
もくもく会に参加したり、学習時間を記録して目標達成できるように学習に取り組むことでなんとか学習を進めていきました。
一緒に学習する仲間を作ることで学習のモチベーションが維持しやすく、気軽に疑問点や不明点を相談しやすくなります。
そういった一緒に頑張る仲間を募り、学習時間をみんなで達成できるような、学習管理サービスを考案しました。
- プログラミング学習者に楽しんでもらえるように、記録した学習時間を`Github`の「草」に見立てた「森林」を増やしてもらい、
チーム全員が目標達成すれば「森林」が増えたことで絶滅に瀕している動物たちを救うことができ、
目標未達の場合は絶滅させてしまう危機感から目標達成を促進させます。


## サービスの機能、使い方
- 一緒に頑張る仲間を募集したい方は、参加人数・頑張る期間・期間中に救いたい絶滅危惧種(目標時間)・どんな仲間を探しているかを登録して、参加者を募ります。
- 参加者は募集一覧から参加したいチームを探して、参加できます。
- 参加者は目標時間や参加人数、開始期間からチームを検索できます。
- 参加した学習チームの期間になったら、チームの学習記録ページから`学習開始`・`学習終了`・`休憩`ボタンを押して、
学習時間の計測を行います。
- 計測した学習時間をチームの目標学習時間に反映させ、目標までの進捗確認ができます。
- 学習目標を全員で達成できたら、絶滅危惧種を救うことができ、目標未達の場合は絶滅します。
- チーム内でメッセージが送れるようにチャットを送り合うことができます。
- マイページから個人の総学習時間数と絶滅の危機から救うことができた動物も確認できます。
- 学習時間計測の際にに、終了ボタンや休憩終了ボタンを押し忘れてしまった場合、編集ができます。
- 学習終了後に学習時間をXへ共有できます。

## 実装機能
  - 認証ログイン機能(Github)
  - プロフィール機能(編集)
  - チームメイト募集一覧
  - チームメイト募集登録(アイキャッチ画像)
  - チームメイト募集編集
  - チームメイト募集削除
  - チームメイト募集詳細
  - チーム参加機能
  - 学習時間計測機能
  - 計測時間編集機能
  - チャット機能(ActionCable)
  - X共有機能

## 使用技術
  - バックエンド : Ruby 3.2.2 / Rails 7.0.8
    - コード解析 / フォーマッター: Rubocop
  - フロントエンド :  JavaScript, Node.js v20.3.0
    - CSSフレームワーク: Tailwind CSS + DaisyUI
  - インフラ : Heroku
    - データベース: PostgreSQL
    - ファイルサーバー: AWS S3
  - 環境構築 : Docker

  ## 画面遷移図
https://www.figma.com/file/APtDnf6tTURLfPYZeyrXrS/%E3%82%84%E3%82%8B%E3%82%82%E3%82%8A%E7%94%BB%E9%9D%A2%E9%81%B7%E7%A7%BB%E5%9B%B3?type=design&node-id=0%3A1&mode=design&t=zRG6aChBaXVxw17S-1

## ER図
[![Image from Gyazo](https://i.gyazo.com/fe205e7efdee3e28e300592addedd8b3.png)](https://gyazo.com/fe205e7efdee3e28e300592addedd8b3)
