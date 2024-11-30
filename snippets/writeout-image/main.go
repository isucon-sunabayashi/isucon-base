package main

import (
	"fmt"
	"log"
	"log/slog"
	"os"

	_ "github.com/go-sql-driver/mysql"
	"github.com/jmoiron/sqlx"
)

//
// go run main.go
//

// 変更する箇所
var (
	db       *sqlx.DB
	IMG_PATH = "/home/isucon/private_isu/webapp/images"
	SQL      = "SELECT id, mime, imgdata FROM posts WHERE id <= 10000 ORDER BY id ASC LIMIT ? OFFSET ?"
	LIMIT    = 100
	// DB周り(isuconユーザーはこっちで作っている。主に見るべきはテーブル名・structのカラム名・DB名)
	DB_USER = "isucon"
	DB_PASS = "isucon"
	DB_NAME = "isuconp"
)

type Post struct {
	ID      int    `db:"id"`
	Mime    string `db:"mime"`    // 画像のMIMEタイプが入ってる
	Imgdata []byte `db:"imgdata"` // 画像データがDBに入ってる
}

func connectDb() {
	dsn := fmt.Sprintf(
		"%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&parseTime=true&loc=Local&interpolateParams=true",
		DB_USER,
		DB_PASS,
		"localhost",
		"3306",
		DB_NAME,
	)

	var err error
	db, err = sqlx.Open("mysql", dsn)
	if err != nil {
		log.Fatalf("Failed to connect to DB: %s.", err.Error())
	}
}

func main() {
	connectDb()
	defer db.Close()
	writeout()
}

func writeout() {
	// mkdir -p ${IMG_PATH}
	if err := os.MkdirAll(IMG_PATH, 0755); err != nil {
		slog.Error("os.MkdirAllでエラー", err)
		return
	}

	offset := 0
	for {
		posts := []Post{}
		err := db.Select(&posts, SQL, LIMIT, offset)
		if err != nil {
			slog.Error("db.Selectでエラー", err, "limit", LIMIT, "offset", offset)
			return
		}
		if len(posts) == 0 {
			break
		}

		//
		// ファイルの書き出し
		//
		for _, post := range posts {
			filename := fmt.Sprintf("%s/%d.%s", IMG_PATH, post.ID, getExtension(post.Mime))
			_, err := os.Stat(filename)
			if os.IsNotExist(err) {
				// ここで画像の書き出し
				err := os.WriteFile(filename, post.Imgdata, 0644)
				if err != nil {
					slog.Error("os.WriteFileでエラー", err, "filename", filename)
					return
				}
				slog.Info("画像書き出し成功", "filename", filename)
			} else {
				// 書き出ししない
				slog.Info("既に存在しているので、書き出しをスキップします", "filename", filename)
			}
		}
		offset += LIMIT
	}
}

func getExtension(mime string) string {
	switch mime {
	case "image/jpeg":
		return "jpg"
	case "image/png":
		return "png"
	case "image/gif":
		return "gif"
	default:
		return "jpg"
	}
}
