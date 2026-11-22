package main

import (
	"context"
	"errors"
	"fmt"
	"log"
	"os"

	"cloud.google.com/go/storage"
	"google.golang.org/api/iterator"
)

func main() {
	ctx := context.Background()

	// エミュレータへの接続は環境変数 STORAGE_EMULATOR_HOST で切り替わる。
	client, err := storage.NewClient(ctx)
	if err != nil {
		log.Fatal(err)
	}
	defer client.Close()

	projectID := os.Getenv("GOOGLE_CLOUD_PROJECT")
	if projectID == "" {
		log.Fatal("GOOGLE_CLOUD_PROJECT is not set")
	}

	it := client.Buckets(ctx, projectID)
	for {
		attrs, err := it.Next()
		if errors.Is(err, iterator.Done) {
			break
		}
		if err != nil {
			log.Fatal(err)
		}
		fmt.Println(attrs.Name)
	}
}
