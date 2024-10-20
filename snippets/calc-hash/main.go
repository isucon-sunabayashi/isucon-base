package main

import (
	"crypto/sha256"
	"fmt"
)

// sha256sum webapp/img/NoImage.jpg
// d9f8294e9d895f81ce62e73dc7d5dff862a4fa40bd4e0fecf53f7526a8edcac0  webapp/img/NoImage.jpg
var fallbackImageHash = "d9f8294e9d895f81ce62e73dc7d5dff862a4fa40bd4e0fecf53f7526a8edcac0"

type PostIconRequest struct {
	Image []byte `json:"image"`
}

// ハッシュ値計算
func calcHash(image []byte) string {
	return fmt.Sprintf("%x", sha256.Sum256(image))
}
