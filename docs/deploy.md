# VPS への自動デプロイ設定ガイド

このドキュメントでは、GitHub Actions を使って Sakura Internet VPS へ自動デプロイするための設定手順を説明します。

---

## 1. デプロイ用 SSH キーペアの生成

ローカルマシンで以下のコマンドを実行し、デプロイ専用の SSH キーペアを生成します。  
パスフレーズは**空のまま**（Enter キーを押す）にしてください。

```bash
ssh-keygen -t ed25519 -C "github-actions-deploy" -f ~/.ssh/deploy_key -N ""
```

生成されるファイル:
- `~/.ssh/deploy_key` — 秘密鍵（GitHub Actions シークレットに登録する）
- `~/.ssh/deploy_key.pub` — 公開鍵（VPS の `authorized_keys` に登録する）

---

## 2. 公開鍵を VPS に登録する

VPS にログインし、公開鍵を `authorized_keys` に追加します。

```bash
# ローカルで公開鍵の内容を確認
cat ~/.ssh/deploy_key.pub

# VPS にログイン後、authorized_keys に追記
mkdir -p ~/.ssh
chmod 700 ~/.ssh
echo "<上記で表示された公開鍵の内容>" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

または `ssh-copy-id` を使う方法:

```bash
ssh-copy-id -i ~/.ssh/deploy_key.pub -p <SSHポート> <ユーザー名>@<VPSのホスト名>
```

---

## 3. GitHub Actions シークレットの設定

GitHub リポジトリの **Settings → Secrets and variables → Actions → New repository secret** から、以下のシークレットを登録します。

| シークレット名   | 内容                                          | 必須 |
|-----------------|-----------------------------------------------|------|
| `VPS_HOST`      | VPS のホスト名または IP アドレス              | ✅   |
| `VPS_USER`      | SSH ログインユーザー名                        | ✅   |
| `VPS_SSH_KEY`   | 秘密鍵の内容（`cat ~/.ssh/deploy_key` の出力）| ✅   |
| `VPS_TARGET_DIR`| VPS 上のデプロイ先ディレクトリ（絶対パス）    | ✅   |
| `VPS_PORT`      | SSH ポート番号（省略時は `22`）               | ☑️   |

`VPS_SSH_KEY` には秘密鍵の全テキストをそのまま貼り付けてください（`-----BEGIN...` から `-----END...` まで）。

---

## 4. VPS 上のデプロイ先ディレクトリの準備

デプロイ先ディレクトリを作成し、SSH ユーザーが書き込めるようにします。

```bash
# 例: /var/www/tenkilog にデプロイする場合
sudo mkdir -p /var/www/tenkilog
sudo chown <ユーザー名>:<ユーザー名> /var/www/tenkilog
```

---

## 5. Nginx の設定例

VPS で Nginx を使用している場合、以下の設定例を参考にしてください。

```nginx
server {
    listen 80;
    server_name your-domain.example.com;

    root /var/www/tenkilog;
    index index.html;

    # React Router (SPA) のための設定
    location / {
        try_files $uri $uri/ /index.html;
    }

    # 静的ファイルのキャッシュ設定
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

設定ファイルを配置後、Nginx を再起動します:

```bash
sudo nginx -t && sudo systemctl reload nginx
```

---

## 6. デプロイの動作確認

上記の設定が完了したら、`main` ブランチにプッシュすることでデプロイが自動実行されます。

1. GitHub リポジトリの **Actions** タブでワークフローの実行状況を確認できます。
2. 正常に完了すると、VPS の `VPS_TARGET_DIR` にビルド成果物が同期されます。
3. `--delete` オプションにより、古いファイルは自動的に削除されます。

---

## トラブルシューティング

- **SSH 接続に失敗する場合**: VPS のファイアウォールで SSH ポートが開放されているか確認してください。
- **rsync コマンドが見つからない場合**: VPS に rsync がインストールされているか確認してください（`sudo apt install rsync`）。
- **権限エラーが発生する場合**: `VPS_TARGET_DIR` の所有者とパーミッションを確認してください。
