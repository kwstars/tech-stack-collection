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
	rdb.MSet(ctx, "foo1", "foo1", "foo2", "foo2")

	tx := rdb.TxPipeline()
	tx.Set(ctx, "foo1", "foo11", 0)
	tx.Set(ctx, "foo2", "foo22", 0)
	tx.Get(ctx, "foo1")
	// go-redis 库中，没有提供直接对应于 Redis DISCARD 命令的方法。
	// Do not call tx.Exec(ctx) to cancel the transaction

	values, err := rdb.MGet(ctx, "foo1", "foo2").Result()
	if err != nil {
		fmt.Println("Error getting values:", err)
	} else {
		fmt.Println("foo1:", values[0])
		fmt.Println("foo2:", values[1])
	}

	rdb.Close()
}
