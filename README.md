# 達人に学ぶSQL徹底指南書 学習用リポジトリ

## リンク

- https://www.shoeisha.co.jp/book/detail/9784798157825

## お試し環境

### docker を使った方法

```bash
# PostgreSQL のコンテナを起動する
docker run --name postgres-playground -e POSTGRES_PASSWORD=password postgres
docker run --name tatujin-sql-playground -e POSTGRES_PASSWORD=password postgres

# コンテナ内の postgres データベースに postgres ユーザーで接続する
docker exec -it postgres-playground psql -U postgres -d postgres
docker exec -it tatujin-sql-playground psql -U postgres -d postgres

# PostgreSQL のコンテナを再起動する
docker start -ai postgres-playground

# PostgreSQL のコンテナを削除する
docker rm postgres-playground
```

### PostgreSQL のコマンド例

```sql
# データベース一覧
\l
SELECT datname FROM pg_database;

# データベースの作成
CREATE DATABASE playground;

# テーブル一覧
\dt
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';
```

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

## フォーマット

### SQLFluff を使った方法

```bash
sqlfluff fix sample.sql
```

### Prettier plugin SQL-CST を使った方法

```bash
pnx prettier -w sample.sql
```

### SQL Formatter を使った方法

```bash
# SQL をフォーマットしてクリップボードにコピーする
echo 'select * from tbl where id = 3' | pnx sql-formatter | tee >(pbcopy)

# ファイルをフォーマットする
pnx sql-formatter sample.sql -o sample.sql
cat sample.sql | pnx sql-formatter | tee sample.sql
```
