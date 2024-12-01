package main

import (
	"fmt"
	"sort"
	"strconv"
	"time"

	cmap "github.com/orcaman/concurrent-map/v2"
)

var (
	userCacheById = cmap.New[*User]()
)

type User struct {
	ID          int       `db:"id"`
	AccountName string    `db:"account_name"`
	DelFlg      int       `db:"del_flg"`
	CreatedAt   time.Time `db:"created_at"`
}

func show(list []*User) {
	for _, user := range list {
		fmt.Printf("%+v\n", user)
	}
}

func users() cmap.ConcurrentMap[string, *User] {
	users := cmap.New[*User]()
	for _, u := range []*User{
		{
			ID:          1,
			AccountName: "test_user",
			DelFlg:      0,
			CreatedAt:   parseTime("2024-11-01T00:00:00+0900"),
		},
		{
			ID:          2,
			AccountName: "test_user2",
			DelFlg:      0,
			CreatedAt:   parseTime("2024-12-01T00:00:00+0900"),
		},
		{
			ID:          3,
			AccountName: "test_user3",
			DelFlg:      0,
			CreatedAt:   parseTime("2024-12-01T00:00:00+0900"),
		},
	} { // forの中身
		users.Set(strconv.Itoa(u.ID), u)
	}
	return users
}

func parseTime(s string) time.Time {
	t, err := time.Parse("2006-01-02T15:04:05+0900", s)
	if err != nil {
		panic(err)
	}
	return t
}

// createdAt順で降順でソート(同一の場合は、AccountNameで昇順)
func sortUsersCreatedAtDescAndAccountNameAsc(users []*User) {
	sort.Slice(users, func(i, j int) bool {
		// 同じ場合
		if users[i].CreatedAt == users[j].CreatedAt {
			// AccountNameで昇順(i < j)
			return users[i].AccountName < users[j].AccountName
		}
		// createdAtで降順(i > j)
		return users[i].CreatedAt.After(users[j].CreatedAt)
	})
}

// concurrent mapを用意する
func main() {
	users := users()
	items := users.Items()
	values := make([]*User, 0, len(items))
	for _, u := range items {
		values = append(values, u)
	}
	fmt.Println("----[ Before ]")
	show(values)
	sortUsersCreatedAtDescAndAccountNameAsc(values)
	fmt.Println("----[ After ]")
	show(values)
}
