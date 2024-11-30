画像ファイルをNginxで返す
----

1. `make alp-result` の結果を見て、〇〇.pngやfavicon.gifや〇〇.jpegなどがあるかどうか
2. ない場合は、ここでおしまい(することなし)
3. ある場合は、1回nginxで返すようにし、さらにはキャッシュし、nginxレイヤでない場合はアプリに任せる
  - isu-common/etc/nginx/sites-available/isucon.confをいじる

```
ssh isu-1
〇〇.png等の場所を決める(アプリ側とも相談)
```

サンプル: private_isu
----

**ルーティング**

- /image/\d+.(jpg|png|gif)

場所の決定: /home/isucon/private_isu/webapp/images/

```
tree /home/isucon/private_isu/webapp/images | head -n 5
/home/isucon/private_isu/webapp/images
├── 1.jpg
├── 10.jpg
├── 100.jpg
├── 1000.jpg
```

ということで、nginxは以下のようになる

```
# /etc/nginx/sites-available/isucon.conf

server {
  listen 80;

  root /home/isucon/private_isu/webapp/public/;
  location ~ ^/(favicon\.ico|css/|js/|img/) {
    expires 120s;
  }
  
  # コピペで参考にする場合、ここから
  location /image/ {
    alias /home/isucon/private_isu/webapp/images/;
    try_files $uri @app;
    expires 120s;
  }
  location @app {
    proxy_set_header Host $host;
    proxy_pass http://localhost:8080;
    expires 120s; # @appに内部リダイレクト元の `expires 〇〇s;` は効かない。そのためここでもexpiresを指定
  }
  # ここまで
  
  location / {
    proxy_set_header Host $host;
    proxy_pass http://localhost:8080;
  }
}
```

### Tips

`alias` を利用することで、 `/image/〇〇` の `${alias}/〇〇` で探す

`root` だと、 `/image/〇〇` の `${root}/image/〇〇` で探す

### Tips2

try_filesによる `@app` と `location @app` は、 `upstream app {}` で代替できるわけではない (= `location @app` は必要)

`@〇〇` のことを「名前付きロケーション」というらしい

`try_files $uri app;` では、 upstream app {} ではなく、 app への内部リダイレクトみたいな解釈をするらしい

[nginxのtry_filesわかりにくすぎ問題](https://tsyama.hatenablog.com/entry/try_files_is_difficult)

### Tips3

アプリ側で必ず書き出しをするようになったら、try_files部分を削除し、 `location @app {}` も不要になる

しかし、アプリ側で追加で書き出ししたファイルはinitializeの度に削除する必要がある

```go
// /home/isucon/private_isu/webapp/image/ 以下の10000番以降の画像ファイルを削除
func cleanImages() {
    files, err := os.ReadDir("/home/isucon/private_isu/webapp/images")
    if err != nil {
        slog.Error("os.ReadDirに失敗", err)
        return
    }

    for _, file := range files {
        filename := file.Name()
        split := strings.Split(filename, ".")
        idx, err := strconv.Atoi(split[0])
        if err != nil {
            slog.Error("画像ファイル名が不正", err, "filename", filename)
            continue
        }
        if idx > 10000 {
            filepath := fmt.Sprintf("/home/isucon/private_isu/webapp/image/%s", filename)
            err := os.Remove(filepath)
            if err != nil {
                slog.Error("画像ファイルの削除に失敗", err, "filepath", filepath)
            }
        }
    }
}
```
