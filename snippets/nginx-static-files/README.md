静的ファイルをNginxで返す(css, js, ico)
----

1. `make alp-result` の結果を見て、〇〇.cssやfavicon.icoや〇〇.jsなどがあるかどうか
2. ない場合は、ここでおしまい(することなし)
3. ある場合は、nginxで返すようにし、さらにはキャッシュするようにする
  - isu-common/etc/nginx/sites-available/isucon.confをいじる

```
ssh isu-1
〇〇.cssなどの場所を探す
```

サンプル: private_isu
----

**ルーティング**

- /favicon.ico
- /js/timeago.min.js
- /js/main.js
- /css/style.css

```
tree /home/isucon/private_isu/webapp/public/
/home/isucon/private_isu/webapp/public/
├── css
│   └── style.css
├── favicon.ico
├── img
│   └── ajax-loader.gif
└── js
├── main.js
└── timeago.min.js

4 directories, 5 files
```

ということで、nginxは以下のようになる

```
# /etc/nginx/sites-available/isucon.conf

server {
  listen 80;

  # ~: 正規表現でマッチング
  # コピペで参考にする場合、ここから
  root /home/isucon/private_isu/webapp/public/;
  location ~ ^/(favicon\.ico|css/|js/|img/) {
    expires 120s;
  }
  # ここまで

  location / {
    proxy_set_header Host $host;
    proxy_pass http://localhost:8080;
  }
}
```

### Tips

`expires 120s;` はレスポンスヘッダに

- `Cache-Control: max-age=120`
- `Expires キャッシュが切れる時間(最小単位: 秒)`

を付与する

キャッシュ期間中は、ブラウザはキャッシュされたリソースを使用するため、リクエストされない

https://developer.mozilla.org/en-US/docs/Web/HTTP/Caching

> As long as the stored response remains fresh, it will be used to fulfill client requests.
> 保存されたレスポンス(=キャッシュ)が新鮮である限り、クライアントのリクエストを満たすためにそれは使用される

<details><summary>ちなみにHTTP/1.1ではExpiresヘッダは不要そう</summary>

> However, the time format is difficult to parse, many implementation bugs were found, and it is possible to induce problems by intentionally shifting the system clock; therefore, max-age — for specifying an elapsed time — was adopted for Cache-Control in HTTP/1.1.
> この時間形式は解析が難しく、多くの実装上のバグが見つかり、また、システムクロックを意図的にずらすことで問題を引き起こすことも可能であるため、HTTP/1.1のキャッシュコントロールには、経過時間を指定するためのmax-ageが採用された
> If both Expires and Cache-Control: max-age are available, max-age is defined to be preferred. So it is not necessary to provide Expires now that HTTP/1.1 is widely used.
> ExpiresとCache-Control: max-ageの両方が指定されている場合、max-ageが優先される。そのため、現在ではHTTP/1.1が広く使用されているため、Expiresを指定する必要はない。

</details>


<details><summary>expires無しのレスポンス</summary>

```
$ curl -I http://〇〇/css/style.css
HTTP/1.1 200 OK
Server: nginx/1.24.0 (Ubuntu)
Date: Sat, 30 Nov 2024 09:35:56 GMT
Content-Type: text/css
Content-Length: 1549
Last-Modified: Sun, 02 Jun 2024 04:43:13 GMT
Connection: keep-alive
ETag: "665bf861-60d"
Accept-Ranges: bytes
```

</details>

<details><summary>expires有りのレスポンス</summary>

```
# expires有り
$ curl -I http://〇〇/css/style.css
HTTP/1.1 200 OK
Server: nginx/1.24.0 (Ubuntu)
Date: Sat, 30 Nov 2024 09:33:08 GMT
Content-Type: text/css
Content-Length: 1549
Last-Modified: Sun, 02 Jun 2024 04:43:13 GMT
Connection: keep-alive
ETag: "665bf861-60d"
Expires: Sat, 30 Nov 2024 09:35:08 GMT ← 追加された箇所-1
Cache-Control: max-age=120             ← 追加された箇所-2
Accept-Ranges: bytes
```

</details>
