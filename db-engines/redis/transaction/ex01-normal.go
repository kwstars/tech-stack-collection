//go:build ignore

package main

import (
	"context"
	"fmt"

	"github.com/redis/go-redis/v9"
)

func main() {
	ctx := context.Background()

	rdb := redis.NewClient(&redis.Options{
		Addr:     "localhost:6379",
		Password: "", // no password set
		DB:       0,  // use default DB
	})

	_, err := rdb.Ping(ctx).Result()
	if err != nil {
		fmt.Println("Redis connection error:", err)
		return
	}

	rdb.Del(ctx, "foo1", "foo2")

	pipe := rdb.TxPipeline()
	pipe.Set(ctx, "foo1", "foo1", 0)
	pipe.Set(ctx, "foo2", "foo2", 0)
	pipe.Get(ctx, "foo1")
	_, err = pipe.Exec(ctx)
	if err != nil {
		fmt.Println("Error executing transaction:", err)
	} else {
		fmt.Println("Transaction executed successfully")
	}

	values, err := rdb.MGet(ctx, "foo1", "foo2").Result()
	if err != nil {
		fmt.Println("Error getting values:", err)
	} else {
		fmt.Println("foo1:", values[0])
		fmt.Println("foo2:", values[1])
	}

	rdb.Close()
}
