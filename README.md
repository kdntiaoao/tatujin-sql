# 達人に学ぶSQL徹底指南書 学習用リポジトリ

## リンク

- https://www.shoeisha.co.jp/book/detail/9784798157825

## お試し環境

### better-sqlite3 を使った方法

#### 1. インストール

```bash
pnpm i --frozen-lockfile
```

#### 2. テーブルの作成

src/create-table.js　に追加したいテーブルのSQLを記載して、以下のコマンドを実行する

```bash
node src/create-table.js
```

#### 3. データの挿入

src/add-data.js に追加したいデータのSQLを記載して、以下のコマンドを実行する

```bash
node src/add-data.js
```

#### 4. データの確認

src/get-data.js に取得したいデータのSQLを記載して、以下のコマンドを実行する

```bash
node src/get-data.js
```
