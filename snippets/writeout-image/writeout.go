package main

import (
	"fmt"
	"log/slog"
	"os"
)

func writeout() {
	imgPath := "/home/isucon/private_isu/webapp/image"
	// mkdir -p の代わり
	if err := os.MkdirAll(imgPath, 0755); err != nil {
		slog.Error("os.MkdirAllでエラー", err)
		return
	}

	offset := 0
	limit := 100
	for {
		posts := []Post{}
		err := db.Select(&posts, "SELECT id, mime, imgdata FROM posts WHERE id <= 10000 ORDER BY id ASC LIMIT ? OFFSET ?", limit, offset)
		if err != nil {
			slog.Error("db.Selectでエラー", err, "limit", limit, "offset", offset)
			return
		}
		if len(posts) == 0 {
			break
		}

		for _, post := range posts {
			filename := fmt.Sprintf("%s/%d.%s", imgPath, post.ID, getExtension(post.Mime))

			// ここで画像の書き出し
			err := os.WriteFile(filename, post.Imgdata, 0644)
			if err != nil {
				slog.Error("os.WriteFileでエラー", err, "filename", filename)
				return
			}
			slog.Info("画像書き出し成功", "filename", filename)
		}
		offset += limit
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
