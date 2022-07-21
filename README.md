# Buzzcord(バズコード)

<img src="https://user-images.githubusercontent.com/82434093/178455431-23131f5c-1380-4d12-a115-bd6d4c2800bb.png">

### 昨日 Discord サーバー内でバズった発言、「Buzzcord ランキング」をチェックしよう！

**Buzzcord**は、Discord の所属サーバー内で昨日、1 番バズった発言(→ バズコード)を DiscordBot が自動で集計を行い、毎日決まった時間に第 1 位をお知らせ投稿にて紹介してくれるサービスです。

- 「バズった」とは?
  - Discord に投稿された発言がたくさんの人に注目されて【絵文字スタンプが多く押された】こと

## 特徴

- Buzzcord のお知らせによって、Discord 内のチャンネル数が多くて全てを見て回るのが難しいときでも、昨日みんなが一番絵文字スタンプで反応した発言を簡単に知ることができます。

- web サイトでは、昨日の 1 番だけでなく Buzzcord ランキングベスト 5 を知ることができます。

## 開発環境

- Ruby 3.1.0
- Rails 6.1.6

## 機能概要

### DiscordBot の動き

- DiscordBot がサーバー内に常駐し、公開されているテキストチャンネル内で投稿に対して付加・削除された絵文字スタンプでのリアクションを収集します。
- 集められたデータは日付が変わった後に前日 1 日分を集計、ランキング情報を作成します。
- 毎日決まった時間に、設定した Discord のチャンネルに第 1 位の発言のご紹介を投稿します。
- ユーザー登録情報の変更があった際にはサービス内のユーザー情報も同期して更新します。

### Web サイト

- Bot を設定しているサーバーの前日の Buzzcord ランキング 1〜5 位の発言をご覧いただけます。
- Bot を設定したサーバーのメンバーのみがログインできます。
- サーバーから去ったメンバーは自動的にこのサービスから削除されます。

## 利用方法

### Discord の Application の作成

https://discordapp.com/developers/applications/

#### Bot の設定

- Developer Portal から 新しい Application を作成し、Bot を作成して Token を環境変数に設定する
- 「Privileged Gateway Intents」内の項目 3 つ(PRESENSE INTENT,SERVER MEMBERS INTENT,MESSAGE CONTENT INTENT) を ON にして保存する
- OAuth2 の 「URL Generator」のページ内の SCOPES 欄 の「Bot」 をチェック、BOT PERMISSIONS 欄 の 「Send Messages」 をチェックする
- 発行された URL から Bot をサーバーに招待する

#### OAuth2 の設定

- Developer Portal の OAuth2 の 「Add Redirect」をクリックしてリダイレクト URL を設定して、保存する。
  https://アドレス/auth/discord/callback
- OAuth2 の Client ID と Client Secret を環境変数に設定する

### 環境変数の設定

| 環境変数名            | 説明                                              |
| --------------------- | ------------------------------------------------- |
| DISCORD_BOT_TOKEN     | Bot の Token                                      |
| DISCORD_SERVER_ID     | Bot を招待し、活動させる Discord サーバーの ID    |
| DISCORD_CLIENT_ID     | OAuth2 の Client ID                               |
| DISCORD_CLIENT_SECRET | OAuth2 の Client Secret                           |
| DISCORD_CHANNEL_ID    | Bot からのお知らせ投稿を送信したいチャンネルの ID |
| URL_HOST              | ローカルの場合は`127.0.0.1:3000`                  |

Discord の個人設定の詳細設定から開発者モードを ON にすると、サーバーやチャンネルの ID を取得できるようになります。

### インストール

```bash
$ bin/setup
$ bin/rails server
$ bin/webpack-dev-server
```

### Rake Task

- `bin/rails discord_bot:start`で Bot をオンライン状態にして活動をスタートさせます。Heroku で動かす際は Dynos に表示されるこのコマンドを ON にしてください。

  - 🚨 絵文字スタンプ情報の収集やユーザーの自動削除更新機能は Bot をオンライン状態にしていないと機能しません。Heroku の無料枠で利用している場合は一定期間活動がないと Bot がスリープ状態になってしまうようなので、Heroku Scheduler で 10 分おきにアクセスするなどで対応をお願いします。

- `bin/rails ranks:create`を実行することによって、前日分のデータを集計し、ランキング情報を作成します。

  - 🚨Heroku で動かす際は Heroku Scheduler にこのコマンドを登録してください。(設定時間は日付が変わってから、discord メンバーの活動が少ない時間がおすすめです。)

- `bin/rails ranks:post_buzzcord `を実行することによって、Discord 内の指定したチャンネルに Buzzcord ランキング第 1 位のお知らせを投稿します。
  - 🚨Heroku で動かす際は Heroku Scheduler にこのコマンドを登録してください。(設定時間は朝のうちの、discord メンバーの活動が始まる時間がおすすめです。)

## テスト

```bash
$ bundle exec rspec
```

## ScreenShots

- Discord の発言に押された絵文字スタンプ数を bot が毎日自動で収集&集計します。(発言の下に並んでいるのが絵文字スタンプです。)

![discord_example](https://user-images.githubusercontent.com/82434093/173518163-30aa5f61-97e4-4cce-b039-9959d862c439.png)

- 毎日定時に、前日のランキング第 1 位を Discord でお知らせします。

<img src="https://user-images.githubusercontent.com/82434093/178436878-1c56ba73-c6ec-4fcc-9751-5e7d5399e3ef.png" width="50%">

- Web サイトにログインすると前日のランキング第 1 位〜5 位がチェックできます。

左:ログイン前、右:ログイン後

<img alt="buzzcord_view" src="https://user-images.githubusercontent.com/82434093/178435921-e0343125-37c7-492c-9d3f-ce9fe5fe2a1b.png">
