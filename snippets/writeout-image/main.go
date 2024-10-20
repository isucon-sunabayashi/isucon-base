package main

import (
	"fmt"
	"log"

	_ "github.com/go-sql-driver/mysql"
	"github.com/jmoiron/sqlx"
)

type Post struct {
	ID      int    `db:"id"`
	Mime    string `db:"mime"`    // 画像のMIMEタイプが入ってる
	Imgdata []byte `db:"imgdata"` // 画像データがDBに入ってる
}

var (
	db *sqlx.DB
)

func connectDb() {
	dsn := fmt.Sprintf(
		"%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&parseTime=true&loc=Local&interpolateParams=true",
		"isuconp",
		"isuconp",
		"localhost",
		"3306",
		"isuconp",
	)

	var err error
	db, err = sqlx.Open("mysql", dsn)
	if err != nil {
		log.Fatalf("Failed to connect to DB: %s.", err.Error())
	}
	defer db.Close()
}

func main() {
	connectDb()
	writeout()
}
