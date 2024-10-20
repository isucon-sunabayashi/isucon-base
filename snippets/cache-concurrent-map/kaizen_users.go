package main

import (
	"log/slog"
	"strconv"

	cmap "github.com/orcaman/concurrent-map/v2"
)

var (
	userCacheById          = cmap.New[*User]()
	userCacheByAccountName = cmap.New[*User]()
)

func initializeCache() {
	var users []*User
	if err := db.Select(&users, "SELECT * FROM users;"); err != nil {
		slog.Error("ユーザー一覧取得に失敗", err)
		return
	}
	userCacheById.Clear()
	userCacheByAccountName.Clear()
	for _, user := range users {
		setUserCache(user)
	}
}

// キャッシュする
func setUserCache(user *User) {
	userCacheById.Set(strconv.Itoa(user.ID), user)
	userCacheByAccountName.Set(user.AccountName, user)
}

// キャッシュから取得
func getUserById(id int) *User {
	if user, ok := userCacheById.Get(strconv.Itoa(id)); ok {
		return user
	} else {
		return nil
	}
}

// キャッシュから取得
func getUserByAccountName(accountName string) *User {
	if user, ok := userCacheByAccountName.Get(accountName); ok {
		return user
	} else {
		return nil
	}
}
